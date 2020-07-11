#! /bin/bash

################################################################################
# Volatizer                                                                    #
################################################################################
#                                                                              #
# Version 1.2                                                                  #
# Written by: Tibor Áser Veres                                                 #
# Source: https://github.com/RPBCACUEAIIBH/Volatizer                           #
# License: BSD License 2.0 (see LICENSE.md file)                               #
#                                                                              #
################################################################################

# Constants
Command="/usr/local/bin"
Files="/usr/share/Volatizer"

# Finding roots
ScriptPath="$(cd "$(dirname "$0")"; pwd -P)"
cd $ScriptPath

# Root check
if [[ $(whoami) != "root" ]]
then
  echo "This script needs to run as root!"
  exit
fi

echo ''
echo ''
echo 'Checking requirements...'
echo ''
Fail=false

# Memory check
if [[ $(grep "MemTotal:" /proc/meminfo | awk '{ print $2 }') -lt 7300000 ]]
then
  echo 'Memory check >> Failed! Not enough available memory! Please install more memory in your computer, or asign less memory to GPU if it uses shared memory.'
  echo ''
  Fail=true
else
  echo 'Memory check >> OK'
  echo ''
fi

# Compatibility check
if [[ ! -z $(grep 'mount ${roflag} ${FSTYPE:+-t ${FSTYPE} }${ROOTFLAGS} ${ROOT} ${rootmnt}' /usr/share/initramfs-tools/scripts/local) || ! -z $(cat /etc/*-release | grep "Debian GNU/Linux") ]]
then
  echo 'Compatibility check >> OK'
  echo ''
else
  echo 'Compatibility check >> Failed! Please choose another distro...'
  echo ''
  Fail=true
fi

# Mode check
if [[ $(./Scripts/volatizer-mode) == "Volatile" ]]
then
  echo 'The system runs in "Volatile" mode! Please reboot into normal mode and try again!'
  echo ''
  Fail=true
else
  echo 'Mode check >> OK'
  echo ''
fi

if [[ $Fail == true ]]
then
  echo ''
  echo 'Requirements >> Failed!'
  echo ''
  sleep 20
  exit
fi

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
###
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
###
  for i in $(ls /home)
  do
    if [[ -d /home/$i/.Volatizer ]]
    then
      rm -Rf /home/$i/.Volatizer
      rm -Rf /home/$i/Notice
      cp -fa /home/$i/.bashrc.old /home/$i/.bashrc
    fi
  done
  if [[ -d $Files ]]
  then
    rm -Rf $Files
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
    exit
  fi
else
  echo 'Previous volatizer modification check >> OK'
  echo ''
fi

if [[ -f ./LICENSE.md ]]
then
  echo "Please read the license:"
  echo ''
  cat ./LICENSE.md
  echo ''
  echo ''
  read -p 'Do you agree to this license?(type "Yes" and press enter if so.): ' Yy
  echo ''
else
  echo 'Error: License agreement not found!'
  echo ''
  Yy="No"
fi

if [[ $Yy != "Yes" ]]
then
  echo 'Agreement >> Failed!'
  echo ''
  exit
else
  echo 'Agreement >> OK'
  echo ''
  echo 'All requirements are met!'
  echo ''
  echo ''
fi

echo ''
echo 'Transforming... Please wait!'
echo ''
echo "Forcing GRUB, and Volatizer prompt to appear"
cp /etc/default/grub /etc/default/grub.old
sed -i '/GRUB_HIDDEN_TIMEOUT=0/ c\#GRUB_HIDDEN_TIMEOUT=0' /etc/default/grub
sed -i '/GRUB_HIDDEN_TIMEOUT_QUIET=true/ c\#GRUB_HIDDEN_TIMEOUT_QUIET=true' /etc/default/grub
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/ c\GRUB_CMDLINE_LINUX_DEFAULT=""' /etc/default/grub
echo ''
echo ''
echo "Setting swappines to 0! Swapping would make volatizer nearly pointless..."
sysctl vm.swappiness=0
echo ''
echo 'Done!'
echo ''

echo ''
echo 'Making changes to initramfs'
cp /usr/share/initramfs-tools/scripts/local /usr/share/initramfs-tools/scripts/local.old
if [[ ! -z $(cat /etc/*-release | grep "Debian GNU/Linux") ]]
then
L0='        '
L1='        ### Volatizer modification starts ###'
L2='        read -t 10 -p "Do you want to boot normally? (enter Y if so...)" Yy'
L3='        case $Yy in'
L4='          [Yy]* ) clear'
L5='                  echo "Starting in Normal mode!"'
L6='                  if ! mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"'
L7='                  then'
L8='                    MountFail=true'
L9='                  else'
L10='                    MountFail=false'
L11='                  fi'
L12='                  ;;'
L13='               *) clear'
L14='                    mkdir /volatizertmp'
L15='                  if ! mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"}${ROOTFLAGS} "${ROOT}" "/volatizertmp"'
L16='                  then'
L17='                    MountFail=true'
L18='                  else'
L19='                    if [[ -e "/volatizertmp/normalboot" ]]'
L20='                    then'
L21='                      echo "Normal boot request file found! Booting normally..."'
L22='                      sleep 2'
L23='                      umount /volatizertmp'
L24='                      rm /volatizertmp'
L25='                      if ! mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"'
L26='                      then'
L27='                        MountFail=true'
L28='                      else'
L29='                        MountFail=false'
L30='                      fi'
L31='                    else'
L32='                      echo "Starting in Volatile mode! Please wait! This may take 10-15 minutes."'
L33='                      mount -t tmpfs -o rw,noatime,nodiratime,size=100% tmpfs "${rootmnt?}"' # Mounting available RAM to ${rootmnt}
L34='                      cp -rfa /volatizertmp/* "${rootmnt?}"'
L35='                      umount /volatizertmp'
L36='                      rm /volatizertmp'
L37='                      MountFail=false'
L38='                    fi'
L39='                  fi'
L40='                  ;;'
L41='        esac'
L42='        if [[ $MountFail == true ]]'
L43='        then'
L44='        ### End of Volatizer modifications ###'
sed -i "/if ! mount \${roflag} \${FSTYPE:+-t \"\${FSTYPE}\"} \${ROOTFLAGS} \"\${ROOT}\" \"\${rootmnt?}\"; then/ c\\$L0\n$L1\n$L2\n$L3\n$L4\n$L5\n$L6\n$L7\n$L8\n$L9\n$L10\n$L11\n$L12\n$L13\n$L14\n$L15\n$L16\n$L17\n$L18\n$L19\n$L20\n$L21\n$L22\n$L23\n$L24\n$L25\n$L26\n$L27\n$L28\n$L29\n$L30\n$L31\n$L32\n$L33\n$L34\n$L35\n$L36\n$L37\n$L38\n$L39\n$L40\n$L41\n$L42\n$L43\n$L44" /usr/share/initramfs-tools/scripts/local
else
L0='        '
L1='        ### Volatizer modification starts ###'
L2='        read -t 10 -p "Do you want to boot normally? (enter Y if so...)" Yy'
L3='        case $Yy in'
L4='          [Yy]* ) clear'
L5='                  echo "Starting in Normal mode!"'
L6='                  mount ${roflag} ${FSTYPE:+-t ${FSTYPE} }${ROOTFLAGS} ${ROOT} ${rootmnt}' # For compatibility with other distros, this entry may have to be changed to something similar found in the original /usr/share/initramfs-tools/scripts/local file in the mout root function. Also change this line above at the compatibility check, and previous modification check fail-safes...
L7='                  ;;'
L8='               *) clear'
L9='                  mkdir /volatizertmp'
L10='                  mount ${roflag} ${FSTYPE:+-t ${FSTYPE} }${ROOTFLAGS} ${ROOT} /volatizertmp' # Mounting root partition to /volatizertmp. Note that this is almost the same as the original entry, except the mount point... For compatibility with other distros, this also has to be changed, but the mount point should be /volatizertmp. ...and that is probably the main difference between most debian based distros, and ubuntu why it should not work...
L11='                  if [[ -e "/volatizertmp/normalboot" ]]'
L12='                  then'
L13='                    umount /volatizertmp'
L14='                    rm /volatizertmp'
L15='                    echo "Normal boot request file found! Booting normally..."'
L16='                    sleep 2'
L17='                    mount ${roflag} ${FSTYPE:+-t ${FSTYPE} }${ROOTFLAGS} ${ROOT} ${rootmnt}' # For compatibility with other distros, this entry may have to be changed to something similar found in the original /usr/share/initramfs-tools/scripts/local file in the mout root function. Also change this line above at the compatibility check, and previous modification check fail-safes...
L18='                  else'
L19='                    echo "Starting in Volatile mode! Please wait! This may take 10-15 minutes."'
L20='                    mount -t tmpfs -o rw,noatime,nodiratime,size=100% tmpfs ${rootmnt}' # Mounting available RAM to ${rootmnt}
L21='                    cp -rfa /volatizertmp/* ${rootmnt}'
L22='                    umount /volatizertmp'
L23='                    rm /volatizertmp'
L24='                  fi'
L25='                  ;;'
L26='        esac'
L27='        ### End of Volatizer modifications ###'
L28='        '
sed -i "/mount \${roflag} \${FSTYPE:+-t \${FSTYPE} }\${ROOTFLAGS} \${ROOT} \${rootmnt}/ c\\$L0\n$L1\n$L2\n$L3\n$L4\n$L5\n$L6\n$L7\n$L8\n$L9\n$L10\n$L11\n$L12\n$L13\n$L14\n$L15\n$L16\n$L17\n$L18\n$L19\n$L20\n$L21\n$L22\n$L23\n$L24\n$L25\n$L26\n$L27\n$L28" /usr/share/initramfs-tools/scripts/local
fi
echo ''
echo 'Done!'
echo ''

echo ''
echo 'Copying shared files' ################################################################# This is a danger zone #######################################################################
mkdir $Files
cp -R ./Scripts/HelpFiles $Files
cp ./LICENSE.md $Files
chown -R root:root $Files
chmod -R 755 $Files
cp ./Scripts/* $Command
chown -R root:root $Command
chmod -R 755 $Command
echo ''
echo 'Done!'
echo ''

echo ''
echo 'Creating /etc/sudoers.d/Volatizer-sudoers file'
touch /tmp/Volatizer-sudoers
echo "%sudo ALL = (ALL:ALL) PASSWD: $Command/volatizer-recover" | tee -a /tmp/Volatizer-sudoers
echo "%sudo ALL = (ALL:ALL) PASSWD: $Command/volatizer-sudoers" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-backup" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-cleanup" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-reswap" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-save" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-bootmode" | tee -a /tmp/Volatizer-sudoers
cp /tmp/Volatizer-sudoers /etc/sudoers.d/Volatizer-sudoers
chown root:root /etc/sudoers.d/Volatizer-sudoers
chmod 0440 /etc/sudoers.d/Volatizer-sudoers
echo ''
echo 'Done!'
echo ''
echo 'For adding customs scripts easily to sudoers use the /usr/share/Volatizer/sudoscript-nopw.sh. for more information use "--help" option.'
echo 'If for some reason sudoers can not be parsed, and sudo command does not work, you can use "pkexec nano /etc/sudoers.d/volatizer-sudoers" command to correct it.'
echo ''

echo ''
echo 'Copying files for users'
echo ''
for i in $(ls /home)
do
  if [[ -f /home/$i/.bashrc ]]
  then
    echo "Copying files for $i"
    mkdir /home/$i/.Volatizer
    cp ./UserFiles/* /home/$i/.Volatizer
    chown -R $i:$i /home/$i/.Volatizer
    chmod -R 755 /home/$i/.Volatizer
    ln -s $Files/LICENSE.md /home/$i/.Volatizer
    echo ''
  fi
done
echo ''
echo 'Done!'
echo ''

echo ''
echo 'Finalizing modification...'
update-grub
update-initramfs -u
echo ''
echo 'Done!'
echo ''

echo ''
echo '-> You will only be able to update your system, install and remove programs permanently when the system is running in normal mode! (You will be able to choose mode after the grub scren.)'
echo '-> Note that every user can individually edit their own config file at /home/$USER/.Volatizer/Config, so you may want to set it for them and make it owned by root and read only, to protect solid state drives from agressive write configs...'
echo '-> Use "--help" option with any of the volatizer commands for more.'
echo ''
echo 'You can add keyboard shortcuts for certain Volatizer features for better productivity...'
echo ''
