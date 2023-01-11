(defpackage #:chat/app
  (:use #:cl)
  (:import-from #:chat/server
                #:server-app))
(in-package :chat/app)

#'server-app
