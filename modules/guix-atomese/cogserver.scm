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

(define-module (guix-atomese cogserver)
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
  #:use-module (gnu packages networking)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tls)
  #:use-module (guix-atomese cogutil)
  #:use-module (guix-atomese atomspace)
  #:use-module (guix-atomese atomspace-storage))

(define-public cogserver
  (let ((commit "4344d65061b6e75ff00d6393a6678efd1328cccc")
        (revision "1"))
    (package
      (name "cogserver")
      ; XXX FIXME Hardcoded version number; should be $PACKAGE_VERSION
      (version (git-version "3.4.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/cogserver")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0bvlbf36diisavhlq60mc6lcgw4s6gwwy6ks16457ax8fs9zrf1z"))))
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
       (list atomspace atomspace-storage cmake cogutil gcc-toolchain guile-3.0 pkg-config))
      (inputs
       (list asio
             atomspace
             atomspace-storage
             cogutil
             gmp
             guile-3.0
             openssl
             python
             python-cython))
      (propagated-inputs
       (list guile-3.0 guile-readline python))
      (synopsis "OpenCog CogServer for network-accessible AtomSpace")
      (description
       "The CogServer provides a network server for the AtomSpace, allowing
remote access to the hypergraph database over TCP/IP.  It supports multiple
shell types including a Scheme shell for Guile interaction, a JSON shell for
web applications, and an MCP (Model Context Protocol) shell.  The CogServer
enables distributed AtomSpace deployments and network-based AI applications.")
      (home-page "https://github.com/opencog/cogserver")
      (license license:agpl3+))))
