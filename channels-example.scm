;; Guix channel definition for guix-atomese
;;
;; To use this channel, add the following to ~/.config/guix/channels.scm:
;;
;; (cons* (channel
;;         (name 'atomese)
;;         (url "https://github.com/opencog/guix-atomese")
;;         (branch "master"))
;;        %default-channels)

(list (channel
        (name 'atomese)
        (url "https://github.com/opencog/guix-atomese")
        (branch "master")))
