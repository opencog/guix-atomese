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
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix-atomese cogutil)
  #:use-module (guix-atomese atomspace)
  #:use-module (guix-atomese atomspace-storage))

(define-public atomspace-rocks
  (let ((commit "4b85338ea0f89a20cceb215dfa308ff66e589e0b")
        (revision "1"))
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
          (base32 "0952jh57wm8i04dxz5jn36zlr3yn63rngf12kij8y5cznfc3z1fp"))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:configure-flags
        #~(list "-DCMAKE_BUILD_TYPE=Release"
                (string-append "-DGUILE_SITE_DIR=" #$output
                               "/share/guile/site/3.0")
                (string-append "-DPYTHON_INSTALL_PREFIX=" #$output
                               "/lib/python"
                               #$(version-major+minor (package-version python))
                               "/site-packages")
                (string-append "-DCMAKE_MODULE_PATH="
                               #$cogutil "/share/opencog/cmake"))
        ;; Skip tests for now; they require cxxtest
        #:tests? #f))
      (native-inputs
       (list cmake gcc-toolchain guile-3.0 pkg-config))
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
