#!/bin/bash

###---------------- Start Of Messeges ----------------### 
exitbuttonttl="Khoruj"
keybindsttl="Loadkeys"
keybindsmsg="Ebteda lotfan keymap morede nazar khod ra entekhab konid"
keybindsmsg2="Keymap morede nazar khod ra alamat bezanid (besurate pishfarz keymap us alamat khorde ast; agar haman ra mikhahid faqat enter bezanid)"
selectdiskttl="Entekhabe Disk"
selectdiskmsg="Disk mored nazar baraye nasb arch ra entekhab konid."
partitioningttl="Partition Bandi"
partitioningmsg="Halate morede nazar baraye partition bandi ra entekhab konid"
errorspacettl="Error fazaye azad"
errorspacemsg="Fazaye azad be andaze kafi vujud nadarad. \nEbteda say konid kami faza dar $mdisk khali konid sepas mojadadan eqdam be nasb konid"
errorspacemsg2="Fazate azad kafi dar partition extended vujud nadarad"
partitiontypettl="Partition type"
partitiontypemsg="Type morede nazar baraye format partition asli ra entekhab konid"
choosepartitionsttl="Entekhab partition ha"
choosepartitionsmsg1="Partition BOOT khod ra entekhab konid"
choosepartitionsmsg2="Partition ROOT khod ra entekhab konid"
choosepartitionsmsg3="Partition SWAP khod ra entekhab konid"
getlocalettl="Tanzimat mahali"
getlocalemsg="Partition bandi tamam shod.\nBakhsh badi tanzimate mahali ast."
getlocalemsg2="Tanzimate mahali morede nazar khod ra baraye faal sazi entekhab konid (be surate pishfarz tanzimate mahali ruye en_US agar hamin ra mikhahid faqat Enter bezanid.)"
getlocalemsg3="Gozine morede nazar baraye tanzim shodan dar fayl locale.conf ra entekhab konid"
gettimezonettl="Tanzim mantaqe zamani"
gettimezonemsg="Tanzimate mahali anjam shod.\nBakhsh badi tanzim mantaqe zamani ast."
gettimezonemsg2="Ebteda Mantaqe morede nazar ra entekhab konid"
gettimezonemsg3="Hala shahre morede nazar ra entekhab konid"
getrootpassttl="Tanzim ramz obur karbare root"
getrootpassmsg="Tanzim mantaqe zamani anjam shod.\nBakhsh badi tanzim ramz obur baraye karbare root ast."
getrootpassmsg2="Yek ramz obur baraye karbare root vared konid."
getrootpassmsg3="ramze obur vared shode ra mojadadan tekrar konid."
getpasserrorttl="Khata!"
getpasserrormsg="Lotfan yek ramz obure motabar vared konid va an ra khali nagzarid!"
getpasserrormsg2="Ramz obur haye vared shode ham khani nadarad; Dobare talash konid."
getuserinfottl="Sakhtane karbar"
getuserinfomsg1="Tanzim ramze obur baraye karbare root anjam shod.\nBakhsh badi sakhte karbar ast."
getuserinfomsg2="Ebteda yek Hostname baraye system vared konid"
getuserinfomsg3="Nam karbari morede nazare khod ra vared konid"
getuserpasswdmsg1="Yek ramze obur baraye $username vared konid"
getuserpasswdmsg2="Ramz obure vared shode baraye $username ra mojadadan tekrar konid"
getdesktopttl="Entekhabe desktop"
getdesktopmsg1="Sakhte karbar anjam shod.\nBakhsh badi entekhab yek mohite desktop ast.\nYeki az desktop haye zir ra baraye nasb entekhab konid"
getdesktopextrattl="Abzar haye ezafi"
getdesktopextramsg="Aya mikhahid ke abzar haye ezafi $desktop nasb shavand?"
getdisplaymanagerttl="Entekhabe Display manager"
getdisplaymanagermsg="Entekhabe Desktop anjam shod.\nBakhsh badi entekhabe display manager ast.\nYeki az display manager haye zir ra baraye nasb entekhab konid"
getkernelttl="Entekhabe kernel"
getkernelmsg="Entekhabe display manager anjam shod.\nBakhsh badi entekhabe kernel ast.\nYeki az kernel haye zir ra baraye nasb entekhab konid"
getadditionalpkgsttl="Entekhabe abzar haye digar"
getadditionalpkgsmsg1="Entekhab kernel anjam shod.\nBakhsh badi entekhabe abzar haye digar ast.\nEntekhab konid kodam abzar haye ezafi mikhahid nasb shavad"
getadditionalpkgsmsg2="Abzar haii ke mikhahid ra entekhab konid"
getadditionalpkgsaudiottl="Entekhab abzar haye soti"
getadditionalpkgsmediattl="Entekhab abzar haye chand resane-i"
getadditionalpkgscommiunicationttl="Entekhab abzar haye ertebatat"
getadditionalpkgseditingttl="Entekhab abzar haye virayeshgar"
getadditionalpkgsaurttl="Entekhab abzar haye aur"

