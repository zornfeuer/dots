function srv
    set -l port $argv[1]

    if test -z "$port"
        echo "Usage: srv <port>"
        return 1
    end

    ssh $REMOTE_SSH_USER@$REMOTE_SSH_HOST -p $port
end
