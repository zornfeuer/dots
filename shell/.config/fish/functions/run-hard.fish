function run-hard --description "Run complex command on remote host by port"
    set -l port $argv[1]

    if test -z "$port"
        echo "usage: run <port> <command...>" >&2
        return 1
    end

    if test (count $argv) -lt 2
        echo "usage: run <port> <command...>" >&2
        return 1
    end

    set -l remote_cmd (string join " " $argv[2..-1])

    ssh "$REMOTE_SSH_USER@$REMOTE_SSH_HOST" -p $port -- sh -lc (string escape -- $remote_cmd)
end
