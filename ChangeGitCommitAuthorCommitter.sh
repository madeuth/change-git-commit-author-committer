#!/bin/sh

# Globals
NEW_NAME=
OLD_NAME=
NEW_EMAIL=
OLD_EMAIL=
FILTER=

# Getters
get_new_name() {
    echo -n "What is your new username? "
    read NEW_NAME
}

get_new_email() {
    echo -n "What is your new email address? "
    read NEW_EMAIL
}

get_old_name() {
    echo -n "What is your old username? "
    read OLD_NAME
}

get_old_email() {
    echo -n "What is your old email address? "
    read OLD_EMAIL
}

build_filter() {
    if [ -n "$NEW_NAME" -a -n "$NEW_EMAIL" ]
    then
        if [ -z "$OLD_NAME" -a -z "$OLD_EMAIL" ]
        then
            FILTER='
                export GIT_AUTHOR_NAME='$NEW_NAME'
                export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                export GIT_COMMITTER_NAME='$NEW_NAME'
                export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
            '
        elif [ -n "$OLD_NAME" -a -n "$OLD_EMAIL" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_NAME" = '$OLD_NAME' -a "$GIT_AUTHOR_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_AUTHOR_NAME='$NEW_NAME'
                    export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                fi
                if [ "$GIT_COMMITTER_NAME" = '$OLD_NAME' -a "$GIT_COMMITTER_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_NAME='$NEW_NAME'
                    export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
                fi
            '
        elif [ -n "$OLD_NAME" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_NAME" = '$OLD_NAME' ]
                then
                    export GIT_AUTHOR_NAME='$NEW_NAME'
                    export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                fi
                if [ "$GIT_COMMITTER_NAME" = '$OLD_NAME' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_NAME='$NEW_NAME'
                    export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
                fi
            '
        elif [ -n "$OLD_EMAIL" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_AUTHOR_NAME='$NEW_NAME'
                    export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                fi
                if [ "$GIT_COMMITTER_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_NAME='$NEW_NAME'
                    export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
                fi
            '
        fi
    elif [ -n "$NEW_NAME" ]
    then
        if [ -z "$OLD_NAME" -a -z "$OLD_EMAIL" ]
        then
            FILTER='
                export GIT_AUTHOR_NAME='$NEW_NAME'
                export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                export GIT_COMMITTER_NAME='$NEW_NAME'
            '
        elif [ -n "$OLD_NAME" -a -n "$OLD_EMAIL" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_NAME" = '$OLD_NAME' -a "$GIT_AUTHOR_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_AUTHOR_NAME='$NEW_NAME'
                fi
                if [ "$GIT_COMMITTER_NAME" = '$OLD_NAME' -a "$GIT_COMMITTER_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_NAME='$NEW_NAME'
                fi
            '
        elif [ -n "$OLD_NAME" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_NAME" = '$OLD_NAME' ]
                then
                    export GIT_AUTHOR_NAME='$NEW_NAME'
                fi
                if [ "$GIT_COMMITTER_NAME" = '$OLD_NAME' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_NAME='$NEW_NAME'
                fi
            '
        elif [ -n "$OLD_EMAIL" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_AUTHOR_NAME='$NEW_NAME'
                fi
                if [ "$GIT_COMMITTER_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_NAME='$NEW_NAME'
                fi
            '
        fi
    elif [ -n "$NEW_EMAIL" ]
    then
        if [ -z "$OLD_NAME" -a -z "$OLD_EMAIL" ]
        then
            FILTER='
                export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
            '
        elif [ -n "$OLD_NAME" -a -n "$OLD_EMAIL" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_NAME" = '$OLD_NAME' -a "$GIT_AUTHOR_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                fi
                if [ "$GIT_COMMITTER_NAME" = '$OLD_NAME' -a "$GIT_COMMITTER_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
                fi
            '
        elif [ -n "$OLD_NAME" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_NAME" = '$OLD_NAME' ]
                then
                    export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                fi
                if [ "$GIT_COMMITTER_NAME" = '$OLD_NAME' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
                fi
            '
        elif [ -n "$OLD_EMAIL" ]
        then
            FILTER='
                if [ "$GIT_AUTHOR_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_AUTHOR_EMAIL='$NEW_EMAIL'
                fi
                if [ "$GIT_COMMITTER_EMAIL" = '$OLD_EMAIL' ]
                then
                    export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
                    export GIT_COMMITTER_EMAIL='$NEW_EMAIL'
                fi
            '
        fi
    fi
}

# Greetings
echo "Welcome!"

while : ;
do
    # What to change
    while : ;
    do
        echo "What commit info do you want to change about author/committer?"
        echo "1) username 2) email address 3) both 4) exit"
        read choice
        case $choice in
            1)
                get_new_name
                break
                ;;
            2)
                get_new_email
                break
                ;;
            3)
                get_new_name
                get_new_email
                break
                ;;
            4)
                echo "Goodbye!"
                exit
                ;;
            *)
                echo "Unknown parameter, please choose a correct option."
                ;;
        esac
    done

    # How to change
    while : ;
    do
        echo "How do you want to filter out commits?"
        echo "0) no-filter 1) username 2) email address 3) both 4) exit"
        read choice
        case $choice in
            0)
                break
                ;;
            1)
                get_old_name
                break
                ;;
            2)
                get_old_email
                break
                ;;
            3)
                get_old_name
                get_old_email
                break
                ;;
            4)
                echo "Goodbye!"
                exit
                ;;
            *)
                echo "Unknown parameter, please choose a correct option."
                ;;
        esac
    done

    # Build filter
    VARS="
        NEW_NAME=$NEW_NAME
        OLD_NAME=$OLD_NAME
        NEW_EMAIL=$NEW_EMAIL
        OLD_EMAIL=$OLD_EMAIL
    "
    build_filter

    # Execute query
    while : ;
    do
        echo "Are you sure you want to apply those changes? This action is irreversible."
        echo "y) yes n) no"
        read choice
        case $choice in
            y)
                git filter-branch -f --env-filter "$VARS$FILTER"
                echo "Operation successful!"
                break
                ;;
            n)
                echo "Operation aborted."
                break
                ;;
            *)
                echo "Unknown parameter, please choose a correct option."
                ;;
        esac
    done

    # Run again?
    while : ;
    do
        echo "Do you want to run again?"
        echo "y) yes n) no"
        read choice
        case $choice in
            y)
                break
                ;;
            n)
                echo "Goodbye!"
                exit
                ;;
            *)
                echo "Unknown parameter, please choose a correct option."
                ;;
        esac
    done
done

exit
