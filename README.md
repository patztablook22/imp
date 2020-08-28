# <!--S-->imp!
Linux **cross-distro** Intelligent Package Manager. \
Access multiple repositories _(further development needed)_ using simple interface.

## Automatic installation

```bash
curl -s https://patztablook22.github.io/imp/install.sh | bash
```

## Guide
```bash
# print help
imp --help

# install package
imp package

# search for package
imp --find package
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
  3. execute `GIT/imp`
  4. you can link it into `/usr/bin/` or other `$PATH`
