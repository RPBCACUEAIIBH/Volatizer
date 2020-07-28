#! /bin/bash

# This script checks previous volatizer installation and cleans it up if found. Used by Install.sh (not standalone)

# Constants
Command="/usr/local/bin"
Files="/usr/share/Volatizer"

# Execution
if [[ ! -z $(grep '### Volatizer modification starts ###' /usr/share/initramfs-tools/scripts/local) || -e $Command/volatizer* || -d $Files || -f /etc/sudoers.d/Volatizer-sudoers || -f /normalboot ]]
then
  Fail=false
  
  echo 'Warning! Previous volatizer installation detected. Attempting to clean up...'
  if [[ -f /etc/default/grub.old ]]
  then
    mv -f /etc/default/grub.old /etc/default/grub
    update-grub
  else
    echo 'Error: /etc/default/grub.old file missing.'
    Fail=true
  fi
  #CAUTION! Do not restore the old one if it's getting uninstalld because it doesn't work, and it doesn't work because initramfs was updated... Keep the updated version!
  if [[ -f /usr/share/initramfs-tools/scripts/local.old && ! -z $(grep '### Volatizer modification starts ###' /usr/share/initramfs-tools/scripts/local) ]] # just a bit of foolproofing...
  then
    mv -f /usr/share/initramfs-tools/scripts/local.old /usr/share/initramfs-tools/scripts/local
    update-initramfs -u
  else
    echo 'Error: /usr/share/initramfs-tools/scripts/local.old file missing.'
    Fail=true
  fi
  if [[ -f /etc/sudoers.d/Volatizer-sudoers ]]
  then
    rm -f /etc/sudoers.d/Volatizer-sudoers
  fi
  for i in $(ls $Command/volatizer*)
  do
    if [[ ! -z $(echo $i | grep "$Command/volatizer") ]]
    then
      if [[ $(echo $i | grep "$Command/volatizer") != "$Command/volatizer\*" ]] # just in case it tries to delete the cannot access nonexistent files message from ls command.
      then
        rm -f $i
      fi
    fi
  done
  if [[ -f /normalboot ]] # This may annoy people after reinstalling...
  then
    rm -f /normalboot
  fi
  if [[ $Fail == false ]]
  then
    echo ''
    echo 'Older version of files has been successfully restored, and previous volatizer installation removed.'
    echo 'For double checking please run this script again. ...or do not if you just wanted to get rid of it.'
  else
    echo ''
    echo "Oh crap! :S Fatal error(s) occured!"
    echo "SAVE ALL YOUR DATA AND MAKE A LIVE DISK BEFORE SHUTDOWN/REBOOT, CAUSE IT MAY OR MAY NOT BE ABLE TO REBOOT!"
  fi
  echo ""
  read -t 7 -p "Do you want to remove personal volatizer configiration files for all users? (Only recommended if Volatizer won't be reinstalled. y/n) " Yy
  if [[ $Yy == [Yy]* ]]
  then
    for i in $(ls /home)
    do
      if [[ -d /home/$i/.Volatizer ]]
      then
        rm -Rf /home/$i/.Volatizer
      fi
    done
  fi
  echo ""
  # This is basically it's self destruct sequence... Therefore deleting itself must be the last thing it does...
  # (Shell does not load the entire script into memory before execution, only the current block of code, thus it may never get further then this if statement if it's deleted before the rest of it is done.)
  if [[ -d $Files ]]
  then
    rm -Rf $Files
  fi
  exit 1
else
  echo 'Previous volatizer modification check >> OK'
  echo ''
fi
