
Workflow
--------

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

Force unconditional rebuild by saying:
```
guix build --no-grafts --check -L modules  -e '(@ (guix-atomese cogutil) cogutil)'
```
