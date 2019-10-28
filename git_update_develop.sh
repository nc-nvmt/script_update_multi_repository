declare -A list_folder=( ["nc-devops-pipeline-shared-libraries/"]="develop" 
						 ["MultiBranchPipeline/"]="master" 
						 ["NCCGV001.wiki/"]="wikiMaster" 
						 ["nc-devops-azure-deployer/"]="develop" 
						 ["nc-devops-docker-gradle-plugin/"]="master" 
						 ["nc-devops-hello-world/"]="master" 
						 ["nc-devops-jenkins/"]="master" 
						 ["nc-devops-jenkins-accelerators/"]="master" 
						 ["nc-devops-jenkins-skat-ici/"]="master" 
						 ["nc-devops-php/"]="master" 
						 ["nc-devops-poc-system-apps-config/"]="master" 
						 ["nc-devops-poc-system-config-server/"]="master"
						 ["nc-devops-poc-system-db-schema/"]="master"
						 ["nc-devops-poc-system-devops/"]="master"
						 ["nc-devops-poc-system-integration-tests-app/"]="master"
						 ["nc-devops-poc-system-weblogic-office-supplier-app/"]="master"
						 ["nc-devops-poc-system-wildfly-office-consumer-app/"]="master"
						 ["nc-devops-release-notes/"]="master"
						 ["nc-devops-template-shared-library/"]="master" 
						 ["nc-devops-semantic-versioning-gradle-plugin/"]="master" 
						 ["nc-devops-docker-build-gradle-plugin/"]="master" 
						 ["nc-devops-docker-run-gradle-plugin/"]="master" )
						 
# declare -A exclude_folder=( "kitty" )						 

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

for folder in "${!list_folder[@]}"; do 
	print_style "Updating repository $folder \n" "info";
	if [ "$folder" != "nc-devops-pipeline-shared-libraries/" ]; then
		cd $folder
		CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
		print_style "\tCurrent branch is " "info"
		print_style "$CURRENT_BRANCH \n" "danger"
		git diff-index --quiet HEAD --
		if [ "$?" != 0 ]; then
			print_style "\t\tYou have unstage file in $CURRENT_BRANCH branch \n" "danger"
		fi
		if [ "$CURRENT_BRANCH" == "${list_folder[$folder]}" ]; then
			print_style "\t\tUpdating main branch ... \n" "info"
			git pull origin $CURRENT_BRANCH
		else
			print_style "\t\tUsing different branch ... \n" "warning"
			print_style "\t\tGit stash ... \n" "info"
			git stash
			print_style "\t\tCheckout to main branch ... \n" "info"
			git checkout ${list_folder[$folder]}
			print_style "\t\tUpdate main branch ... \n" "info"
			git pull origin ${list_folder[$folder]}
			print_style "\t\tCheckout to current branch ... \n" "info"
			git checkout $CURRENT_BRANCH
			print_style "\t\tApply stash ... \n" "info"
			git stash pop stash@{0}
		fi
		printf " \n"
		cd ..
	#echo "$folder - ${list_folder[$folder]}"; 
	else
		echo "shared-libraries"
	fi
done

#for d in */ ; do
#if [ "$d" != "nc-devops-pipeline-shared-libraries/" ]; then
#	if  [ "$d" != "lp-devops/" ]; then
#		cd $d
#		CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
#		print_style "$d \n" "danger"; 
#		if  [ "$CURRENT_BRANCH" != "master" ]; then
#			print_style "\t current branch = $CURRENT_BRANCH \n" "success";
#			print_style "\t git stash \n" "info";
#			git stash
#			print_style "\t checkout develop \n" "info";
#			git checkout develop
#			print_style "\t pull develop \n" "info";
#			git pull origin develop
#			print_style "\t checkout current branch \n" "info";
#			git checkout $CURRENT_BRANCH
#			print_style "\t apply stash \n" "info";
#			git stash pop stash@{0}
#		else
#			printf "\t current branch = develop \n";
#			git diff-index --quiet HEAD --
#			if [ "$?" != 0 ]; then
#				print_style "You have unstage file in develop branch. Please checkout to other branch" "danger"
#				read -p " Press Enter to exit "
#			fi
#			print_style "\t pull develop \n" "info";
#			git pull origin develop
#		fi
#		cd ..
#	else
#		cd $d
#		git pull origin master
#		cd ..
#	fi
#fi
#done

read -p " Want to exit ??"
