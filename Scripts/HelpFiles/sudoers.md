Usage: sudo volatizer-sudoers [user_or_%group] [script_1] [script_2] ...
   or: sudo volatizer-sudoers [option] [volatizer-sudoers entry inside ""]

This script is an admin tool for easily adding scripts to sudoers, and it
needs super user rights... Use it carefuly! ;)

  -l                          display the content of the sudoers file
  -r                          removes specified entry, must be exact metch
                              between ""
                              (If -r option won't work try again... It should
                              work the second time for some reason I'll try to
                              fix it later...)
      --help                  display this help file and exit

Note that you can not have spaces anywhere in the location and/or script name,
otherwise this script will not function properly...
