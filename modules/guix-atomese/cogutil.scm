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

(define-module (guix-atomese cogutil)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages check)
  #:use-module (gnu packages base))

(define-public cogutil
        ; commit is the git commit ID
  (let ((commit "fb05081240d797600e365a795455dc902c6b9886")
        (revision "7"))
    (package
      (name "cogutil")
      ; XXX FIXME Hardcoded version number; should be $PACKAGE_VERSION
      (version (git-version "2.2.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/cogutil")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1k266g6rjidnknqz48s8pd9zp4i3jkj2p52b0lflijj5ll56dr0i"))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:configure-flags #~(list "-DCMAKE_BUILD_TYPE=Release"
                                  "-DSKIP_LDCONF=ON")))
      (native-inputs
       (list cmake cxxtest pkg-config python-pytest gcc-toolchain))
      (inputs
       (list binutils    ; BFD library for pretty stack traces
             libiberty)) ; GCC libiberty for stack traces
      (synopsis "OpenCog basic C++ utilities")
      (description
       "The OpenCog cogutil package provides a miscellaneous collection of C++
utilities used for typical programming tasks in multiple OpenCog projects.
These include thread-safe queues, stacks and sets; an asynchronous method
caller; a thread-safe resource pool; thread-safe backtrace printing;
high-performance signal-slot; random tournament selection; and OS portability
layers.")
      (home-page "https://github.com/opencog/cogutil")
      (license license:agpl3+))))
