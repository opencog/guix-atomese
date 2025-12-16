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

(define-module (guix-atomese atomspace)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix-atomese cogutil))

(define-public atomspace
  (let ((commit "065b613373490b0cce440687bfe0398ae83ec18e")
        (revision "5"))
    (package
      (name "atomspace")
      ; XXX FIXME Hardcoded version number; should be $PACKAGE_VERSION
      (version (git-version "5.2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/atomspace")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0yql8a210fh11l039r8hbnq4b76232ycplw0mls1vaf39kwgq2zd"))))
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
       (list cmake cogutil cxxtest gcc-toolchain guile-3.0 pkg-config python-pytest))
      (inputs
       (list cogutil
             gmp
             guile-3.0
             python
             python-cython
             sparsehash))
      (propagated-inputs
       (list guile-3.0 guile-readline python))
      (synopsis "OpenCog AtomSpace hypergraph database")
      (description
       "The OpenCog AtomSpace is an in-RAM knowledge representation (KR)
database with an associated query engine and graph-rewriting system.
It is a kind of in-RAM generalized hypergraph (metagraph) database.
Metagraphs offer more efficient, more flexible and more powerful ways
of representing graphs.  The AtomSpace is a platform for building
Artificial General Intelligence (AGI) systems.")
      (home-page "https://github.com/opencog/atomspace")
      (license license:agpl3+))))
