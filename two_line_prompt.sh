#[{pwd}][{window_name} {window_index}]({branch_name})
#{time}{username}@{hostname}> {cursor here}

printf "\n\n\n"
printf "\033[1;30m|\033[1;32m[`pwd`]\033[m\n"
printf "\033[1;30m|\033[1;36m20:38\033[1;33mpi314\033[m"
printf "@\033[1;37mcychih-PC\033[1;30m[tcsh]\033[m> \n"

printf "\n\n\n"
printf "\033[1;31m|\033[1;32m[`pwd`]\033[m(master)\033[1;34mj:3\n"
printf "\033[1;31m|\033[1;36m20:38\033[1;33mroot\033[m"
printf "@\033[1;37mcychih-PC\033[1;30m[tcsh]\033[1;35m[screen W1]\033[m# \n"

printf "\n\n\n"
printf "\033[1;30m=\033[1;31m=\033[1;32m=\033[1;33m=\033[1;34m="
printf "\033[1;35m=\033[1;36m=\033[1;37m=\033[m"

printf "\n\n\n"

printf "|[/home/cychih/.rcfiles]\n"
printf "|20:38pi314@cychih-PC[`echo $SHELL | rev | cut -d'/' -f1 | rev`]> \n"
printf "\n\n"

#alias update_git_repo_flag "set git_repo_flag=${git_repo_flag}a"

alias precmd 'set prompt="|[%~]`date`\n|%T%n@%m> "'

#set prompt="%{^[[1;36m%}%T%{^[[m%}%{^[[1;33m%}%n%{^[[m%}@%{^[[1;37m%}%m%{^[[1;32m%}[%~]%{^[[m%}%{^[[1;35m%}[$session_name W$WINDOW]%{^[[m%}> "

exit

needed info

-   pwd

    -   green

-   if the shell is in a screen, show window name

    -   purple

-   if pwd is in a git repo, show branch name

    -   blue

-   time

    -   cyan

-   username

    -   bright yellow

-   hostname

    -   bright white

    -   // blue if bash

-   uid (root or mortal)

    -   > if mortal

    -   # if root

-   last command status

    -   display on uid symbol

    -   white if success

    -   red if failed


[{pwd}][{window_name} {window_index}]({branch_name})
{time}{username}@{hostname}> {cursor here}
