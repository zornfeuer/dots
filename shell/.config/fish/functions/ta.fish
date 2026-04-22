function ta
    set session $(tmux list-sessions 2>/dev/null | cut -d: -f1 | fzf)
    
    if test -n "$session"
        tmux attach -t "$session"
    else
        read -p "New session name: " new_session
        tmux new -s "$new_session"
    end
end
