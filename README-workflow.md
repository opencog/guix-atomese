
Workflow
--------

For each project:
```
cd /wherever
git pull
guix hash -rx .
```
then edit `guix-atomese/packages/whatever.scm`
update the sha256 hash with above,
and the commit with the git commit ID.
