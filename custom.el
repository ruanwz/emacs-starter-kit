(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit/ecb-2.32"))
(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit/cedet-1.0pre6/common"))

(require 'idle-highlight)
;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;;(load-file "~/.emacs.d/elpa-to-submit/cedet-1.0pre6/common/cedet.el")
(require 'cedet)

;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; Enable EDE for a pre-existing C++ project
;; (ede-cpp-root-project "NAME" :file "~/myproject/Makefile")


;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:

;; * This enables the database and idle reparse engines
(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as intellisense mode
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-gaudy-code-helpers)

;; * This enables the use of Exuberent ctags if you have it installed.
;;   If you use C++ templates or boost, you should NOT enable it.
;; (semantic-load-enable-all-exuberent-ctags-support)

;; Enable SRecode (Template management) minor-mode.
;; (global-srecode-minor-mode 1)

;;ECB
;;(add-to-list 'load-path
;;    "/localdisk/data/download/ecb-2.32")

(require 'ecb)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.32"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
;;Erlang
(setq load-path (cons  "/localdisk/data/erlang/lib/erlang/lib/tools-2.6.2/emacs"
											       load-path))
(setq erlang-root-dir "/localdisk/data/erlang/lib/erlang")
(setq exec-path (cons "/localdisk/data/erlang/bin" exec-path))
(setq erlang-man-root-dir "/localdisk/data/erlang/lib/erlang/man")
(require 'erlang-start)
(add-to-list 'auto-mode-alist '("\\.erl?$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl?$" . erlang-mode))
(defun my-erlang-mode-hook ()
  ;; when starting an Erlang shell in Emacs, default in the node name
  (setq inferior-erlang-machine-options '("-sname" "distel@localhost"))
  ;; add Erlang functions to an imenu menu
  (imenu-add-to-menubar "imenu")
  ;; customize keys
  (local-set-key [return] 'newline-and-indent)
  )
;; Some Erlang customizations
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

(add-to-list 'load-path "/usr/local/share/distel/elisp")
(require 'distel)
(distel-setup)
;; A number of the erlang-extended-mode key bindings are useful in the shell too
(defconst distel-shell-keys
  '(("\C-\M-i"   erl-complete)
    ("\M-?"      erl-complete)
    ("\M-."      erl-find-source-under-point)
    ("\M-,"      erl-find-source-unwind)
    ("\M-*"      erl-find-source-unwind)
    )
  "Additional keys to bind when in Erlang shell.")

(add-hook 'erlang-shell-mode-hook
          (lambda ()
            ;; add some Distel bindings to the Erlang shell
            (dolist (spec distel-shell-keys)
              (define-key erlang-shell-mode-map (car spec) (cadr spec)))))

(add-hook 'erlang-mode-hook
'(lambda ()
(unless erl-nodename-cache
(distel-load-shell))))
 
(defun distel-load-shell ()
"Load/reload the erlang shell connection to a distel node"
(interactive)
;; Set default distel node name
(setq erl-nodename-cache 'distel@localhost)
(setq distel-modeline-node "distel")
(force-mode-line-update)
;; Start up an inferior erlang with node name `distel'
(let ((file-buffer (current-buffer))
(file-window (selected-window)))
(setq inferior-erlang-machine-options '("-sname" "distel@localhost"))
(switch-to-buffer-other-window file-buffer)
(inferior-erlang)
(select-window file-window)
(switch-to-buffer file-buffer)))
