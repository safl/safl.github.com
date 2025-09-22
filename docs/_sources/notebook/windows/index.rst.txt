Windows
=======

I got a Windows 95 installation CD with my first PC. I installed it and played
around with Pinball, Hearts, Moto Racer, and QUAKE. Then I installed Borland
Delphi, followed by Apache and PHP. Eventually, I started getting annoyed with
Windows and switched to FreeBSD, and later to Linux. I have not used Windows for
my personal computer since then, except of course to play games that would not
run on Wine.

However, I have needed Windows in a number of scenarios, but usually running it
via a virtual machine would suffice. So I cannot really shake Windows. That is
why I decided to note down a couple of nice things that are actually possible
today, which make it not too terrible to use.

Here are a few notes on setting up a Windows machine in a way that makes it
bearable to use. The first steps involve waiting for updates to finish, giving
the system a proper name, and enabling remote access via RDP and SSH. Then the
tool installation can begin, starting with the Chocolatey package manager and
MSYS2. Later comes the other software, such as Microsoft Visual Studio.

Recent Developments
-------------------

The above was state of things, for me atleast, until i in 2025 stumbled upon
Windows 11 with WSL2. Wow, the landscape has changed! I had always found that
Windows was more a nuisance, However, today, some 25 years later, Windows now
have some fundamentals done right, and baked in:

* Software is easy to install via ``winget``

  - Finally MS provides what FreeBSD and Linux had for ages, package management
    with a decent cli interface. Stuff, like **Chocolatey** and **Scoop** are not
    really needed anymore. ``winget`` + **WSL2** checks all the boxes for me.

* A functional Terminal emulator

  - Although the Window "shells" ``cmd.exe`` and ``PowerShell`` remain
    absolutely useless as a daily-driver, then atleast, there is now a decent
    **Terminal** built-in and aptly named.

* Windows System for Linux

  - It is well known that **MS** cannot create a useful shell. However, what
    they have managed to do **very** well, is integrate Linux and Windows.
    Tightly integrating access to file-system and HW ressources even with
    nested virtualization. E.g. one can do qemu-development with ease. Thus, you
    get your favorite shell and the entire Linux userland, plus the option to
    customize the kernel. Boom. Mike drop.

* Window-manager

  - Although not a neat tiling window-manager such as sway, but not entirely
    useless like macOS. Then Windows now provides a bit of throwing windows
    around, jumping between virtual desktops, and snapping windows to grids.
  - Also, with WSL + ZelliJ, then most of the 

* Game Streaming

  - Although not a Windows-feat, however, still related is the usability of
    game-streaming service, especially GeforceNow. No need to install, and keep
    a library of games updated, just sign in and play.

Thus, piloting Windows with these fundamentals in place makes it a far bit
more than bearable. It is actually a quite nice merge of proprietary and open
systems. You can utilize Windows for all the proprietary HW stuff that usually
always break on Linux, and leave all the toolchain essentials to the Linux.

Thus, the following are notes on setting up Windows 11 in ways I have found useful.


Windows Native Software
-----------------------

Run the following in a Powershell::

  winget install `
    AutoHotkey.AutoHotkey `
    Cisco.Webex `
    Citrix.Workspace `
    DEVCOM.JetBrainsMonoNerdFont `
    Discord.Discord `
    Google.Chrome `
    Microsoft.Office `
    Microsoft.PowerToys `
    Mozilla.Firefox `
    SlackTechnologies.Slack `
    SublimeHQ.SublimeText.4 `
    WireGuard.WireGuard

Attaching **USB** devices to in **WSL** instances::

	winget install `
	  dorssel.usbipd-win

And for a bit of entertainment::

  winget install `
    Nvidia.GeForceNow `
    Spotify.Spotify

AutoHotKey
----------

I am missing several things from **Sway** the most important one is
``Alt+ArrowKey``` for window navigation. With AutoHotKey, one can make a script
that does that. Along the lines of::

  #Requires AutoHotkey v2.0

  AltFocus(direction) {
      hwndCurrent := WinActive("A")
      if !hwndCurrent
          return

      WinGetPos(&curX, &curY, &curW, &curH, hwndCurrent)
      curCenterX := curX + curW // 2
      curCenterY := curY + curH // 2

      winList := []

      for hwnd in WinGetList() {
          if hwnd = hwndCurrent || !WinExist(hwnd)
              continue

          WinGetPos(&x, &y, &w, &h, hwnd)
          centerX := x + w // 2
          centerY := y + h // 2

          dx := centerX - curCenterX
          dy := centerY - curCenterY

          if (direction = "Left" && dx < 0 && Abs(dy) < h) {
              winList.Push({hwnd: hwnd, dist: Abs(dx)})
          } else if (direction = "Right" && dx > 0 && Abs(dy) < h) {
              winList.Push({hwnd: hwnd, dist: dx})
          } else if (direction = "Up" && dy < 0 && Abs(dx) < w) {
              winList.Push({hwnd: hwnd, dist: Abs(dy)})
          } else if (direction = "Down" && dy > 0 && Abs(dx) < w) {
              winList.Push({hwnd: hwnd, dist: dy})
          }
      }

      if winList.Length = 0
          return

      ; Manual sort by distance
      for i, _ in winList {
          j := i + 1
          while j <= winList.Length {
              if winList[j].dist < winList[i].dist {
                  temp := winList[i]
                  winList[i] := winList[j]
                  winList[j] := temp
              }
              j++
          }
      }

      WinActivate(winList[1].hwnd)
  }

  !Left::AltFocus("Left")
  !Right::AltFocus("Right")
  !Up::AltFocus("Up")
  !Down::AltFocus("Down")

Note, the script above was made with the assistance of the default provided
CoPilot in Windows 11.

WSL2
----

Install Windows Subsystem for Linux 2 and a Fedora distro::

	wsl --install
	wsl --status
	wsl --set-default-version 2
	wsl --list --online
	wsl --install -d Fedora
	wsl --set-default Fedora

Rename your PC
--------------

...


