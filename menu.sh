echo 'Please enter your choice: '
options=("Git" "ADB" "Fastboot" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Git")
            git -v
            ;;
        "ADB")
            sh $SCRIPTDIR/apps/adb.sh
            ;;
        "Fastboot")
            fastboot
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
