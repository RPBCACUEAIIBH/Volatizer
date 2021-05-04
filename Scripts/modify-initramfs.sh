#! /bin/bash

# This script is not meant to be ran as a stand alone script, it's called by the Install.sh and volatizer-repair. (not standalone)

### Execution ###
echo ""
echo "Changing the way root is mounted..."
cp "/usr/share/initramfs-tools/scripts/local" "/usr/share/initramfs-tools/scripts/local.old"
if [[ ! -z $(cat /etc/*-release | grep "Debian GNU/Linux") ]] # Debian
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

elif [[ ! -z $(grep 'mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"' /usr/share/initramfs-tools/scripts/local) ]] # Ubuntu 20.04+
then
L0='        '
L1='        ### Volatizer modification starts ###'
L2='        echo ""'
L3='        sleep 3 # Let the messages end cause it is easy to miss the prompt among the messages... :-/'
L4='        read -t 10 -p "Do you want to boot normally? (enter Y if so...)" Yy'
L5='        case $Yy in'
L6='          [Yy]* ) clear'
L7='                  echo "Starting in Normal mode!"'
L8='                  mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"'
L9='                  ;;'
L10='               *) clear'
L11='                  mkdir /volatizertmp'
L12='                  mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"}${ROOTFLAGS} "${ROOT}" "/volatizertmp"'
L13='                  if [[ -e "/volatizertmp/normalboot" ]]'
L14='                  then'
L15='                    echo ""'
L16='                    echo "Normal boot request file found! Booting normally..."'
L17='                    sleep 3' # Sleep does not seem to work here for ubuntu 20.04
L18='                    umount /volatizertmp'
L19='                    rmdir /volatizertmp'
L20='                    mount ${roflag} ${FSTYPE:+-t "${FSTYPE}"} ${ROOTFLAGS} "${ROOT}" "${rootmnt?}"'
L21='                  else'
L22='                    echo "Starting in Volatile mode! Please wait! This may take 10-15 minutes."'
L23='                    mount -t tmpfs -o rw,noatime,nodiratime,size=100% tmpfs "${rootmnt?}"' # Mounting available RAM to ${rootmnt}
L24='                    cp -rfa /volatizertmp/* "${rootmnt?}"'
L25='                    umount /volatizertmp'
L26='                    rm /volatizertmp'
L27='                  fi'
L28='                  ;;'
L29='        esac'
L30='        ### End of Volatizer modifications ###'
sed -i "/mount \${roflag} \${FSTYPE:+-t \"\${FSTYPE}\"} \${ROOTFLAGS} \"\${ROOT}\" \"\${rootmnt?}\"/ c\\$L0\n$L1\n$L2\n$L2\n$L3\n$L4\n$L5\n$L6\n$L7\n$L8\n$L9\n$L10\n$L11\n$L12\n$L13\n$L14\n$L15\n$L15\n$L16\n$L17\n$L18\n$L19\n$L20\n$L21\n$L15\n$L15\n$L22\n$L23\n$L24\n$L25\n$L26\n$L27\n$L28\n$L29\n$L30" /usr/share/initramfs-tools/scripts/local

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
