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

(define-module (guix-atomese lg-atomese)
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
  #:use-module (guix-atomese link-grammar))

(define-public lg-atomese
  (let ((commit "17563d64a31d2e7bfb92eaf8c878c1ba6410f91d")
        (revision "1"))
    (package
      (name "lg-atomese")
      ; XXX FIXME Hardcoded version number; should be $PACKAGE_VERSION
      (version (git-version "0.1.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/lg-atomese")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0p2ggn6129ry4kqp44c3ldd2dncj51mbm61g8vynb3p1v9j5nilp"))))
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
                               "/site-packages"))))
      (native-inputs
       (list atomspace atomspace-storage cmake cogutil gcc-toolchain
             guile-3.0 link-grammar pkg-config))
      (inputs
       (list atomspace
             atomspace-storage
             cogutil
             gmp
             guile-3.0
             link-grammar
             python
             python-cython))
      (propagated-inputs
       (list guile-3.0 guile-readline python))
      (synopsis "Link Grammar to Atomese converter")
      (description
       "LG-Atomese provides tools for converting Link Grammar parse results
into Atomese format for use in OpenCog's natural language processing pipeline.
It bridges the Link Grammar parser with the AtomSpace knowledge representation
system, enabling linguistic analysis within the OpenCog framework.")
      (home-page "https://github.com/opencog/lg-atomese")
      (license license:agpl3+))))
