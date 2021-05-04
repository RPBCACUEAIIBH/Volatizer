Readme for Volatizer

A breief story:
Long story short: My hard drive is old, slow, and it's dieing a slow death... I was looking for ways to minimize it's usage while also speeding up the system, and having no money to just buy an SSD...
So I've searched the internet to find out if I could load the system entirely into RAM, then spin down the old hard drive to preserve it as long as possible, and I found this article:
http://www.elettronicaopensource.com/index.php?f1=mostra_articolo.php&rw=1&art=32 but it was for debian, and I'm using ubuntu(which is debian based but a bit different), and I managed to do it in a few hours, then I wanted to be able to switch back and fort between normal and volatile mode, then to save user data, and I've done it, then after a bit I've lost the system partition agan... so I wanted backups, and so on... :D I figured that others may be interested for whatever reason, so I've cleaned up the code, wrote help files, and this is the result.

Feature decription:
- Loads a fully installed operating system into RAM not only Ubuntu 16.04, I've sucessfuly tested it on various flavors of Ubuntu and on Linux Mint as well as on Debian(v1.1+).
- You can choose mode after the grub screen, or by runing "volatizer bootmode" with -n or -v options(as of v1.2+) and use it in normal mode if you want...(which is faster to start when you'r in a hurry but less responsive)
- You can do updates, install, and remove programs, in normal mode, then restart to Volatile mode, with the changes you've made in normal mode.
- You can save user data there's even an autosave feature built in, you just have to launch it!
- You can make backup of user data either automatically or manually.
- It's easy to use: The only extra command you really have to remember is "volatizer" the rest is pretty much self explanatory, assuming you have a minimal experience in shell.
- You can use it for learning, and experimenting with dangerous settings in volatile mode, since restroing a broken system is as easy as pressing reset and waiting for it to reboot.
- Works via SSH(v1.2+)

Advantages:
- RAM is the fastest type of memory, it's faster then a RAID0 array of high speed SSDs! This makes the system extremely responsive.(It won't make your processor work faster, even though you may experince some boost in performance it's only due to the CPU not having to wait for data as much not not because it runs faster... Try overclocking for improving CPU performance specifically...)
- It makes the system more forgiving to inexperienced users with admin rights ;)
- It's easy to use since it's built for everyday use(by lazy myself XD).

Disadvantages:
- You need at least 8GB of RAM, 16GB or more is highly recommended! (Ubuntu no longer fits in 8GB... :-/)
- Slow boot... it can take up to 10-15 minutes to load 4-6GB to memory from a slow mechanical hard drive, it should take about 2-3 minutes from SSD... It worth waiting if you don't often turn it off, but put it to sleep. Use the reswap function to restore speed if you see swapping...
- RAM is called volatile memory for good reason! In volatile mode: 1. If the power goes out, and you have no UPS or the battery dies you loose data instantly! 2. If you forget to save it before shutdown or reboot your data is gone for good! (That's where the save, autosave and backup functions come in handy... use them carefully!)

Known issues and workarounds:
- You will get all sorts of erros and warnings if trying to update install things in volatile mode, telling you to prepare for apocalipse... Don't panic! Ubuntu wansn't exactly designed to run in RAM (tmpfs) without protest... ;) You'll be just fine as the data on system partition will be discarded upon shutdown/reboot anyway. Even if you run the save script, only your home folder will be saved(with everything in it.), but nothing from the system partition... So ignore those warnings and errors...
- If your PC fails to boot into volatile mode, try normal mode... If it runs out of RAM it won't boot, since the swap is mounted after the root partition, which means that even if you're able to overfill it during normal use, swap space is useless for Volatizer! Solution: Boot into normal mode, run volatizer cleanup to get rid of the junk, move some of your data to another partition, uninstall what you don't need and thus make it smaller, then try again booting in volatile mode! (Be aware that other users can also fill up the system partition quickly causing it to not boot into volatile mode! Use disk usage analyser to find out why you don't have enough space. Ubuntu should have it installed by default! ...Or get more RAM. :D)
- Some snaps refuse to work in volatile mode... It's a pain in the ass, but you have to use those in normal mode, so if it's available install it using apt-get rather then snap.
- Clearing snap cache can prevent package removal by "snap remove" command! Unfortunately the cache can occupy GBs. If that happens, you can break the package, and then uninstall it by:
  A) using "df -ah" command to find out the package's filesystem, then "sudo umount /dev/loopXX" (where XX is a number). Each active snap has one...
  B) delete /snap/package-name and /var/lib/snapd/snaps/package-name.snap
  c) using "snap remove --purge package-name" to remove the broken package.

Fixed issues:
- When creating new human user, you also had to create a .Volatizer folder in his/her home folder, place a copy of the volatizer config file within it, configure it, and optionally make it owned by him/her... This was made easy in v1.2 by "volatizer newuser". (Run it with --help option for more information.) The Install script also detects, and runs this for each existing user. (I forgot to announce that it was fixed earlier...)

