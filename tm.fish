function tm -d "Switch tmux session"

    # Check if in tmux session or not
    if test -n "$TMUX"
        set change "switch-client"
    else
        set change "attach-session"
    end

    # Check if session name is entered
    if count $argv > /dev/null
        set session "$argv[1]"
    else
        eval "tmux list-sessions -F \"#{session_name}\" \
        2>/dev/null \
        | fzf --exit-0" | read -l session

        if test -n $session

            tmux $change -t "$session"; return 1
        else
            echo "No sessions found."
            return 1
        end
    end

    # Create/connect to session
    if not tmux $change -t $session 2>/dev/null
        tmux new-session -d -s $session; \
        and tmux $change -t $session
        return
    end

end
