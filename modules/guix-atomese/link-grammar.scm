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

(define-module (guix-atomese link-grammar)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages aspell)
  #:use-module (gnu packages libedit)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages python)
  #:use-module (gnu packages swig)
  #:use-module (guix-atomese cogutil)
  #:use-module (guix-atomese atomspace)
  #:use-module (guix-atomese atomspace-storage)
  #:use-module (guix-atomese atomspace-rocks)
  #:use-module (guix-atomese atomspace-cog))

(define-public link-grammar
  (let ((commit "c6ff88dd4035a421dd315121a4ceabcec30b4536")
        (revision "1"))
    (package
      (name "link-grammar")
      ; XXX FIXME Hardcoded version number; should be from configure.ac
      (version (git-version "5.13.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/opencog/link-grammar")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0a51zmrg15wd6s4vw98z141zscnpl7fvm6fm084mfklv7g059yn5"))))
      (build-system gnu-build-system)
      (arguments
       (list
        #:configure-flags
        #~(list "--enable-python-bindings"
                "--disable-hunspell"
                "--enable-aspell")
        ;; Skip tests for now
        #:tests? #f))
      (native-inputs
       (list autoconf
             automake
             libtool
             flex
             pkg-config
             swig
             atomspace
             atomspace-storage
             atomspace-rocks
             atomspace-cog
             cogutil))
      (inputs
       (list atomspace
             atomspace-storage
             atomspace-rocks
             atomspace-cog
             cogutil
             aspell
             libedit
             pcre2
             python))
      (propagated-inputs
       (list python))
      (synopsis "Link Grammar natural language parser")
      (description
       "The Link Grammar Parser is a syntactic parser of English, Russian,
German, and other languages.  It is based on Link Grammar, an original
theory of syntax and morphology.  Given a sentence, the system assigns
to it a syntactic structure, which consists of a set of labeled links
connecting pairs of words.  The parser also produces a constituent
representation of a sentence (showing noun phrases, verb phrases, etc.).")
      (home-page "https://opencog.github.io/link-grammar-website/")
      (license license:lgpl2.1+))))
