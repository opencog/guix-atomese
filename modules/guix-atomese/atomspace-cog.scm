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

(define-module (guix-atomese atomspace-cog)
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
  #:use-module (guix-atomese atomspace)
  #:use-module (guix-atomese atomspace-storage)
  #:use-module (guix-atomese cogserver))

(define-public atomspace-cog
  (let ((commit "d566347c5fa95344d9598944be0f73dd226178e6")
        (revision "1"))
    (package
      (name "atomspace-cog")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/atomspace-cog")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0iidxj2j673fiqvj8qmrh30gqs5azz5ndxf5l8likvp6d5l49lzr"))))
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
                               #$(this-package-input "cogutil")
                               "/share/opencog/cmake"))
        ;; Skip tests for now; they require cxxtest
        #:tests? #f))
      (native-inputs
       (list cmake gcc-toolchain guile-3.0 pkg-config))
      (inputs
       (list atomspace
             atomspace-storage
             cogserver
             cogutil
             gmp
             guile-3.0
             python
             python-cython))
      (propagated-inputs
       (list guile-3.0 guile-readline python))
      (synopsis "CogStorageNode for network-distributed AtomSpaces")
      (description
       "The AtomSpace-Cog module provides the CogStorageNode, enabling movement
of Atoms between AtomSpaces on different network nodes via the CogServer.
This allows distributed AtomSpace deployments where multiple processes or
machines can share and synchronize hypergraph data over a network.")
      (home-page "https://github.com/opencog/atomspace-cog")
      (license license:agpl3+))))