###---------------- End Of Messeges ----------------###


startinstall(){
    keybinds
}

setlang(){
    lang=$(whiptail --title "$setlangttl" --nocancel --radiolist "$setlangmsg" 30 80 4 "English" "." ON "Persian (Finglish)" "." OFF 3>&1 1>&2 2>&3)
    case $lang in
    English)
    bash langs/english/sarchis.sh
    ;;
    "Persian (Finglish)")
    clear
    bash langs/persian/sarchis.sh
    ;;
    esac
}

keybinds(){
    backorcont=$(whiptail --title "$keybindsttl" --nocancel --menu "$keybindsmsg" 30 80 2 "<-- Back" "To previous menu" "Continue" "to selecting keybind" 3>&1 1>&2 2>&3)
    if [ "$backorcont" == "<-- Back" ]; then
        setlang
    else
        keys=`find /usr/share/kbd/keymaps/ -type f -printf "%f\n" | sort -V`

        for i in $keys; do
            if [ $i == "us.map.gz" ]; then
                keybind="$keybind $i , ON"
            elif [ $i == "README.md" ]; then
                false
            else 
                keybind="$keybind $i . OFF"
            fi
        done

        key=$(whiptail --nocancel --title "$keybindsttl" --radiolist "$keybindsmsg2" 30 80 10 ${keybind} 3>&1 1>&2 2>&3) 
        loadkeys $key
        selectdisk
    fi
}

selectdisk(){
    disk=""
    disks=`echo "print devices" | parted | grep "^/dev"`
    for i in $disks; do
            disk="$disk $i"
    done
    mdisk=$(whiptail --title "$selectdiskttl" --cancel-button "$exitbuttonttl" --menu "$selectdiskmsg" 30 80 5 "<-- Back" "To previous menu" $disk 3>&1 1>&2 2>&3)
    if [ -z $mdisk ]; then
        exit 0
    elif [ "$mdisk" == "<-- Back" ]; then
        keybinds
    else
        checkdisk
    fi
}

checkdisk(){
	efi=`ls /sys/firmware/efi/efivars 2>&1 | cut -c 1-10`
	if [ "$efi" == "ls: cannot" ]; then
		efi=0
	else
		efi=1
	fi
    iswindows=`echo "print free" | parted $mdisk | grep "Microsoft reserved partition"`
    isotheros=`echo "print free" | parted $mdisk | grep "boot"`
    if [[ -z "$iswindows" && -z "$isotheros" ]]; then
        otheros=0
    else
        otheros=1
    fi
    freespace=`echo "print free" | parted $mdisk | grep "Free Space" | awk '{print $3}' | grep "GB"`
    freespacesize=`echo "print free" | parted $mdisk | grep "Free Space" | awk '{print $3}' | grep "GB" | awk '{print substr($1,0,length($1)-2)}'`
    if [ -z "$freespace" ]; then
        freespace=0
    else
        for i in $freespacessize; do
        if [ $i -lt 8 ]; then
            freespace=0
        else
            freespace=1
        fi
        done
    fi

    partitioning
}

partitioning(){
    if [ $otheros -eq 0 ]; then
        installmode=$(whiptail --title "$partitioningttl" --cancel-button "$exitbuttonttl" --menu "$partitioningmsg" 30 80 4 "<-- Back" "To previous menu" "Freespace" "Install Arch in freespace" "Entire disk" "Erease disk and install arch" "Manually" "Partitioning manually" 3>&1 1>&2 2>&3)
    elif [ $otheros -eq 1 ]; then
        installmode=$(whiptail --title "$partitioningttl" --cancel-button "$exitbuttonttl" --menu "$partitioningmsg" 30 80 4 "<-- Back" "To previous menu" "Alongside" "Install Arch alongside other distros" "Entire disk" "Erease disk and install arch" "Manually" "Partitioning manually" 3>&1 1>&2 2>&3)
    fi
    if [ -z $installmode ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    else
        swapsize
        if [ $efi -eq 0 ]; then
            primarypartitions
            if [[ $primarynumber -eq 1 || $primarynumber -eq 2 ]]; then
                logicalpartitions
            fi
        fi
        clear
        case $installmode in
            "<-- Back")
            selectdisk
            ;;

            Freespace)
            if [ $freespace -eq 0 ]; then
                whiptail --title "$errorspacettl" --msgbox "$errorspacemsg" 30 80 4
                partitioning
            else
                partitionfree
            fi
            partitiontype=`whiptail --nocancel --title "$partitiontypettl" --menu "$partitiontypemsg" 20 80 5 "Ext4" "" "Btrfs" "" 3>&1 1>&2 2>&3`
            ;;
            
            Alongside)
            if [ $freespace -eq 0 ]; then
                whiptail --title "$errorspacettl" --msgbox "$errorspacemsg" 30 80 4
                partitioning
            else
                partitionalong
            fi
            partitiontype=`whiptail --nocancel --title "$partitiontypettl" --menu "$partitiontypemsg" 20 80 5 "Ext4" "" "Btrfs" "" 3>&1 1>&2 2>&3`
            ;;

            "Entire disk")
            partitionentire
            partitiontype=`whiptail --nocancel --title "$partitiontypettl" --menu "$partitiontypemsg" 20 80 5 "Ext4" "" "Btrfs" "" 3>&1 1>&2 2>&3`
            ;;

            Manually)
            cfdisk $mdisk
            partitiontype=`whiptail --nocancel --title "$partitiontypettl" --menu "$partitiontypemsg" 20 80 5 "Ext4" "" "Btrfs" "" 3>&1 1>&2 2>&3`
            choosepartitions
            ;;
        esac
        formatpartitions
        mountpartitions
    fi
}

