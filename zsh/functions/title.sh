ZSH_TITLE=""
title () {
    ZSH_TITLE="$*"

    if grep "$ZSH_TITLE" $HOME/.titles >/dev/null 2>&1; then
        true
    else
        echo "$ZSH_TITLE" >> $HOME/.titles 2>/dev/null
    fi

    if [ -n "$TMUX" ]; then
        tmux rename-window "$*"
        return
    fi

    case $ZSH_KERNEL_TYPE in
        "CYGWIN")
            printf "\033]0;$*\007"
            ;;
        *)
            printf "\033]1;$*\a"
    esac
}

chpwd () {
    if [[ -z "$ZSH_TITLE" ]]; then
        ZSH_TITLE=$(basename $PWD)
        title $ZSH_TITLE
    fi
}
