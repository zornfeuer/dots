function run
    set -l port $argv[1]

    if test -z "$port"
        echo "usage: run <port> <command...>" >&2
        return 1
    end

    if test (count $argv) -lt 2
        echo "usage: run <port> <command...>" >&2
        return 1
    end

    set -l cmd $argv[2..-1]
    ssh "$REMOTE_SSH_USER@$REMOTE_SSH_HOST" -p $port -- $cmd
end
