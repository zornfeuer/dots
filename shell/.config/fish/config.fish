set -U fish_greeting
zoxide init fish | source

status is-interactive; and begin
    alias e 'eza -l --icons'
    alias ea 'eza -la --icons'
    alias ff fastfetch
    alias v nvim
    alias cr 'cargo run'
    alias crr 'cargo run --release'
    alias cb 'cargo build'
    alias cbr 'cargo build --release'
    alias ct 'cargo test'
    alias ca 'cargo add'
    alias cl 'cargo llvm-cov --all-features --workspace --html'
    alias ni 'bun install'
    alias nr 'bun run'
    alias nx 'bunx'

    function fish_prompt
        set -l last_status $status
        set -l stat
        if test $last_status -ne 0
            set stat (set_color red)"[$last_status]"(set_color yellow)
        end

        string join "" -- (set_color green) (prompt_pwd) ' ' (set_color yellow) $stat '> '
    end
end
