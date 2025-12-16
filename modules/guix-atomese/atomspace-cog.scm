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
  #:use-module (gnu packages check)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix-atomese cogutil)
  #:use-module (guix-atomese atomspace)
  #:use-module (guix-atomese atomspace-storage)
  #:use-module (guix-atomese cogserver))

(define-public atomspace-cog
  (let ((commit "3f04bbe25f380346e37c778f82ef466a164c5444")
        (revision "2"))
    (package
      (name "atomspace-cog")
      ; XXX FIXME Hardcoded version number; should be $PACKAGE_VERSION
      (version (git-version "1.2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/atomspace-cog")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "18aj6jjaz0aj76khbf5dd81sgc28p87sr9b3dg97zmnfr6a096qa"))))
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
       (list atomspace atomspace-storage cmake cogserver cogutil cxxtest gcc-toolchain guile-3.0 pkg-config python python-pytest))
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
