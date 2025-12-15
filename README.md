# guix-atomese

A Guix channel providing packages for the OpenCog Atomese ecosystem.

(Experimental. This is brand new, as of December 2025. We'll have to
see how things go.)

There are two reasons to try guix:
* As a replacement for docker, allowing OpenCog Atomese to be deployed
  inn a localized container;
* As a way of getting OpenCog packages installed on arbitrary distros.
  since OpenCog is not packaged in either Debian or Fedora, never mind
  any smaller distros.

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

## Adding This Channel

Add this channel to your `~/.config/guix/channels.scm`:

```scheme
(cons* (channel
        (name 'atomese)
        (url "https://github.com/opencog/guix-atomese")
        (branch "master"))
       %default-channels)
```

Then update Guix:

```bash
guix pull
```

## Running in a container
```
guix shell --container cogutil
```


## Installing Packages

After adding the channel, install packages with:

```bash
# Install individual packages
guix install cogutil
guix install atomspace

# Or use a manifest
guix package -m manifests/base.scm
```

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
