(defpackage gravatar.system
  (:use #:cl #:asdf))

(in-package #:gravatar.system)

(defsystem gravatar
  :author "Greg Pfeil <greg@technomadic.org>"
  :license "Apache 2.0"
  :version "0.0.1"
  :depends-on (drakma ironclad cl-json trivial-utf-8)
  :components ((:file "package")
               (:file "gravatar" :depends-on ("package"))))
