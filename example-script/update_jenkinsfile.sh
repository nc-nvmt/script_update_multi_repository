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

for folder in */; do 
	if [ "$folder" != "nc-devops-pipeline-shared-libraries/" ]  && [ "$folder" != "pipeline-shared-libs/" ]; then
		print_style "Updating repository $folder \n" "info";
		cd $folder
		git checkout master
		CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
		print_style "\tCurrent branch is " "info"
		print_style "$CURRENT_BRANCH \n" "danger"
		if [ "$CURRENT_BRANCH" != "master" ]; then
		#if [ -d jenkins ]; then
		#	print_style "Updating jenkinsfile \n" "info";
		#	cd jenkins
		#	if [ -e bppr.jenkinsfile ]; then
		#		print_style "Updating bppr \n" "info";
		#		sed -i 's/jdk = \"openjdk11\"/agentLabel = \x27kubernetes\x27/g' bppr.jenkinsfile
		#	fi
		#	if [ -e build.jenkinsfile ]; then
		#		print_style "Updating build \n" "info";
		#		sed -i 's/jdk = \"openjdk11\"/agentLabel = \x27kubernetes\x27/g' build.jenkinsfile
		#		sed -i 's/art-1/nc-artifactory/g' build.jenkinsfile
		#	fi
		#	cd ..
		#fi
		#git add jenkins/*
		#git push --set-upstream origin feature/add_gradle_test
			git pull origin master
		fi
		cd ..
	fi
done

read -p " Want to exit ??"