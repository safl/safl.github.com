Windows
=======

I got a Windows 95 installation CD with my first PC. I installed it, played
around, played Pinball, Hearts, Moto Racer, and QUAKE. Then I installed Borland
Delphi, then Apache + PHP. Then I started getting annoyed with Windows and
switched to FreeBSD and later Linux.

Haven't used Windows for my personal computer since, except of course... to
play games that would not run on Wine. However, I have needed Windows in a
bunch of scenarious, but usually running it via VM would suffice. So, can't
really shake Windows. Thus, i decided to note down a couple of nice things
which are actually possible today which makes not too terrible to use.

Here are a couple of notes on setting up a Windows machine in such a manner
that it is bearable to use. First steps involve waiting for updates to finish,
give the system a proper name, then enable remote access via RDP and SSH.

Then the tool-installation can commence, starting with the Chocolatey package
manager and msys2. Later, the other stuff such as the Microsoft Visual Studio.

Chocolatey
----------

A package manager for Windows providing native software installation. How
**sweet**. Install it via an elevated PowerShell::

  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Tools
-----

Here are a couple of the usual suspects on Windows::

  choco.exe install git vscode firefox

It is so nice, that one does not need to go visit a bunch of websites and
download ``.msi`` and random ``.exe`` installation Wizards. It is all
downloaded from the same arbitrary places, they are to the greatest extended
untrusted and untested, however, Chocolatey does a an effort to scan, verify,
etc. the packages that they ship as "community" packages, as well as those with
regular maintenance. Excellent!

After installing the tools above, then bash is also avaiable via the
git-installation, you can find it somewhere equivalent to::

  c:\Program Files\Git\bin\bash.exe

This is incredibly nice, as you can tell the OpenSSH server to use Bash as your
login shell. Ahh, serenity.

Rename your PC
--------------

...

Remote Desktop
--------------

...

Enable OpenSSH Server
---------------------

Something wonderful has happened; Windows has native OpenSSH support and it is
officially documented here:

 * https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview

**Notes:**

Check whether it is installed::

  Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

Then install it::

  # Install the OpenSSH Client
  Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

  # Install the OpenSSH Server
  Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Then continue::

  # Start the sshd service
  Start-Service sshd

  # OPTIONAL but recommended:
  Set-Service -Name sshd -StartupType 'Automatic'

  # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
  if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
      Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
      New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
  } else {
      Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
  }

  # Add your authorized_keys file and set permissions
  # Copy it to: C:\ProgramData\ssh\administrators_authorized_keys, then 
  icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"

And here is the winner, set ``Bash`` as your default Shell::

  New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "c:\Program Files\Git\bin\bash.exe" -PropertyType String -Force
