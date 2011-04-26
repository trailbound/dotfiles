;; Global environment variables
(setq user-path (concat "~/../.." (getenv "USER_PATH")))
(setq user-config (concat user-path "/user.el"))

;; Paths
(add-to-list 'load-path user-path)

