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
```

### Running a shell


```
guix shell atomspace
guile
(use-modules (opencog))

```

```
guix shell --development
```
### Running in a container
```
guix shell --container cogutil
```


### Installing Packages

After adding the channel, install packages with:

```bash
# Install individual packages
guix install cogutil
guix install atomspace

# Or use a manifest
guix package -m manifests/base.scm
```

## Overview

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

## Using Manifests

Several pre-defined manifests are available (or planned):

- `manifests/base.scm` - cogutil + atomspace only
- `manifests/storage.scm` - adds disk and network storage
- `manifests/sensory.scm` - adds sensori-motor interfaces

Use a manifest to create a development environment:

```bash
guix shell -m manifests/base.scm
```

## Building from Local Checkout

To build packages from a local checkout of this repository:

```bash
cd /path/to/guix-atomese
guix build -L . -e '(@ (guix-atomese packages cogutil) cogutil)'
guix build -L . -e '(@ (guix-atomese packages atomspace) atomspace)'
```

## License

AGPL-3.0 with OpenCog linking exception. See LICENSE file.
