;;; GNU Guix --- Functional package management for GNU
;;; Copyright (C) 2024-2025 OpenCog Foundation
;;;
;;; This file is part of guix-atomese.
;;;
;;; guix-atomese is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU Affero General Public License as
;;; published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; guix-atomese is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU Affero General Public License for more details.
;;;
;;; You should have received a copy of the GNU Affero General Public
;;; License along with guix-atomese.  If not, see
;;; <https://www.gnu.org/licenses/>.

(define-module (guix-atomese atomspace-storage)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix-atomese cogutil)
  #:use-module (guix-atomese atomspace))

(define-public atomspace-storage
  (let ((commit "88ce8844cc4cad66b7bdb6686c2c8700784aee4b")
        (revision "4"))
    (package
      (name "atomspace-storage")
      ; XXX FIXME Hardcoded version number; should be $PACKAGE_VERSION
      (version (git-version "4.3.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/atomspace-storage")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0h1r2mv7x2awwk8l71vs99b1793440h9pk5x19gq9dn3v8f6zn7w"))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:configure-flags
        #~(list "-DCMAKE_BUILD_TYPE=Release"
                (string-append "-DGUILE_SITE_DIR=" #$output
                               "/share/guile/site/3.0")
                (string-append "-DGUILE_CCACHE_DIR=" #$output
                               "/lib/guile/3.0/site-ccache")
                (string-append "-DPYTHON_INSTALL_PREFIX=" #$output
                               "/lib/python"
                               #$(version-major+minor (package-version python))
                               "/site-packages"))
        ;; Skip tests for now; they require cxxtest
        #:tests? #f))
      (native-inputs
       (list atomspace cmake cogutil gcc-toolchain guile-3.0 pkg-config))
      (inputs
       (list atomspace
             cogutil
             gmp
             guile-3.0
             python
             python-cython))
      (propagated-inputs
       (list guile-3.0 guile-readline python))
      (synopsis "AtomSpace StorageNode API for persistence backends")
      (description
       "The AtomSpace Storage module provides the StorageNode base class for
various forms of I/O storage and movement of Atoms into, out of and between
AtomSpaces.  It is the foundation for RocksStorageNode (disk storage via
RocksDB), CogStorageNode (network distribution), and ProxyNodes (mirroring,
routing, caching and filtering).  Also includes CSV/TSV file loading, JSON
encoding/decoding, s-expression I/O, and Prolog/MeTTa import/export.")
      (home-page "https://github.com/opencog/atomspace-storage")
      (license license:agpl3+))))
