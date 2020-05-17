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

for folder in */ ; do
	print_style "Updating repository $folder \n" "info";
	cd $folder
		## your_function_here()
	cd ..
done

## Helps keep the log
read -p read -p " Want to exit ??"
