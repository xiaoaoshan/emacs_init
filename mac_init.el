;; -*- lexical-binding: t; -*-

;; Fix macOS 27 libgccjit deployment target
(when (eq system-type 'darwin)
  (require 'subr-x)
  (setenv "MACOSX_DEPLOYMENT_TARGET"
          (string-trim
           (shell-command-to-string "sw_vers -productVersion"))))

;;; Get rid of annoying settings
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(global-whitespace-mode 1)
(save-place-mode 1)
(setq-default truncate-lines nil)
(setq-default word-wrap nil)
(setq whitespace-style (remove 'newline-mark whitespace-style))
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file :noerror)
(setq auto-save-default nil)
(auto-save-mode -1)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(setq whitespace-style
      (remove 'lines whitespace-style))
(setq default-directory "~/code")
(require 'use-package)
(setq package-archives '(("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")))

;;; Character UTF-8
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(setq-default buffer-file-coding-system 'utf-8-unix)
(set-file-name-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
(setq locale-coding-system 'utf-8)

;;; Fonts
(set-face-attribute 'default nil
                    :family "Iosevka"
                    :height 180)

(set-face-attribute 'fixed-pitch nil
                    :family "Iosevka"
                    :height 180)

(set-fontset-font nil 'han
                  (font-spec :family "Sarasa Fixed SC")
                  nil 'prepend)

;;; Theme gruber-darker
(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

;;; ido and smex
(ido-mode 1)
(ido-everywhere 1)
(use-package ido-completing-read+
  :ensure t
  :config
  (ido-ubiquitous-mode 1))
(use-package smex
  :ensure t
  :bind
  (("M-x" . smex)
   ("C-c C-c M-x" . execute-extended-command)))

;;; Magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;;; Company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(with-eval-after-load 'company
  (setq company-backends
        (remove 'company-clang company-backends)))

;;; aggressive-indent
(use-package aggressive-indent
  :ensure t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

;;; tramp
;;; http://stackoverflow.com/questions/13794433/how-to-disable-autosave-for-tramp-buffers-in-emacs
(setq tramp-auto-save-directory "/tmp")

;;; Markdown
(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;;;gtpel
(use-package gptel
  :ensure t)
(setq gptel-api-key "sk-2b5e55adfe")
(setq gptel-backend
      (gptel-make-openai "DeepSeek"
        :host "api.deepseek.com"
        :endpoint "/chat/completions"
        :stream t
        :key gptel-api-key
        :models '("deepseek-flash" "deepseek-v4-pro")))
(setq gptel-model 'deepseek-flash)

;;; Dired
(unless (eq system-type 'windows-nt)
  (setq dired-listing-switches
        (if (eq system-type 'darwin)
            "-alhv"
          "-alhv --group-directories-first")))
(global-set-key (kbd "C-x C-d") 'dired-jump)

;;; Move Text
(use-package move-text
  :ensure t
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

;;; Duplicate Line
(defun my/duplicate-line ()
  (interactive)
  (let ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
    (unless (string-empty-p line)
      (end-of-line)
      (newline)
      (insert line))))
(global-set-key (kbd "C-c d") 'my/duplicate-line)

;;; Frame

(setq default-frame-alist
      (append '((width . 120)
                (height . 40)
                (top . 40)
                (left . 100))
              default-frame-alist))

(setq initial-frame-alist
      '((width . 120)
        (height . 40)
        (top . 40)
        (left . 100)))
