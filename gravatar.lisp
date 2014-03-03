(in-package #:gravatar)

(defvar +base-uri+ "https://secure.gravatar.com/"
  "Why would we ever _not_ use SSL?")

(defun hash (email)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence :md5
			     (trivial-utf-8:string-to-utf-8-bytes
			      (string-downcase (string-trim '(#\Space)
							    email))))))

(defun image-url (email &key size default force-default-p rating)
  "DEFAULT may be either a URL to your own image, or one of :404, :mm,
   :identicon, :monsterid, :wavatar, or :retro. RATING may be one of :g, :pg,
   :r, or :x."
  (let ((parameters ()))
    (when size (push `("s" . ,(format nil "~d" size)) parameters))
    (typecase default
      (keyword (push `("d" . ,(string-downcase default)) parameters))
      (string (push `("d" . ,default) parameters)))
    (when force-default-p (push '("f" . "y") parameters))
    (when rating (push `("r" . ,(string-downcase rating)) parameters))
    (format nil "~Aavatar/~A~@[?~A~]"
	    +base-uri+
	    (hash email)
	    (drakma::alist-to-url-encoded-string parameters
						 :utf-8))))

(defun generate-profile-url (email type parameters)
  (format nil "~Ag2-~A.~A~@[?~A~]"
	  +base-uri+
	  (hash email)
	  (string-downcase type)
	  (drakma::alist-to-url-encoded-string parameters
					       :utf-8)))

(defun profile-url (email js-callback)
  (generate-profile-url email
                        :json
                        (when js-callback `(("callback" . ,js-callback)))))

(defun qr-code-url (email &key size)
  (generate-profile-url email
                        :qr
                        (when size `(("s" . ,(format nil "~d" size))))))
