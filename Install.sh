#! /bin/bash

################################################################################
# Volatizer                                                                    #
################################################################################
#                                                                              #
# Version 1.1                                                                  #
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
if [[ ! -z $(grep 'mount ${roflag} ${FSTYPE:+-t ${FSTYPE} }${ROOTFLAGS} ${ROOT} ${rootmnt}' /usr/share/initramfs-tools/scripts/local) || ! -z $(grep 'mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"' /usr/share/initramfs-tools/scripts/local) || ! -z $(cat /etc/*-release | grep "Debian GNU/Linux") ]]
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

if [[ ! -z $(grep '### Volatizer modification starts ###' /usr/share/initramfs-tools/scripts/local) || ! -z $(grep '### End of Volatizer modifications ###' /usr/share/initramfs-tools/scripts/local) ]]
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
if [[ ! -z $(cat /etc/*-release | grep "Debian GNU/Linux") ]] # Debian
then
L0='        '
L1='        ### Volatizer modification starts ###'
L2='        read -t 10 -p "Do you want to boot normally? (enter Y if so...)" Yy'
L3='        case $Yy in'
L4='          [Yy]* ) clear'
L5='                  echo "Starting in Normal mode!"'
L61='                  if ! mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"'
L62='                  then'
L63='                    MountFail=true'
L64='                  else'
L65='                    MountFail=false'
L66='                  fi'
L7='                  ;;'
L8='               *) clear'
L9='                  echo "Starting in Volatile mode! Please wait! This may take 10-15 minutes."'
L10='                  mount -t tmpfs -o rw,noatime,nodiratime,size=100% tmpfs "${rootmnt?}"' # Mounting available RAM to ${rootmnt}
L11='                  mkdir /volatizertmp'
L121='                  if ! mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"}${ROOTFLAGS} "${ROOT}" "/volatizertmp"'
L122='                  then'
L123='                    MountFail=true'
L124='                  else'
L125='                    MountFail=false'
L13='                     cp -rfa /volatizertmp/* "${rootmnt?}"'
L14='                     umount /volatizertmp'
L15='                     rm /volatizertmp'
L126='                  fi'
L16='                  ;;'
L17='        esac'
L18='        if [[ $MountFail == true ]]'
L19='        then'
L20='        ### End of Volatizer modifications ###'
sed -i "/if ! mount \${roflag} \${FSTYPE:+-t \"\${FSTYPE}\"} \${ROOTFLAGS} \"\${ROOT}\" \"\${rootmnt?}\"; then/ c\\$L0\n$L1\n$L2\n$L3\n$L4\n$L5\n$L61\n$L62\n$L63\n$L64\n$L65\n$L66\n$L7\n$L8\n$L9\n$L10\n$L11\n$L121\n$L122\n$L123\n$L124\n$L125\n$L13\n$L14\n$L15\n$L126\n$L16\n$L17\n$L18\n$L19\n$L20" /usr/share/initramfs-tools/scripts/local
elif [[ ! -z $(grep 'mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"' /usr/share/initramfs-tools/scripts/local) ]] # Ubuntu 20.04+
then



L0='        '
L011='        ### Volatizer modification starts ###'
L012='        sleep 5 # Let the messages end cause it is easy to miss the prompt among the messages... :-/'
L2='        read -t 10 -p "Do you want to boot normally? (enter Y if so...)" Yy'
L3='        case $Yy in'
L4='          [Yy]* ) clear'
L5='                  echo "Starting in Normal mode!"'
L6='                  mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"'
L7='                  ;;'
L8='               *) clear'
L9='                  echo "Starting in Volatile mode! Please wait! This may take 10-15 minutes."'
L10='                  mount -t tmpfs -o rw,noatime,nodiratime,size=100% tmpfs "${rootmnt?}"' # Mounting available RAM to ${rootmnt}
L11='                  mkdir /volatizertmp'
L12='                  mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"}${ROOTFLAGS} "${ROOT}" "/volatizertmp"'
L13='                  cp -rfa /volatizertmp/* "${rootmnt?}"'
L14='                  umount /volatizertmp'
L15='                  rm /volatizertmp'
L16='                  ;;'
L17='        esac'
L18='        ### End of Volatizer modifications ###'
sed -i "/mount \${roflag} \${FSTYPE:+-t \"\${FSTYPE}\"} \${ROOTFLAGS} \"\${ROOT}\" \"\${rootmnt?}\"/ c\\$L0\n$L011\n$L012\n$L2\n$L3\n$L4\n$L5\n$L6\n$L7\n$L8\n$L9\n$L10\n$L11\n$L12\n$L13\n$L14\n$L15\n$L16\n$L17\n$L18" /usr/share/initramfs-tools/scripts/local



else # Earlier Ubuntu/Mint
L0='        '
L1='        ### Volatizer modification starts ###'
L2='        read -t 10 -p "Do you want to boot normally? (enter Y if so...)" Yy'
L3='        case $Yy in'
L4='          [Yy]* ) clear'
L5='                  echo "Starting in Normal mode!"'
L6='                  mount ${roflag} ${FSTYPE:+-t ${FSTYPE} }${ROOTFLAGS} ${ROOT} ${rootmnt}' # For compatibility with other distros, this entry may have to be changed to something similar found in the original /usr/share/initramfs-tools/scripts/local file in the mout root function. Also change this line above at the compatibility check, and previous modification check fail-safes...
L7='                  ;;'
L8='               *) clear'
L9='                  echo "Starting in Volatile mode! Please wait! This may take 10-15 minutes."'
L10='                  mount -t tmpfs -o rw,noatime,nodiratime,size=100% tmpfs ${rootmnt}' # Mounting available RAM to ${rootmnt}
L11='                  mkdir /volatizertmp'
L12='                  mount ${roflag} ${FSTYPE:+-t ${FSTYPE} }${ROOTFLAGS} ${ROOT} /volatizertmp' # Mounting root partition to /volatizertmp. Note that this is almost the same as the original entry, except the mount point... For compatibility with other distros, this also has to be changed, but the mount point should be /volatizertmp. ...and that is probably the main difference between most debian based distros, and ubuntu why it should not work...
L13='                  cp -rfa /volatizertmp/* ${rootmnt}'
L14='                  umount /volatizertmp'
L15='                  rm /volatizertmp'
L16='                  ;;'
L17='        esac'
L18='        ### End of Volatizer modifications ###'
L19='        '
sed -i "/mount \${roflag} \${FSTYPE:+-t \${FSTYPE} }\${ROOTFLAGS} \${ROOT} \${rootmnt}/ c\\$L0\n$L1\n$L2\n$L3\n$L4\n$L5\n$L6\n$L7\n$L8\n$L9\n$L10\n$L11\n$L12\n$L13\n$L14\n$L15\n$L16\n$L17\n$L18\n$L19" /usr/share/initramfs-tools/scripts/local
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
