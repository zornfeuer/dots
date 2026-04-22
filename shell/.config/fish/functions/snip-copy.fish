function snip-copy --description "Pick snippet and copy it to clipboard"
    set -l snippet (snip $argv)

    if test $status -ne 0
        return 1
    end

    printf "%s\n" "$snippet" | wl-copy
    echo "Copied to clipboard"
end
