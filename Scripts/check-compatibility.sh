#! /bin/bash

# This script checks the system for compatibility. Used by Install.sh and volatizer-repair. (not standalone)

echo ''
echo ''
echo 'Checking requirements...'
echo ''

# Root check
if [[ $(whoami) != "root" ]]
then
  echo "Root check >> Failed! Can't do modification as regular user!"
  echo ''
  exit 1
else
  echo "Root check >> OK"
  echo ''
fi

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
if [[ $(./volatizer-mode) == "Volatile" ]]
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
  exit 1
else
  exit 0
fi
