gp () {
    if [ -z "$1" ]; then
        echo 'Usage:'
        echo 'gp pattern [pattern] ...'
        return 1
    fi

    pattern="${1}"
    shift

    if [ -t 0 ]; then
        # stdin is a terminal
        opt1="-nR"
        opt2="."
    else
        opt1=""
        opt2=""
    fi

    if [ $# -ge 1 ]; then
        grep ${opt1} "${pattern}" ${opt2} | gp "${@}"
    else
        grep ${opt1} "${pattern}" ${opt2}
    fi
}
