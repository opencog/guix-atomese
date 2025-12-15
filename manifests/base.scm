;; Base manifest for AtomSpace development
;; Usage: guix shell -m manifests/base.scm

(use-modules (guix profiles))

(specifications->manifest
  '("cogutil"
    "atomspace"))
