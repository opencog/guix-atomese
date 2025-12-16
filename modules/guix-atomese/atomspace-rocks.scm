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

(define-module (guix-atomese atomspace-rocks)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix-atomese cogutil)
  #:use-module (guix-atomese atomspace)
  #:use-module (guix-atomese atomspace-storage))

(define-public atomspace-rocks
  (let ((commit "a4c47fc7d31eb77e7fe1e53d30a3a9fa60cee47a")
        (revision "3"))
    (package
      (name "atomspace-rocks")
      ; XXX FIXME Hardcoded version number; should be $PACKAGE_VERSION
      (version (git-version "1.6.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/atomspace-rocks")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1iza7ki00y3966h3hiw49767xd8gzrqhk96v3hr6zlbpvs6bylii"))))
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
        #:phases
        #~(modify-phases %standard-phases
            (replace 'check
              (lambda _ (invoke "make" "check"))))))
      (native-inputs
       (list atomspace atomspace-storage cmake cogutil cxxtest gcc-toolchain guile-3.0 pkg-config python python-pytest))
      (inputs
       (list atomspace
             atomspace-storage
             cogutil
             gmp
             guile-3.0
             python
             python-cython
             rocksdb))
      (propagated-inputs
       (list guile-3.0 guile-readline python))
      (synopsis "RocksDB-based persistent storage for AtomSpace")
      (description
       "The AtomSpace RocksDB module provides the RocksStorageNode, enabling
persistent storage of Atoms and AtomSpaces to disk using RocksDB.  This allows
AtomSpace contents to survive restarts and provides high-performance key-value
storage for the hypergraph database.")
      (home-page "https://github.com/opencog/atomspace-rocks")
      (license license:agpl3+))))
