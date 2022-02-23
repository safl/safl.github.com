Mail
----

Awesome sauce.

Mail, the asynchronous communication channel which uses a bunch of different
technologies under-the-hood.

mail-user-agent (MUA), the 

You might be used to just starting one monolithic application such as Outlook
or Thunderbird to read your mail. However, for a text-based approach including
tools such as neomutt, then things a quite different, and a Wizard won't pop up
for you to fill out.

For instance before even diving into NeoMutt, then you probably want to setup a
way to encrypt/decrypt secrets. Yeah, everything is bare-bones, you are not
relying on Thunderbird/Outlook to store your passwords safely, no no, you
define how your "secrets" are kept.

* gnupg, in your various configuration-files then passwords a needed unless you
  want to type in your username/password everything you send/receive email, it
  is super bad practice to just stuff those as plain-text in your configs, so
  to avoid that then something like gnupg can be used to store them encrypted
  and decrypt the passwords when needed

* pass

* abook, an address-book, such that you can get some auto-completion when
  writing mails to people, e.g. helps you to fill out the ``to:`` portion when
  writing an email.

* mbsync, 

* notmuch, virtual inbox and mail-filtering

Password Management using gnupg + pass
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fancy tools/services such as 1password, LastPass, and more free alternatives
include KeepX. For what we do here the goal is simple:

* Avoid clear-text passwords in configuration-files

A bonus feature is that, when using a password-manager then it becomes much
easier to change passwords, as you would just change it in the manager and not
in every configuration file using it.

For this task the approach is using GnuPG and pass.

Arch Linux has some great documentation on :xref-gnupg:`GnuPG<>`

Install::

  sudo apt-get install gnupg pass

.. note:: The default location for your GnuPG stuff is in ``~/.gnupg``.

Create a key-pair::

  gpg --full-gen-key

You could just use ``gpg --decrypt``/``gpg --encrypt``, however, the ``pass``
tool is really convenient. Set it up it like this::

  pass init $USER

This should create your password store in ``~/.password-store``, and it should
be initialized with your gpg-id. You can then store passwords for your
mail-accounts, something like::

  # Add your passwod for your private email
  pass insert Email/private

  # Add your passwod for your business email
  pass insert Email/business

Try and see if you can also retrieve them::

  pass show Email/private
  pass show Email/business

You can then use ``pass show Email/private`` in your configuration files
instead of the password itself. This is convenient when you rotate your
password, then you do not need to go an edit all your configuration-files, you
just update the password manager. Also, you  avoid storing the password in
clear-text inside all those configuration files.

Retrieve Email using ``mbsync``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For reference, here are alternatives tools/setup: offlineimap, getmail or
configure :xref-neomutt:`NeoMutt<>` to connect to your imap mail-servers. What
I use here is setting up ``mbsync`` for accounts on different servers, that is,
my personal GMail and the Exchange server for work.

Install::

  sudo apt-get install isync

Create mail-directories for personal and work email::

  mkdir -p ~/mail/{personal,work}

Now, configure ``mbsync`` to retrieve/sync your personal and work email in the
sub-directories of ``~/mail``::

  # Open the mbsync configuration file
  editor ~/.mbsyncrc

Fill it with something similar to below, where the personal mail is on GMail
and the workmail is on an Exchange Server::

  IMAPAccount personal
  Host imap.gmail.com
  SSLType IMAPS
  User <FILL_IN_YOUR_EMAIL_ADDRESS_HERE>
  PassCmd "pass show Email/personal.imap"
  Pipelinedepth 1

  IMAPStore personal-remote
  Account personal

  MaildirStore personal-local
  SubFolders Verbatim
  Path ~/mail/personal/
  Inbox ~/mail/personal/Inbox

  Channel personal
  Far :personal-remote:
  Near :personal-local:
  Patterns *
  SyncState *

Synchornize all accounts / channels::

  mbsync -a

Synchronize a single account / channel::

  mbsync personal

Address Book using ``abook``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

...

notmuch
~~~~~~~

...

neomutt
~~~~~~~


Setup NeoMutt configuration::

  mkdir ~/.config/neomutt

Edit the NeoMutt configuration ``vim ~/.config/neomutt/neomuttrc``::

  foo

