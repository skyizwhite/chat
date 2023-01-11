(defpackage #:chat/server
  (:use #:cl)
  (:import-from #:websocket-driver)
  (:export #:server-app))
(in-package #:chat/server)

(defvar *connections* (make-hash-table))

(defun create-user ()
  (format nil "user-~a" (random 100000)))

(defun register-user (connection user)
  (setf (gethash connection *connections*) user))

(defun find-user (connection)
  (gethash connection *connections*))

(defun delete-user (connection)
  (remhash connection *connections*))

(defun broadcast-to-room (message)
  (loop :for con :being :the :hash-key :of *connections*
        :do (websocket-driver:send con message)))

(defun handle-new-connection (connection)
  (let ((user (create-user)))
    (register-user connection user)
    (broadcast-to-room (format nil "... ~a has entered." user))))

(defun handle-post-message (connection message)
  (broadcast-to-room (format nil "~a: ~a" (find-user connection) message)))

(defun handle-close-connection (connection)
  (broadcast-to-room (format nil "... ~a has left." (find-user connection)))
  (delete-user connection))

(defun server-app (env)
  (let ((ws (websocket-driver:make-server env)))
    (websocket-driver:on :open ws
                         (lambda () (handle-new-connection ws)))
    (websocket-driver:on :message ws
                         (lambda (msg) (handle-post-message ws msg)))
    (websocket-driver:on :close ws
                         (lambda (&key code reason)
                           (declare (ignore code reason))
                           (handle-close-connection ws)))
    (lambda (responder)
      (declare (ignore responder))
      (websocket-driver:start-connection ws))))
