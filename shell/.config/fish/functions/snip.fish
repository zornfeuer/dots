function snip --description "Pick snippet from category and print it"
    set -l dir ~/.config/snippets
    set -l category $argv[1]

    if test -z "$category"
        set category (command ls $dir 2>/dev/null | fzf)
        or return 1
    else
        if not test -f $dir/$category
            if test -f $dir/$category.txt
                set category "$category.txt"
            else if test -f $dir/$category.http
                set category "$category.http"
            else
                echo "Snippet category not found: $category" >&2
                return 1
            end
        end
    end

    set -l file $dir/$category

    if not test -f $file
        echo "Snippet file not found: $file" >&2
        return 1
    end

    set -l choice (
        awk '/^### / { sub(/^### /, ""); print }' $file | fzf
    )
    or return 1

    if test -z "$choice"
        return 1
    end

    awk -v target="$choice" '
        BEGIN { found=0 }
        /^### / {
            name=$0
            sub(/^### /, "", name)
            if (found) exit
            if (name == target) {
                found=1
                next
            }
        }
        found { print }
    ' $file
end
