;; Base manifest for AtomSpace development
;; Usage: guix shell -m manifests/base.scm

(specifications->manifest
  '("cogutil"
    "atomspace"))
