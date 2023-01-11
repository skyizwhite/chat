(defpackage #:chat/client
  (:use #:cl #:parenscript)
  (:import-from #:jingle)
  (:import-from #:cl-who)
  (:export #:*client-app*))
(in-package #:chat/client)

(defparameter *client-app* (jingle:make-app))

(defun script ()
  (ps
    (setf (@ window onload)
          (lambda ()
            (defparameter input-field (chain document (get-element-by-id "chat-input")))

            (defun receive-message (msg)
              (let ((li (chain document (create-element "li"))))
                (setf (@ li text-content) (@ msg data))
                (chain document
                       (get-element-by-id "chat-echo-area")
                       (append-child li))
                undefined))

            (defparameter ws (new (-Web-Socket "ws://127.0.0.1:3000/")))
            
            (chain ws (add-event-listener "message" #'receive-message))
            (chain input-field
                   (add-event-listener
                    "keyup"
                    (lambda (evt)
                      (when (= (@ evt key) "Enter")
                          (chain ws (send (@ evt target value)))
                          (setf (@ evt target value) ""))
                      undefined)))
            undefined))))

(defun handler (params)
  (declare (ignore params))
  (jingle:with-html-response
    (cl-who:with-html-output-to-string (s nil :indent t)
      (:html :lang "ja"
       (:head
        (:meta :charset "utf-8")
        (:title "Chat Room"))
       (:body
        (:ul :id "chat-echo-area")
        (:div :style "position:fixed; bottom:0;"
         (:input :id "chat-input" :placeholder "say something"))
        (:script :type "text/javascript" (cl-who:str (script))))))))

(setf (jingle:route *client-app* "/") #'handler)
