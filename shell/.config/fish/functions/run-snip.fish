function run-snip --description "Pick ssh snippet and run it on remote host"
    set -l port $argv[1]

    if test -z "$port"
        echo "usage: run-snippet <port>" >&2
        return 1
    end

    set -l snippet (snip ssh)

    if test $status -ne 0
        return 1
    end

    run-hard $port $snippet
end
