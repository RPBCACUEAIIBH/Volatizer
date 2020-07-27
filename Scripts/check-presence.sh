#! /bin/bash

# This script checks previous volatizer installation and cleans it up if found. Used by Install.sh (not standalone)

if [[ ! -z $(grep '### Volatizer modification starts ###' /usr/share/initramfs-tools/scripts/local) ]]
then
  echo 'Warning! Previous volatizer installation detected. Attempting to clean up...'
  if [[ -f /etc/default/grub.old ]]
  then
    mv -f /etc/default/grub.old /etc/default/grub
    update-grub
  else
    echo 'Error: /etc/default/grub.old file missing.'
    Fail=true
  fi
  if [[ -f /usr/share/initramfs-tools/scripts/local.old ]]
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
  for i in $(ls /home)
  do
    if [[ -d /home/$i/.Volatizer ]]
    then
      rm -Rf /home/$i/.Volatizer
      rm -Rf /home/$i/Notice
    fi
  done
  if [[ -d $Files ]]
  then
    rm -Rf $Files
  fi
  if [[ -f /normalboot ]] # This may annoy people after reinstalling...
  then
    rm -f /normalboot
  fi
  if [[ $Fail == false ]]
  then
    echo ''
    echo 'Older version of files has been successfully restored, and previous volatizer installation removed.'
    echo 'For double checking please run this script again. ...or do not if you just wanted to get rid of it.'
    exit
  else
    echo ''
    echo "Fatal errors occurred! You may have to start with a new installation or a different distro..."
    echo "Please save all your data before shutting down or rebooting, cause it may not restart..."
    exit 1
  fi
else
  echo 'Previous volatizer modification check >> OK'
  echo ''
fi
