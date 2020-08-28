<p align="center"><b>
  <br />
  &gt;&gt;&gt; Check out <a href="https://patz.gitbook.io/aura/">AURA gitbook</a> &lt;&lt;&lt;
  <br /><br />
</b></p>
 

## “AUR packages - _Anywhere._”


**CROSS-PLATFORM** [Arch User Repository](https://aur.archlinux.org) Assistant written in Ruby.

<p align="center">
<img src="https://raw.githubusercontent.com/patztablook22/meta/master/aura/demo.gif" />
</p>

This tool aims to provide simple yet powerful functionality. \
It will assist you when installing packages from the AUR. \
It does cloning for you, can parse PKGBUILD, and even try to execute it in a given environment, yielding feedback on what to target manually.

## Installation
```
curl -s https://raw.githubusercontent.com/patztablook22/aura/master/install.sh | bash
```

## TL;DR Examples
```bash

# install opera-beta
# automatically checking for local files
# and using them instead of downloading

aura opera-beta

# install discord after downloading a corrupt file
# e.g. due to SIGINT

aura --redo discord

# install kewl and keep it in the fakeroot
# to check the files it will create
# also skip "glibc" dependency
# and show what exactly is happening

aura --keep --skip glibc --verbose kewl

```

## Usage
```bash

# print help
aura --help

# request a package from the AUR if necessary and try to build it
aura package

# request a package from the AUR and try to (re)build it
aura package --redo

# keep the package in the fakeroot dir for testing / review
aura package --keep

# skip checking dependency "dep" and "another"
aura package --skip dep,another

# verbose mode
aura package --verbose

# use custom config file
aura package --conf myaura.conf

# use custom fakeroot directory
aura package --root my/fake/root

```

## Config
Default config location: `GIT/config.txt` \
That is, for the installer `~/.config/aura/config.txt` \
It's being interpreted using the same internal PKGBUILD parser \
hence the syntax, for example:

```PKGBUILD

aurs = /my/aur/repositories
pkgs = /my/packages
root = /my/root
redo = false

# not yet implemented
errs = /my/aura/error/file.txt

```

## Manual installation

**Dependencies**
  - git
  - ruby
  - tar
  - binutils
  - xz
  
**Steps**
  1. dependencies
  2. clone the repository into `~/.config/`
  3. execute `GIT/aura`
  4. you can link it into `/usr/bin/`

# Development notes

The complexity of packages this tool can handle shall increase.
