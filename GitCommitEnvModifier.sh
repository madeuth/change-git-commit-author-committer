#!/bin/sh

# Globals
NAME="name"
EMAIL="name@domain.com"
DOMAIN="domain.com"

# Greetings
echo "Welcome to the git commit environment variables modifier assistant."
echo "You can press 'ctrl+c' anytime to quit."

while true
do
    # Get repository name
    echo -n "Type in a repo's name to clone: "
    read repo
    git clone https://$NAME@$DOMAIN/$NAME/$repo.git

    # Moving inside created directory
    cd $repo

    # Get name to filter out commits
    echo -n "Type in a name to match (leave blank to match all commits): "
    read match

    # If match provided then filter out commits
    if [ -n "$match" ] 
    then
        git filter-branch -f --env-filter '
        if [ "$GIT_AUTHOR_NAME" = '$match' ]
        then
            export GIT_AUTHOR_NAME='$NAME'
            export GIT_AUTHOR_EMAIL='$EMAIL'
        fi
        if [ "$GIT_COMMITTER_NAME" = '$match' ]
        then
            export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
            export GIT_COMMITTER_NAME='$NAME'
            export GIT_COMMITTER_EMAIL='$EMAIL'
        fi
        '
    # else modify all commits
    else
        git filter-branch -f --env-filter '
        export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
        export GIT_AUTHOR_NAME='$NAME'
        export GIT_AUTHOR_EMAIL='$EMAIL'
        export GIT_COMMITTER_NAME='$NAME'
        export GIT_COMMITTER_EMAIL='$EMAIL'
        '
    fi

    # Push modifications to repository
    git push -f https://$NAME@$DOMAIN/$NAME/$repo.git
    
    # Moving out of directory
    cd ..

    # Removing directory
    rm -r -f $repo

done

exit