Supported distros(Volatizer for these are all tested and working):
- Ubuntu 20.04 (Fixed in V1.1. The initramfs was modified so it wasn't compatible... Now it is!)
- Debian 10 Buster (As of V1.1)
- Ubuntu 18.04
- Ubuntu 16.04 and 17.04 (both Desktop and Server)
- Ubuntu MATE 16.04 and 17.04
- Ubuntu Gnome 16.04 and 17.04
- Ubuntu Budgie 17.04
- Kubuntu 16.04 and 17.04
- Lubuntu 16.04 and 17.04
- Linux Mint 18.2 (Cinemon, Mate, KDE)
(Please note that I've tested it a few months earlyer, on all these distros, when I initially wanted to release, before cleaning up the code and fixing some issues... I can not guarantee that it still works on all of these... Currently I'm using it on Ubuntu Gnome 17.04 with latest updates applied!)

Known NOT supported distros(Tested but not compatible with the current version of Volatizer):
- Fedora
- Slackware

System requirements:
- 8GB(or more) RAM (the faster in MHz the better...)
- A clean installation of any supported distro on a somewhat larger partition then the available RAM (If your distro is not listed the volatizer installer will check it for compatibility to some degree, so just try it...) Don't risk it on your main system unless you've saved all data... The modification may be risky...
- 1-2 GB swap partition (if you only have 8-16 GB of ram it's a must, especially if you also use integrated graphics(which also uses the RAM). Otherwise it's optional, but if you run out of RAM, your system may freeze, and you may loose data...)
- Do yourself a favor and use SSD for system partition if you can(for faster boot time), but preferably mechanical hard drive for swap(as swap gets written often...)! This combination will give you less then 10 minute boot time(not kidding it may take much monger), while not risking excessive write on SSD...
- Another large partition for large and rarely used files that does not need to be loaded to memory...

Installation:
- Legacy boot mode is recommended! I have had problems installing it properly when it's set to UEFI. (You may need to set that before installing the operating system in the BIOS...)
- Make sure that all human users are created. New users don't have control over volatizer unless you copy the files manually.
- Download and unpack Volatizer, or clone it, whichever you prefer.
- Open terminal, and run the Install.sh with sudo in front. (Running it again will attempt to remove previous installation. That is how you can update it, by downloading or pulling a new version, and running Install.sh twice.)
- Follow the instructions during installation.
- Optional: Edit the configuration file at /home/user/.Volatizer/Config (it's in a hidden directory in your home folder...)
- Reboot into Volatile mode.
- Open terminal, and run the command "volatizer". The rest should be easy... Any volatizer command will display it's help with --help option. (eg: running "volatizer save --help" will dispay the help specifically for save command.)

Good to know:
- On Debian you can't see what you're typing at the prompt when booting, but it works, it's just annoying. You can use "volatizer bootmode" with -n or -v options to switch boot mode instead of the prompt to switch boot mode.
- On Ubuntu 20.04 I added an extra 5 second delay before the prompt, otherwise it's easy to miss it among tons of messages...

Recommendations:
- Try it for learning, experimenting and entertainment! Having a fast reacting system can be very addictive(from my experience):P ...and you don't nesesarily need top specs, mine is a quad core AMD from 2011 with only integrated graphics, and an even older mechanical drive, but it lauches any program in volatile mode in 3-4s at most due to the nearly 15GB/s read/write speed of my DDR3 RAM, which is faster then an NVME drive.(your mileage may vary depending on ram and processor speed and core cout.)
- Don't use it in volatile mode for important work, without backup and autosave!
- Enable backups, and use the volatizer command for autosaving/rebooting/suspending/shutting down your pc instead of the usual buttons...
- Updating installing or removing programs in Volatile mode are temporary changes... Changes done to the system partition outside the user home folder can not be saved easily, and will only persist until shutdown/reboot!

Update plans:
- Automatic background operation of Autosave, and maybe cleanup (v2.0 << Save and backup scripts ware designed to be called by users, not by systemd when users haven't even logged in yet. Other then that it may not be good idea to automate save and backup, as that may save things the user may not wanna save. For now it's gonna be manual, and will think about it and maybe rewrite thigs for v2.0.)
- Clean up the code keep it basic but powerful, with some optional features. (v2.0) Some of this is already done in v1.2 and after.
- Initial step by step setup. (v2.0)
- Logging - Curently none of volatizer files are logging anything... (v2.0)

Version 1.3.1:
- Improved cleanup and snapcleaner scripts, made it faster in case there's nothing to clean, now it no longer asks if you wanna celan up something when there's nothing to clean up.
- Added some log directories to clean up that I missed back in v1.2
- It now cleans logs and journal after uninstalling unused linux images, headers, modules, extras, and old snap versions, so it doesn't produce more logs during cleanup.
- I also forgot to set journald a size limit in v1.3 it's added now.

Version 1.3:
- Added snapcleaner script, which is automatically called by cleanup if snapd is detected, and can get rid of snap cache, and old snap versions, 2 of which is kept by default.
- Added journal vacuuming to cleanup script.
- Silenced some errors caused by not calling df as root when checking mode.

Version 1.2:
- Added bootmode settings which can be used via SSH, thus makes it possible to reboot into another mode remotely.
- Fixed the cleanup script, and made it even better.
- Fixed some bug(s).
- Added repair script which can restore volatizer in case initramfs gets updated, and the modified file overwritten thus the modification lost.
- Devided the Install.sh script for readability, and reusability reasons.
- Made adding new user easy with another new script.
- Re-organized the files...
- Added a disclaimer.

Version 1.1
- Added Debian compatibility.(requested by: pe3no)
- Fixed support for new Ubuntu/Mint versions. (Ubuntu 18.04 was last I used, I recently tried it with Ubuntu 20.04 and didn't work so I fixed it.)
