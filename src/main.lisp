(defpackage #:chat
  (:use #:cl)
  (:nicknames #:chat/main)
  (:import-from #:clack)
  (:import-from #:chat/server
                #:server-app)
  (:import-from #:chat/client
                #:*client-app*)
  (:export #:start-server-app
           #:stop-server-app
           #:start-client-app
           #:stop-client-appqq))
(in-package #:chat)

(defvar *server-app-handler* nil)
  
(defun start-server-app ()
  (when *server-app-handler*
    (error "Server app is already started"))
  (setf *server-app-handler* (clack:clackup #'server-app :port 5000)))
  
(defun stop-server-app ()
  (unless *server-app-handler*
    (error "Server app is not started"))
  (clack:stop *server-app-handler*)
  (setf *server-app-handler* nil))

(defvar *client-app-handler* nil)

(defun start-client-app ()
  (when *client-app-handler*
    (error "Client app is already started"))
  (setf *client-app-handler* (clack:clackup *client-app* :port 4000)))

(defun stop-client-app ()
  (unless *client-app-handler*
    (error "Client app is not started"))
  (clack:stop *client-app-handler*)
  (setf *client-app-handler* nil))
