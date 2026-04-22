function vf
    set file $(fd . | fzf)
    nvim $file
end
