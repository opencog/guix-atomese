;; Guix channel definition for guix-atomese
;;
;; Copy this file to ~/.config/guix/channels.scm
;; or merge with your existing channels.scm

(cons* (channel
        (name 'atomese)
        (url "https://github.com/opencog/guix-atomese")
        (branch "master"))
       %default-channels)