swapsize(){
    totalram=`free -h | awk '/^Mem:/ {print substr($2,1,length($2)-4)}'`
    if [[ $totalram -le 8 ]]; then
        swap=$totalram
    else
        swap=$(($totalram / 2))
    fi
}

primarypartitions(){
    primarynumber=`echo "print free" | parted $mdisk | grep "primary\|extended" | awk '{print $5}'`
    n=0
    for i in $primarynumber; do
        n=$(($n+1))
    done
    primarynumber=$((4-$n))
}

logicalpartitions(){
    extendedpartition=`echo "print free" | parted $mdisk | grep "extended" | awk '{print $5}'`
    if [ "$extendedpartition" == "extended" ]; then
        extended=1
        x=`echo "print free" | parted $mdisk | grep "extended" | awk '{print $1}'`
        extendedsize=`fdisk -l | grep ${mdisk}${x} | awk '{print substr($(NF-2),0,length($NF-2))}'`
        logicals=`fdisk -l ${mdisk}${x} | grep "^/dev" | awk '{print substr($(NF-2),0,length($NF-2)-1)}'`
        logicalsize=0
        for i in $logicals; do
            logicalsize=$(($logicalsize+$i))
        done
        extendedfreespace=$(($extendedsize-$logicalsize))
        if [ $extendedfreespace -lt 8 ]; then
            whiptail --title "$errorspacettl" --msgbox "$errorspacemsg2" 30 80 
            partitioning
        fi
    else
        extended=0
    fi
}

