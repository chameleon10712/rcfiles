fd () {
    if [ "$1" = '' ]; then
        echo 'Filename ಠ_ಠ?'
        return 1
    fi

    find . -name "$1"
}
