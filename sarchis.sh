#!/bin/bash

###---------------- Start Of Messeges ----------------###

setlangttl="Select Language"
setlangmsg="Select a language that you want to set in installer"
welcomemsg="Hi, Welcome to sArchis.\n I tried to make installing arch easier for everyone\nBut highly recommended that install arch with official arch guid and by yourself"

###---------------- End Of Messeges ----------------###


startinstall(){
    welcome=$(whiptail --title "sArchis" --nocancel --menu "$welcomemsg" 30 80 2 "Continue" "to installing" "Change" "Language of installer" 3>&1 1>&2 2>&3)
    if [ "$welcome" == "Change" ]; then
        setlang
    else
        bash langs/english/sarchis.sh
        exit 0
    fi
}

setlang(){
    lang=$(whiptail --title "$setlangttl" --nocancel --radiolist "$setlangmsg" 30 80 4 "English" "." ON "Persian (Finglish)" "." OFF 3>&1 1>&2 2>&3)
    case $lang in
    English)
    bash langs/english/sarchis.sh
    exit 0
    ;;
    "Persian (Finglish)")
    clear
    bash langs/persian/sarchis.sh
    exit 0
    ;;
    esac
}

startinstall