partitionfree(){
    if [ $efi -eq 1 ]; then
        bootpnumber=`(
        echo x  
        echo f  
        echo r  
        echo n  
        echo    
        echo    
        echo +512M
        echo y  
        echo w  
        ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
        bootpartition="${mdisk}${bootpnumber}"
        sleep 0.5
        swappnumber=`(
        echo t  
        echo $bootpnumber   
        echo 1  
        echo n  
        echo    
        echo    
        echo "+${swap}G"    
        echo y  
        echo w  
        ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
        swappartition="${mdisk}${swappnumber}"
        sleep 0.5
        rootpnumber=`(
        echo t  
        echo $swappnumber   
        echo 19 
        echo n  
        echo    
        echo    
        echo    
        echo y  
        echo w  
        ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
        rootpartition="${mdisk}${rootpnumber}"
        (
        echo x  
        echo v  
        echo r  
        echo w  
        ) | fdisk $mdisk
    elif [ $efi -eq 0 ]; then
        if [ $primarynumber -eq 0 ]; then
            whiptail --title "Primary partition error" --msgbox "there is no space for creating partition; you have 4/4 primary/extended partitin created.\nTry to free some space for at least one primary partition" 30 80
            partitioning
        elif [ $primarynumber -eq 1 ]; then
            if [ $extended -eq 0 ]; then
                bootpnumber=`(
                echo n  
                echo e  
                echo    
                echo    
                echo n  
                echo    
                echo +512M  
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk 'END {print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo    
                echo "+${swap}G"   
                echo y   
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            elif [ $extended -eq 1 ]; then
                bootpnumber=`(
                echo n  
                echo p  
                echo    
                echo +512M  
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo    
                echo "+${swap}G"    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo y  
                echo w     
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            fi
        elif [ $primarynumber -eq 2 ]; then
            if [ $extended -eq 0 ]; then
                bootpnumber=`(
                echo n  
                echo p  
                echo    
                echo    
                echo +512M  
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo e  
                echo    
                echo    
                echo n  
                echo    
                echo "+${swap}G"    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk 'END {print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            elif [ $extended -eq 1 ]; then
                bootpnumber=`(
                echo n  
                echo p  
                echo    
                echo    
                echo +512M  
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo p  
                echo    
                echo "+${swap}G"    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            fi
        elif [ $primarynumber -eq 3 ]; then
            bootpnumber=`(
            echo n  
            echo p  
            echo    
            echo    
            echo +512M  
            echo y  
            echo w  
            ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
            bootpartition="${mdisk}${bootpnumber}"
            sleep 0.5
            swappnumber=`(
            echo a  
            echo $bootpnumber   
            echo n  
            echo p  
            echo    
            echo    
            echo "+${swap}G"    
            echo y  
            echo w  
            ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
            swappartition="${mdisk}${swappnumber}"
            sleep 0.5
            rootpnumber=`(
            echo t  
            echo $swappnumber   
            echo 82 
            echo n  
            echo p  
            echo    
            echo    
            echo y  
            echo w
            ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
            rootpartition="${mdisk}${rootpnumber}"
            (
            echo x  
            echo v  
            echo r  
            echo w  
            ) | fdisk $mdisk
        else
            partitionentire
        fi
    fi
}

partitionalong(){
    if [ $efi -eq 1 ]; then
        (
        echo x  
        echo f  
        echo r  
        echo w  
        ) | fdisk $mdisk
        bootpartition=`echo p | fdisk $mdisk | grep "EFI System" | awk '{print $1}'`
        sleep 0.5
        swappnumber=`(
        echo n  
        echo    
        echo    
        echo "+${swap}G"    
        echo w  
        ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
        swappartition="${mdisk}${swappnumber}"
        sleep 0.5
        rootpnumber=`(
        echo t  
        echo $swappnumber   
        echo 19 
        echo n  
        echo    
        echo    
        echo    
        echo w  
        ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
        rootpartition="${mdisk}${rootpnumber}"
        (
        echo x  
        echo v  
        echo r  
        echo w  
        ) | fdisk $mdisk
    elif [ $efi -eq 0 ]; then
        if [ $primarynumber -eq 0 ]; then
            whiptail --title "Primary partition error" --msgbox "there is no space for creating partition; you have 4/4 primary/extended partitin created.\nTry to free some space for at least one primary partition" 30 80
            partitioning
        elif [ $primarynumber -eq 1 ]; then
            if [ $extended -eq 0 ]; then
                bootpnumber=`(
                echo n  
                echo e  
                echo    
                echo    
                echo n  
                echo    
                echo +512M  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk 'END {print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo    
                echo "+${swap}G"    
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            elif [ $extended -eq 1 ]; then
                bootpnumber=`(
                echo n  
                echo p  
                echo    
                echo +512M  
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo    
                echo "+${swap}G"    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo y  
                echo w     
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            fi
        elif [ $primarynumber -eq 2 ]; then
            if [ $extended -eq 0 ]; then
                bootpnumber=`(
                echo n  
                echo p  
                echo    
                echo    
                echo +512M  
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo e  
                echo    
                echo    
                echo n  
                echo    
                echo "+${swap}G"    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk 'END {print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            elif [ $extended -eq 1 ]; then
                bootpnumber=`(
                echo n  
                echo p  
                echo    
                echo    
                echo +512M  
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                bootpartition="${mdisk}${bootpnumber}"
                sleep 0.5
                swappnumber=`(
                echo a  
                echo $bootpnumber   
                echo n  
                echo p  
                echo    
                echo "+${swap}G"    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                swappartition="${mdisk}${swappnumber}"
                sleep 0.5
                rootpnumber=`(
                echo t  
                echo $swappnumber   
                echo 82 
                echo n  
                echo    
                echo    
                echo y  
                echo w  
                ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
                rootpartition="${mdisk}${rootpnumber}"
                (
                echo x  
                echo v  
                echo r  
                echo w  
                ) | fdisk $mdisk
            fi
        elif [ $primarynumber -eq 3 ]; then
            bootpnumber=`(
            echo n  
            echo p  
            echo    
            echo    
            echo +512M  
            echo y  
            echo w  
            ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
            bootpartition="${mdisk}${bootpnumber}"
            sleep 0.5
            swappnumber=`(
            echo a  
            echo $bootpnumber   
            echo n  
            echo p  
            echo    
            echo    
            echo "+${swap}G"    
            echo y  
            echo w  
            ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
            swappartition="${mdisk}${swappnumber}"
            sleep 0.5
            rootpnumber=`(
            echo t  
            echo $swappnumber   
            echo 82 
            echo n  
            echo p  
            echo    
            echo    
            echo y  
            echo w
            ) | fdisk $mdisk | grep "new partition" | awk '{print $5}'`
            rootpartition="${mdisk}${rootpnumber}"
            (
            echo x  
            echo v  
            echo r  
            echo w  
            ) | fdisk $mdisk
        else
            partitionentire
        fi
    fi
}

partitionentire(){
    if [ $efi -eq 1 ]; then
        (
        echo g  
        echo n  
        echo 1  
        echo    
        echo +512M  
        echo y  
        echo n  
        echo 2  
        echo    
        echo "+${swap}G"    
        echo y  
        echo n  
        echo 3  
        echo    
        echo    
        echo y  
        echo t  
        echo 1  
        echo 1  
        echo t  
        echo 2
        echo 19 
        echo w  
        ) | fdisk $mdisk
        bootpartition="${mdisk}1"
        swappartition="${mdisk}2"
        rootpartition="${mdisk}3"
        (
        echo x  
        echo v  
        echo r  
        echo w  
        ) | fdisk $mdisk
    elif [ $efi -eq 0 ]; then
        (
        echo o  
        echo n  
        echo p  
        echo 1  
        echo    
        echo +512M  
        echo y  
        echo n  
        echo p  
        echo 2  
        echo    
        echo "+${swap}G"    
        echo y  
        echo n  
        echo p  
        echo 3  
        echo    
        echo    
        echo y  
        echo t  
        echo 2
        echo 82
        echo a  
        echo 1  
        echo w  
        ) | fdisk $mdisk
        bootpartition="${mdisk}1"
        swappartition="${mdisk}2"
        rootpartition="${mdisk}3"
        (
        echo x  
        echo v  
        echo r  
        echo w  
        ) | fdisk $mdisk
    fi
}

choosepartitions(){
    if [ $efi -eq 0 ]; then
        getboot=`echo p | fdisk $mdisk | grep "^/dev" | grep "*" | awk '{print $1 " " $6}'`
        getother=`echo p | fdisk $mdisk | grep "^/dev" | grep -v "*" | awk '{print $1 " " $5}'`
        getlistpartitions="$getboot $getother"
    elif [ $efi -eq 1 ]; then
        getlistpartitions=`echo p | fdisk $mdisk | grep "^/dev" | awk '{print $1 " " $5}'`
    fi
    clear 
    for i in $getlistpartitions; do
        if [[ $i == /dev* ]]; then
            listpartitions="$listpartitions  $i"
        else
            listpartitions="$listpartitions _____$i"
        fi
    done
    bootpartition=`whiptail --title "$choosepartitionsttl" --cancel-button "$exitbuttonttl" --menu "$choosepartitionsmsg1" 20 80 5 ${listpartitions} 3>&1 1>&2 2>&3`
    if [ -z $bootpartition ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    else
        rootpartition=`whiptail --title "$choosepartitionsttl" --cancel-button "$exitbuttonttl" --menu "$choosepartitionsmsg2" 20 80 5 ${listpartitions} 3>&1 1>&2 2>&3`
        if [ -z $rootpartition ]; then
            exit 0
            umount $mdisk*
            swapoff -a
        else    
            swappartition=`whiptail --title "$choosepartitionsttl" --cancel-button "$exitbuttonttl" --menu "$choosepartitionsmsg3" 20 80 5 ${listpartitions} 3>&1 1>&2 2>&3`
            if [ -z $swappartition ]; then
                exit 0
                umount $mdisk*
                swapoff -a
            fi
        fi
    fi
}

formatpartitions(){
    umount $mdisk*
    swapoff -a
    if [ $efi -eq 0 ]; then
		echo y | mkfs.ext4 $bootpartition 
	elif [ $efi -eq 1 ]; then
        if [ $installmode != "Alongside" ]; then
		    echo y | mkfs.fat -F32 $bootpartition
        fi
    fi
	if [ $partitiontype == "Btrfs" ]; then
		mkfs.btrfs -f $rootpartition
	elif [ $partitiontype == "Ext4" ]; then
		echo y | mkfs.ext4 $rootpartition
	fi
	mkswap -f $swappartition
}

mountpartitions(){
	if [ $partitiontype == "Btrfs" ]; then
		mount $rootpartition /mnt
        btrfs subvolume create /mnt/@
		btrfs subvolume create /mnt/@home
		umount -l /mnt
		mount -o noatime,compress=zstd,subvol=@ $rootpartition /mnt
		mkdir /mnt/home
        mount -o noatime,compress=zstd,subvol=@home $rootpartition /mnt/home
	elif [ $partitiontype == "Ext4" ]; then
        mount $rootpartition /mnt
	fi
	mkdir /mnt/boot
	if [ $efi -eq 0 ]; then
		mount $bootpartition /mnt/boot 
	elif [ $efi -eq 1 ]; then
		mkdir /mnt/boot/efi 
		mount $bootpartition /mnt/boot/efi 
	fi
	swapon $swappartition
    
    getlocale
}

getlocale(){
    backorcont=`whiptail --title "$getlocalettl" --cancel-button "$exitbuttonttl" --menu "$getlocalemsg" 20 80 2 "<-- Back" "To previous menu" "Continue" "to Set locale" 3>&1 1>&2 2>&3`
    if [ -z $backorcont ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$backorcont" == "<-- Back" ]; then
        partitioning
    else
        locales=`ls /usr/share/i18n/locales`
        localelist=""
        for i in $locales; do
            if [ $i == "en_US" ]; then
                localelist="$localelist $i . ON"  
            else
                localelist="$localelist $i . OFF"
            fi   
        done
        locale=`whiptail --nocancel --title "$getlocalettl" --checklist "$getlocalemsg2" 30 80 20 ${localelist} 3>&1 1>&2 2>&3`
        locale2=""
        for i in $locale; do
            flocale=`echo $i | awk '{print substr($1,2,length($1)-2)}'`
            locale2="$locale2 $flocale <--"
        done
        flocale2=`whiptail --nocancel --title "$getlocalettl" --menu "$getlocalemsg3" 20 80 10 ${locale2} 3>&1 1>&2 2>&3`
        clear
        gettimezone
    fi
}

setlocale(){
    for i in $locale; do
        flocale=`echo $i | awk '{print substr($1,2,length($1)-2)}'`
        sed -i '/#'${flocale}'.UTF-8/s/^#//g' /mnt/etc/locale.gen
    done
    echo "LANG=${flocale2}.UTF-8" > /mnt/etc/locale.conf
    clear
    arch-chroot /mnt locale-gen
    if [ $key != "us.map.gz" ]; then
        arch-chroot /mnt loadkeys $key
    fi 
}

gettimezone(){
    backorcont=`whiptail --title "$gettimezonettl" --cancel-button "$exitbuttonttl" --menu "$gettimezonemsg" 20 80 2 "<-- Back" "To previous menu" "Continue" "to Set timezone" 3>&1 1>&2 2>&3`
    if [ -z $backorcont ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$backorcont" == "<-- Back" ]; then
        getlocale
    else
        regions=`ls --format=long /usr/share/zoneinfo | grep "^d" | awk '{print $NF}'`
        for i in $regions; do
            if [[ $i != "right" && $i != "posix" ]]; then
                listregion="$listregion $i ."
            fi
        done
        region=`whiptail --title "$gettimezonettl" --cancel-button "$exitbuttonttl" --menu "$gettimezonemsg2" 20 80 10 ${listregion} 3>&1 1>&2 2>&3`
        if [ -z $region ]; then
            exit 0
            umount $mdisk*
            swapoff -a
        else
            cities=`ls /usr/share/zoneinfo/$region`
            for i in $cities; do
                listcities="$listcities $i ."
            done
            city=`whiptail --title "$gettimezonettl" --cancel-button "$exitbuttonttl" --menu "$gettimezonemsg3" 20 80 10 ${listcities} 3>&1 1>&2 2>&3`
            if [ -z $city ]; then
                exit 0
                umount $mdisk*
                swapoff -a
            fi
        fi
        getrootpass
    fi
}

settimezone(){
    clear
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime
    arch-chroot /mnt hwclock --systohc --utc
}

getrootpass(){
    backorcont=`whiptail --title "$getrootpassttl" --cancel-button "$exitbuttonttl" --menu "$getrootpassmsg" 20 80 2 "<-- Back" "To previous menu" "Continue" "to Set root password" 3>&1 1>&2 2>&3`
    if [ -z $backorcont ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$backorcont" == "<-- Back" ]; then
        gettimezone
    else
        rootpasswd=`whiptail --nocancel --title "$getrootpassttl" --passwordbox "$getrootpassmsg2" 20 80 3>&1 1>&2 2>&3`
        if [ -z $rootpasswd ]; then
            whiptail --title "$getpasserrorttl" --msgbox "$getpasserrormsg" 20 80
            getrootpass
        else
            vrootpasswd=`whiptail --nocancel --title "$getrootpassttl" --passwordbox "$getrootpassmsg3" 20 80 3>&1 1>&2 2>&3`
            if [ "$vrootpasswd" != "$rootpasswd" ]; then
                whiptail --title "$getpasserrorttl" --msgbox "$getpasserrormsg2" 20 80
                getrootpass
            fi
        fi
        getuserinfo
    fi
}

setrootpass(){
    clear
    echo "root:$rootpasswd" | chpasswd -R /mnt
}

getuserinfo(){
    backorcont=`whiptail --title "$getuserinfottl" --cancel-button "$exitbuttonttl" --menu "$getuserinfomsg1" 20 80 2 "<-- Back" "To previous menu" "Continue" "to creating user" 3>&1 1>&2 2>&3`
    if [ -z $backorcont ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$backorcont" == "<-- Back" ]; then
        getrootpass
    else
        hostname=`whiptail --nocancel --title "$getuserinfottl" --inputbox "$getuserinfomsg2" 20 80 3>&1 1>&2 2>&3`
        username=`whiptail --nocancel --title "$getuserinfottl" --inputbox "$getuserinfomsg3" 20 80 3>&1 1>&2 2>&3`
        getuserpasswd
    fi
}

getuserpasswd(){
    userpasswd=`whiptail --nocancel --title "$getuserinfottl" --passwordbox "$getuserpasswdmsg1" 20 80 3>&1 1>&2 2>&3`
    if [ -z $userpasswd ]; then
        whiptail --title "$getpasserrorttl" --msgbox "$getpasserrormsg" 20 80
        getuserpasswd
    else
        vuserpasswd=`whiptail --nocancel --title "$getuserinfottl" --passwordbox "$getuserpasswdmsg2" 20 80 3>&1 1>&2 2>&3`
        if [ "$vuserpasswd" != "$userpasswd" ]; then
            whiptail --title "$getpasserrorttl" --msgbox "$getpasserrormsg2" 20 80
            getuserpasswd
        fi
        getdesktop
    fi
}

setuserinfo(){
    clear
    echo $hostname > /mnt/etc/hostname
    arch-chroot /mnt useradd -m -g users -G wheel -s /bin/bash $username
    echo "$username:$userpasswd" | chpasswd -R /mnt
    sed -i '/# %wheel ALL=(ALL) ALL/s/^# //g' /mnt/etc/sudoers
}

getdesktop(){
    desktop=`whiptail --title "$getdesktopttl" --cancel-button "$exitbuttonttl" --menu "$getdesktopmsg1" 20 80 10 "<-- Back" "To previous menu" "Gnome" "." "KDE" "." "Xfce" "." "Mate" "." "No Desktop" "." 3>&1 1>&2 2>&3`
    if [ -z $desktop ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$desktop" == "<-- Back" ]; then
        getuserinfo
    elif [ "$desktop" == "Gnome" ]; then
        extra=`whiptail --nocancel --title "$getdesktopextrattl" --menu "$getdesktopextramsg" 20 80 2 "Yes" "." "No" "." 3>&1 1>&2 2>&3`
        getkernel
        installarchlinux
    elif [ "$desktop" == "No Desktop" ]; then
        getkernel
    else
        extra=`whiptail --nocancel --title "$getdesktopextrattl" --menu "$getdesktopextramsg" 20 80 2 "Yes" "." "No" "." 3>&1 1>&2 2>&3`
        getdisplaymanager
    fi
}

setdesktop(){
    case $desktop in
        Gnome)
        if [ "$extra" == "Yes" ]; then
            arch-chroot /mnt pacman -S gnome gnome-extra xorg --noconfirm
        elif [ "$extra" == "No" ]; then
            arch-chroot /mnt pacman -S gnome xorg --noconfirm
        fi
        arch-chroot /mnt systemctl enable gdm.service
        ;;

        KDE)
        if [ "$extra" == "Yes" ]; then
            arch-chroot /mnt pacman -S plasma-meta kde-applications-meta $displaymanager xorg --noconfirm
        elif [ "$extra" == "No" ]; then
            arch-chroot /mnt pacman -S plasma-meta $displaymanager xorg --noconfirm
        fi
        setdisplaymanager
        ;;

        Xfce)
        if [ "$extra" == "Yes" ]; then
            arch-chroot /mnt pacman -S xfce4 xfce4-goodies $displaymanager xorg --noconfirm
        elif [ "$extra" == "No" ]; then
            arch-chroot /mnt pacman -S xfce4 $displaymanager xorg --noconfirm
        fi
        setdisplaymanager
        ;;

        Mate)
        if [ "$extra" == "Yes" ]; then
            arch-chroot /mnt pacman -S mate mate-extra $displaymanager xorg --noconfirm
        elif [ "$extra" == "No" ]; then
            arch-chroot /mnt pacman -S mate $displaymanager xorg --noconfirm
        fi
        setdisplaymanager
        ;;

    esac
}

getdisplaymanager(){
    displaymanager=`whiptail --title "$getdisplaymanagerttl" --cancel-button "$exitbuttonttl" --menu "$getdisplaymanagermsg" 20 80 10 "<-- Back" "To previous menu" "lightdm" "." "sddm" "." "lxdm" "." 3>&1 1>&2 2>&3`
    if [ -z $displaymanager ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$displaymanager" == "<-- Back" ]; then
        getdesktop
    else
        getkernel
    fi
}

setdisplaymanager(){
    case $displaymanager in
        lightdm)
        arch-chroot /mnt pacman -S lightdm-gtk-greeter --noconfirm
        sed -i '/#greeter-session/s/^#//g' /mnt/etc/lightdm/lightdm.conf
        sed -i '/greeter-session=example-gtk-gnome/s/example-gtk-gnome/lightdm-gtk-greeter/g' /mnt/etc/lightdm/lightdm.conf
        arch-chroot /mnt systemctl enable lightdm
        ;;

        sddm)
        arch-chroot /mnt systemctl enable sddm
        ;;

        lxdm)
        arch-chroot /mnt systemctl enable lxdm
        ;;
    esac
}

getkernel(){
    kernel=`whiptail --title "$getkernelttl" --cancel-button "$exitbuttonttl" --menu "$getkernelmsg" 20 80 10 "<-- Back" "To previous menu" "linux" "." "linux-zen" "." "linux-hardened" "." 3>&1 1>&2 2>&3`
    if [ -z $kernel ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$kernel" == "<-- Back" ]; then
        getdisplaymanager
    else
        getadditionalpkgsctg
    fi
}

getadditionalpkgsctg(){
    pkgsctg=`whiptail --title "$getadditionalpkgsttl" --cancel-button "$exitbuttonttl" --menu "$getadditionalpkgsmsg1" 20 80 10 "<-- Back" "To previous menu" "Audio" "pulseaudio,clementine,etc" "Media" "Mpv,Vlc,Gstreamer,etc" "Commiunication" "Telegram,Signal" "Editing" "Gimp,kdenlive,krita,etc" "Done" "Start Installing Arch" 3>&1 1>&2 2>&3`
    if [ -z $pkgsctg ]; then
        exit 0
        umount $mdisk*
        swapoff -a
    elif [ "$pkgsctg" == "<-- Back" ]; then
        getdisplaymanager
    elif [ "$pkgsctg" == "Done" ]; then
        installarchlinux
    else
        getadditionalpkgs
    fi
}

getadditionalpkgs(){
    case $pkgsctg in
    Audio)
    audiopkgs=`whiptail --nocancel --title "$getadditionalpkgsaudiottl" --checklist "$getadditionalpkgsmsg2" 20 80 10 "pulseaudio" "." OFF "clementine" "." OFF 3>&1 1>&2 2>&3`
    addaudiopks=""
    for i in $audiopkgs; do
        j=${i#'"'}
        j=${j%'"'}
        addaudiopks="$addaudiopks $j"
    done
    ;;
    Media)
    mediapkgs=`whiptail --nocancel --title "$getadditionalpkgsmediattl" --checklist "$getadditionalpkgsmsg2" 20 80 10 "mpv" "." OFF "vlc" "." OFF 3>&1 1>&2 2>&3`
    addmediapkgs=""
    for i in $mediapkgs; do
        j=${i#'"'}
        j=${j%'"'}
        addmediapkgs="$addmediapkgs $j"
    done
    ;;
    Commiunication)
    commiunicationpkgs=`whiptail --nocancel --title "$getadditionalpkgscommiunicationttl" --checklist "$getadditionalpkgsmsg2" 20 80 10 "telegram-desktop" "." OFF "signal-desktop" "." OFF 3>&1 1>&2 2>&3`
    addcommiunicationpkgs=""
    for i in $commiunicationpkgs; do
        j=${i#'"'}
        j=${j%'"'}
        addcommiunicationpkgs="$addcommiunicationpkgs $j"
    done
    ;;
    Editing)
    editingpkgs=`whiptail --nocancel --title "$getadditionalpkgseditingttl" --checklist "$getadditionalpkgsmsg2" 20 80 10 "gimp" "." OFF "kdenlive" "." OFF 3>&1 1>&2 2>&3`
    addeditingpkgs=""
    for i in $editingpkgs; do
        j=${i#'"'}
        j=${j%'"'}
        addeditingpkgs="$addeditingpkgs $j"
    done
    ;;
    Aur)
    aurpkgs=`whiptail --nocancel --title "$getadditionalpkgsaurttl" --checklist "$getadditionalpkgsmsg2" 20 80 10 "yay" "." OFF "pamac-aur" "." OFF 3>&1 1>&2 2>&3`
    for i in $aurpkgs; do
        j=${i#'"'}
        j=${j%'"'}
        addaurpkgs="$addaurpkgs $j"
    done
    ;;
    esac
    getadditionalpkgsctg
}

setadditionalpkgs(){
    arch-chroot /mnt pacman -S $addaudiopks $addmediapkgs $addcommiunicationpkgs $addeditingpkgs --noconfirm
    if [ -n $aurpkgs ]; then
        for i in $addaurpkgs; do
            arch-chroot /mnt git clone https://aur.archlinux.org/$i.git
            arch-chroot /mnt sudo -u $username makepkg -si $i
        done
    fi
}

setfstab(){
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

setinitramfs(){
    arch-chroot /mnt mkinitcpio -P
}

setbootloader(){
    if [ $efi -eq 1 ]; then
        arch-chroot /mnt pacman -S grub efibootmgr efivar dosfstools fuse2 os-prober ntfs-3g --noconfirm
        echo "GRUB_DISABLE_OS_PROBER=false" >> /mnt/etc/default/grub
        arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --recheck $mdisk
        arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg 
    elif [ $efi -eq 0 ]; then
        arch-chroot /mnt pacman -S grub os-prober fuse2 ntfs-3g --noconfirm
        echo "GRUB_DISABLE_OS_PROBER=false" >> /mnt/etc/default/grub
        arch-chroot /mnt grub-install --recheck $mdisk 
        arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg 
    fi
}

setnetwork(){
    arch-chroot /mnt pacman -S networkmanager network-manager-applet nm-connection-editor --noconfirm
    arch-chroot /mnt systemctl enable NetworkManager
}

installarchlinux(){
    clear
    sed -i '1i Server = http://192.168.1.3:8080' /etc/pacman.d/mirrorlist
    pacstrap /mnt base base-devel $kernel $kernel-headers linux-firmware nano vim git --noconfirm
    if [ "$partitiontype" == "Btrfs" ]; then
        pacstrap /mnt btrfs-progs --noconfirm
    fi
    arch-chroot /mnt pacman -Syu --noconfirm
    arch-chroot /mnt pacman -S archlinux-keyring --noconfirm
    sed -i '1i Server = http://192.168.1.3:8080' /mnt/etc/pacman.d/mirrorlist
    setfstab
    setlocale
    settimezone
    setrootpass
    setuserinfo
    setdesktop
    setinitramfs
    setbootloader
    setnetwork
    setadditionalpkgs
}

startinstall