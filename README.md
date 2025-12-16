# guix-atomese

A Guix channel providing packages for the OpenCog Atomese ecosystem.

There are three reasons to try guix:
* To provide a local shell that has all Atomese components installed,
  so that new users can just "use it" without getting tangled up with
  install issues;
* As a replacement for docker, allowing OpenCog Atomese to be deployed
  in a localized container;
* As a way of getting OpenCog packages installed on arbitrary distros.
  OpenCog is not packaged in either Debian or Fedora, never mind any
  smaller distros.

These three different ways of automating the use of OpenCog are loosely
documented below.

(Experimental. This is brand new, as of December 2025. We'll have to
see how things go.)

## Overview
There are several steps:
* Install guix.
* Configure the Atomese channel.
* Guix pull
* Build the Atomese packages.
* A choice of:
  -- Using Atomese in a local shell.
  -- Installing all packages into the base OS filesystem.
  -- Running a container with all of the OpenCog Atomese components in it.

These steps are documented below.

### Install Guix
The official installer works fine:
```
  cd /tmp
  wget https://guix.gnu.org/install.sh
  chmod +x install.sh
  sudo ./install.sh
```
Be sure to say `yes` to the question about `~/.bashrc` or `~/.profile`
as otherwise, you'll end up doing it manually, anyway. Its basically
just this:

```
  source ~/.guix-profile/etc/profile
```

### Adding This Channel

Add this channel to your `~/.config/guix/channels.scm`:

```scheme
(cons* (channel
        (name 'atomese)
        (url "https://github.com/opencog/guix-atomese")
        (branch "master"))
       %default-channels)
```

### Guix pull
The `guix pull` command syncs up with the latest guix packages. It is
similar to `apt get upgrade` or `yum upgrade`. It will tak an hour if
this is the first time that you run it; it will be faster on subsequent
tries. But still slow -- maybe 3 to 10 minutes, because it tries to
recompute a lot of hashes each go-around. So don't do this unless you
have to.

```bash
guix pull
```
### Build the Atomese packages
Build the various Atomese packages:
```
guix build cogutil
guix build atomspace
guix build atomspace-storage
```

### Running a shell
To use OpenCog on a temporary basis, within an isolated shell, just
say `guix shell atomspace` -- they will give you a shell with guile,
python3 and the AtomSpace in it. So, for example:

```
guix shell atomspace-storage
$ guile
> (use-modules (opencog))
> (Concept "foo")
> ^D
$ python3
>>> from opencog.atomspace import *
>>> Concept("bar")
^D
```
The above shell has opencog, but is missing development tools such as
`cmake`. To get those, try this:
```
guix shell --development
```

### Running in a container
Not yet. Still borken.
```
guix shell --container cogutil
```

### Installing Packages
I have not tried this yet.

Install packages with:

```bash
# Install individual packages
guix install cogutil
guix install atomspace
```
Or use a manifest (The menifest is currently broken.)
```
guix package -m manifests/base.scm
```
Several pre-defined manifests are available (or planned):

- `manifests/base.scm` - cogutil + atomspace only
- `manifests/storage.scm` - adds disk and network storage
- `manifests/sensory.scm` - adds sensori-motor interfaces

Use a manifest to create a development environment:


## Repo Overview

This repository defines Guix packages for:
- cogutil - OpenCog base utilities
- atomspace - AtomSpace hypergraph database
- atomspace-storage - generic StorageNode and ProxyNode interfaces
- atomspace-rocks - RocksStorageNode for RocksDB disk AtomSpaces
- atomspace-cog - CogStorageNode for network-distributed AtomSpaces
- cogserver - CogServerNode network server
- link-grammar - Link Grammar parser
- lg-atomese - Atomese bindings for Link Grammar
- sensory - (Experimental) Sensorimotor interfaces
- Maybe more, if/when things settle down ...

## Maintenance Workflow
Notes for maintainers. Assumes you have this git repo cloned.

### Updating a Package
For each project:
```
cd /tmp
git clone --depth 1 https://github.com/opencog/whatever /tmp/whatever
guix hash -rx /tmp/whatever
```
THE DIRECTORY MUST BE CLEAN! `guix hash -rx .` hashes everything,
including random junk files, the build dir, and everything else.

Next, edit `guix-atomese/packages/whatever.scm`
update the sha256 hash with above,
and the commit with the git commit ID.

### Building
To build packages:
```bash
cd /path/to/guix-atomese
guix build -L . -e '(@ (guix-atomese packages cogutil) cogutil)'
guix build -L . -e '(@ (guix-atomese packages atomspace) atomspace)'
```

Force unconditional rebuild by saying:
```
guix build --no-grafts --check -L modules  -e '(@ (guix-atomese cogutil) cogutil)'
```

## License

AGPL-3.0 with OpenCog linking exception. See LICENSE file.
