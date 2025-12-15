;; Guix system container for AtomSpace development
;;
;; Build with:
;;   guix system container -L /path/to/guix-atomese systems/atomese-container.scm
;;
;; This returns a script path. Run it to start the container.

(use-modules (gnu)
             (gnu services networking)
             (guix-atomese packages cogutil)
             (guix-atomese packages atomspace))

(use-service-modules networking ssh)
(use-package-modules bash coreutils guile
                     less vim admin tmux terminals
                     gdb time jq)

(operating-system
  (host-name "atomese")
  (timezone "UTC")
  (locale "en_US.utf8")

  ;; Minimal bootloader (required but unused in containers)
  (bootloader (bootloader-configuration
               (bootloader grub-bootloader)
               (targets '("/dev/sda"))))

  ;; Minimal filesystem (required but unused in containers)
  (file-systems (cons (file-system
                        (mount-point "/")
                        (device "/dev/sda")
                        (type "ext4"))
                      %base-file-systems))

  ;; Packages available in the container
  (packages (append (list cogutil
                          atomspace
                          ;; Core utilities
                          coreutils
                          bash
                          guile-3.0
                          ;; Editors and pagers
                          less
                          vim
                          ;; System tools
                          lsof
                          tmux
                          byobu
                          ;; Development tools
                          gdb
                          time
                          xxd
                          jq)
                    %base-packages))

  ;; Services
  (services (append (list (service dhcp-client-service-type))
                    %base-services)))
