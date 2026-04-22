function vg
    set line $(rg "$1" | fzf)
    nvim $(echo "$line" | cut -d: -f1)
end
