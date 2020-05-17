#!/bin/bash

#######################################
# Decorate some color for the output
# Arguments:
#   $1: type of message
#######################################
print_style () {
    if [ "$2" == "info" ] ; then
        COLOR="96m"
    elif [ "$2" == "success" ] ; then
        COLOR="92m"
    elif [ "$2" == "warning" ] ; then
        COLOR="93m"
    elif [ "$2" == "danger" ] ; then
        COLOR="91m"
    else #default color
        COLOR="0m"
    fi

    STARTCOLOR="\e[$COLOR"
    ENDCOLOR="\e[0m"

    printf "$STARTCOLOR%b$ENDCOLOR" "$1"
}

#######################################
# Checkout to main branch and pull it
# Arguments:
#   $1: current branch
#   $2: main branch
#######################################
checkout_and_pull_main_branch () {
  CURRENT_BRANCH=$1
  MAIN_BRANCH=$2
  if [ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]; then
    print_style "\t\tUpdating main branch $MAIN_BRANCH ... \n" "info"
    # TODO(): check if git pull cause a conflict
    git pull origin $CURRENT_BRANCH
  else
    print_style "\t\tCheckout to main branch ... \n" "info"
    git checkout $MAIN_BRANCH

    print_style "\t\tUpdate main branch ... \n" "info"
    git pull origin $MAIN_BRANCH
    # TODO(): check if git pull failed (no repo exist)/cause conflict

    print_style "\t\tCheckout back to current branch ... \n" "info"
    git checkout $CURRENT_BRANCH
  fi
}

#######################################
# Update main branch of the repository
#   If current branch is main branch, do "git pull"
#   If current branch is not main branch, checkout to main branch and do "git pull"
# Arguments:
#   $1: main branch
#######################################
update_main_branch () {
  if [ -z "$1" ]
  then
    MAIN_BRANCH="master"
  else
    MAIN_BRANCH="$1"
  fi

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
	print_style "\tCurrent branch is " "info"
	print_style "$CURRENT_BRANCH \n" "danger"

	## check if the repo have uncommit files. If yes, stash them and checkout to update
	if ! git diff-index --quiet HEAD --; then
		print_style "\t\tYou have unstage file in $CURRENT_BRANCH branch\n" "danger"
		print_style "\t\tChange files\n" "danger"
		git status
		read -p 'Please select the desired behavior: checkout all (c), skip the repository (s) or by default keep changes using git stash (k): ' unstageChoice
		# TODO(): Read user choice, can be either skip the repository, checkout all the changes or stash it and apply later
		case $unstageChoice in
		c)
		  print_style "\t\tCheckout all files\n" "danger"
      git checkout -- .
      checkout_and_pull_main_branch $CURRENT_BRANCH $MAIN_BRANCH
    ;;
    s)
      print_style "\t\tSkip the repository ... \n" "info"
    ;;
    *)
      print_style "\t\tGit stash ... \n" "info"
      git stash
      checkout_and_pull_main_branch $CURRENT_BRANCH $MAIN_BRANCH
      # TODO(): Check apply stash cause conflict
      print_style "\t\tApply stash ... \n" "info"
      git stash pop stash@{0}
    ;;
    esac

  else
    checkout_and_pull_main_branch $CURRENT_BRANCH $MAIN_BRANCH
	fi
	print_style "########################################\n" "warning"
}

for folder in */ ; do
	print_style "Updating repository $folder \n" "info";
	cd $folder
		update_main_branch master
	cd ..
done

## Helps keep the log
read -p read -p " Press Enter to exit"