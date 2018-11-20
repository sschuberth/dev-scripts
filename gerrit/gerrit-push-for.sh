#!/bin/bash

refname="for"
skip=0

while [ -n "$1" ]; do
    case "$1" in
    --help)
        help=true
        ;;
    --draft|-D)
        refname="drafts"
        ;;
    --without-reviewers|-O)
        skip=1
        ;;
    -*)
        echo "Error: Invalid option \"$1\"."
        exit 2
        ;;
    *)
        # Stop parsing options on the first non-option argument.
        break
        ;;
    esac

    shift
done

if [ -n "$help" -o $# -gt 2 ]; then
    echo "Rationale"
    echo "    Push commits of the current branch to Gerrit for review, optionally"
    echo "    determining reviewers excluding those in ~/gerrit-push-for.blacklist."
    echo
    echo "Usage"
    echo "    $(basename $0) [options] [target] [ref]"
    echo
    echo "Example"
    echo "    $(basename $0) development HEAD^"
    echo
    echo "Options"
    echo "    --help"
    echo "        Show this help."
    echo "    --draft, -D"
    echo "        Submit changes as a draft."
    echo "    --without-reviewers, -O"
    echo "        Do not attempt to determine reviewers."
    exit 1
fi

[ $# -ge 1 ] && target=$1 || target=master
[ $# -ge 2 ] && ref=$2 || ref=HEAD

remotes=$(git remote show)
if echo "$remotes" | grep -q ^gerrit$; then
    remote=gerrit
elif echo "$remotes" | grep -q ^origin$; then
    remote=origin
else
    remote=$(echo "$remotes" | head -1)
fi

revlist=$(git rev-list --first-parent $ref --not $remote/$target 2> /dev/null || git rev-list $ref 2> /dev/null)
if [ $? -eq 0 ]; then
    revcount=$(echo "$revlist" | wc -l)
    revcount=$(echo $revcount)
    if [ $revcount -eq 0 ]; then
        echo "Nothing to do, $ref is already merged into $remote/$target."
        exit 3
    fi
else
    revcount="an unknown number of"
fi

# Create changes from the command line with topic and reviewers optionally set, see:
# http://gerrit-documentation.googlecode.com/svn/Documentation/2.6/user-upload.html#push_create

# Specify a topic if we are on a branch different from the target.
topic=$(git rev-parse --abbrev-ref $ref)
topic=${topic#gerrit/}
topic=${topic#${USER-$USERNAME}/}

if [[ "$refname" == "drafts" ]]; then
    entity="draft(s)"
else
    entity="change(s)"
fi

if [[ "$topic" != "" && "$topic" != "HEAD" && "$topic" != "$target" ]]; then
    echo "Going to push $revcount \"$topic\" $entity for \"$remote/$target\"."
    options="%topic=$topic"
else
    echo "Going to push $revcount $entity for \"$remote/$target\"."
fi

if [ $skip -eq 0 ]; then
    # Determine email addresses of potential reviewers (except oneself).
    git contacts 2> /dev/null
    git_contacts_exit_code=$?

    if [ $git_contacts_exit_code -eq 1 ]; then
        read -p "git-contacts not found, do you want to download it? [(Y)es/(n)o] " -n 1 -r
        echo
        if [ "$REPLY" != "n" -a "$REPLY" != "N" ]; then
            exec_path=$(git --exec-path)
            if [ $? -eq 0 -a -n "$exec_path" ]; then
                curl -Lo "$exec_path/git-contacts" https://github.com/git/git/raw/master/contrib/contacts/git-contacts
            fi
        fi

        git contacts 2> /dev/null
        git_contacts_exit_code=$?
    fi

    # Second try after potentially have downloaded git-contacts.
    if [ $git_contacts_exit_code -eq 255 ]; then
        echo "Determining reviewers..."
        user=$(git config user.name)
        reviewers=$(git contacts $remote/$target..$ref 2> /dev/null | grep -iv "$user" | cut -d "<" -f 2 | cut -d ">" -f 1 | sort -u)
        if [ -f ~/gerrit-push-for.whitelist ]; then
            dos2unix -k ~/gerrit-push-for.whitelist 2> /dev/null
            reviewers=$(echo "$reviewers" | grep -f ~/gerrit-push-for.whitelist)
        fi
        if [ -f ~/gerrit-push-for.blacklist ]; then
            dos2unix -k ~/gerrit-push-for.blacklist 2> /dev/null
            reviewers=$(echo "$reviewers" | grep -vf ~/gerrit-push-for.blacklist)
        fi

        if [ "$reviewers" != "" ]; then
            # Determine the reviewer count, stripping (leading) whitespace.
            count=$(echo "$reviewers" | wc -l)
            count=$(echo $count)
            echo "Found $count possible reviewer(s):"

            for email in $reviewers; do
                echo "    $email"
                if [ -n "$r" ]; then
                    r="$r,"
                fi
                r="${r}r=$email"
            done
        else
            echo "No suitable reviewers found."
        fi
    else
        echo "git-contacts not available."
        skip=1
    fi
fi

if [ $skip -ne 0 ]; then
    echo "Skipping determining reviewers."
fi

if [ -n "$reviewers" ]; then
    choice="/with(o)ut reviewers"
fi
read -p "Do you want to push this review? [(Y)es$choice/(n)o] " -n 1 -r
echo

if [ "$REPLY" != "o" -a "$REPLY" != "O" ]; then
    if [ -n "$r" ]; then
        if [ -z "$options" ]; then
            options="%$r"
        else
            options="$options,$r"
        fi
    fi
fi

if [ "$REPLY" != "n" -a "$REPLY" != "N" ]; then
    git push $remote $ref:refs/$refname/$target$options
fi
