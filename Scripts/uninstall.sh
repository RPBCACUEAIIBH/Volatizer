#! /bin/bash

# This script checks previous volatizer installation and cleans it up if found. Used by Install.sh (not standalone)

# Constants
Command="/usr/local/bin"
Files="/usr/share/Volatizer"

# Execution
if [[ ! -z $(grep '### Volatizer modification starts ###' /usr/share/initramfs-tools/scripts/local) || ! -z $(grep "olatizer" "/etc/kernel/postinst.d/zz-update-grub") || ! -z $(grep "olatizer" "/etc/kernel/postrm.d/zz-update-grub") || -e $Command/volatizer* || -d $Files || -f /etc/sudoers.d/Volatizer-sudoers || -f /normalboot ]]
then
  Fail=false  
  echo 'Warning! Previous volatizer installation detected. Attempting to clean up...'
  # Fate of Volatizer Config
  echo ""
  read -t 15 -p "Do you want to remove personal volatizer configiration files for all users? (Only recommended if Volatizer won't be reinstalled. y/n) " Yy
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
  # Junk left may be left at /
  if [[ -f /normalboot ]] # This may annoy people after reinstalling...
  then
    rm -f /normalboot
  fi
  # Sudoers file
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
  # Journal config mod...
  if [[ -f "/etc/systemd/journald.conf.old" ]] # This is just a config file...
  then
    cp "/etc/systemd/journald.conf.old" "/etc/systemd/journald.conf"
    systemctl restart systemd-journald.service
  else
    echo "Warning: /etc/systemd/journald.conf.old file missing."
  fi
  # Kernel mod...
  #CAUTION! Do not restore the old one if it's getting uninstalld because it doesn't work, and it doesn't work because initramfs was updated... Keep the updated version!
  if [[ -f "/etc/kernel/postinst.d/zz-update-grub.old" ]]
  then
    if [[ ! -z $(grep "olatizer" "/etc/kernel/postinst.d/zz-update-grub") ]]
    then
      mv -f "/etc/kernel/postinst.d/zz-update-grub.old" "/etc/kernel/postinst.d/zz-update-grub"
    else
      echo "Warning: Can't find Volatizer entry in /etc/kernel/postinst.d/zz-update-grub. Keeping it as it may have been replaced by a system update!"
    fi
  else
    echo "Error: /etc/kernel/postinst.d/zz-update-grub.old file missing. Can't properly remove Volatizer!"
    Fail=true
  fi
  if [[ -f "/etc/kernel/postrm.d/zz-update-grub.old" ]]
  then
    if [[ ! -z $(grep "olatizer" "/etc/kernel/postrm.d/zz-update-grub") ]]
    then
      mv -f "/etc/kernel/postrm.d/zz-update-grub.old" "/etc/kernel/postrm.d/zz-update-grub"
    else
      echo "Warning: Can't find Volatizer entry in /etc/kernel/postrm.d/zz-update-grub. Keeping it as it may have been replaced by a system update!"
    fi
  else
    echo "Error: /etc/kernel/postrm.d/zz-update-grub.old file missing. Can't properly remove Volatizer!"
    Fail=true
  fi
  # Initramfs mod...
  #CAUTION! Do not restore the old one if it's getting uninstalld because it doesn't work, and it doesn't work because initramfs was updated... Keep the updated version!
  if [[ -f "/usr/share/initramfs-tools/scripts/local.old" ]]
  then
    if [[ ! -z $(grep "### Volatizer modification starts ###" "/usr/share/initramfs-tools/scripts/local") ]]
    then
      mv -f "/usr/share/initramfs-tools/scripts/local.old" "/usr/share/initramfs-tools/scripts/local"
      update-initramfs -u
    else
      echo "Warning: Can't find Volatizer entry in /usr/share/initramfs-tools/scripts/local. Keeping it as it may have been replaced by a system update!"
    fi
  else
    echo "Error: /usr/share/initramfs-tools/scripts/local.old file missing. Can't properly remove Volatizer!"
    Fail=true
  fi
  # Grub mod...
  if [[ -f /etc/default/grub.old ]]
  then
    mv -f /etc/default/grub.old /etc/default/grub
    update-grub
  else
    echo 'Error: /etc/default/grub.old file missing.'
    Fail=true
  fi
  # Alert if fatal errors encountered
  if [[ $Fail == false ]]
  then
    echo ""
    echo "Older version of files has been successfully restored, and previous volatizer installation removed."
    echo "For double checking please run this script again. ...or do not if you just wanted to get rid of it."
  else
    echo ""
    echo "Oh crap! :S Fatal error(s) occured!"
    echo "SAVE ALL YOUR DATA AND MAKE A LIVE DISK BEFORE SHUTDOWN/REBOOT, CAUSE IT MAY OR MAY NOT BE ABLE TO REBOOT!"
  fi
  echo ""
  #Delete files
  # This is basically it's self destruct sequence... Therefore deleting itself must be the last thing it does...
  # (Shell does not load the entire script into memory before execution, only the current block of code, thus it may never get further then this if statement if it's deleted before the rest of it is done.)
  if [[ -d $Files ]]
  then
    rm -Rf $Files
  fi
  exit 1
else
  echo "Previous volatizer modification check >> OK"
  echo ""
fi
