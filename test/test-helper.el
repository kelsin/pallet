(let ((current-directory (file-name-directory load-file-name)))
  (setq pallet-test-test-path (f-expand "." current-directory)
        pallet-test-root-path (f-expand ".." current-directory)
        pallet-test-pkg-path (f-expand "packages" pallet-test-test-path)
        pallet-test-sandbox-path (f-expand "sandbox" pallet-test-test-path)))

(add-to-list 'load-path pallet-test-root-path)

(if (featurep 'pallet)
    (unload-feature 'pallet t))

(require 'pallet)
(require 'el-mock)
(require 'cl)
(require 'package)

(defun pallet-test-package-file (file-name)
  "Easily get a mock package file by name."
  (f-expand file-name pallet-test-pkg-path))

(defun pallet-test-do-package-delete (name version)
  "Run package delete in 24.3.1 or 24.3.5 environments."
    (if (fboundp 'package-desc-create)
        (package-delete (package-desc-create :name name :version version))
      (package-delete name version)))

(defmacro pallet-test-with-sandbox (&rest body)
  "Clean the sandbox, run body."
  `(let ((default-directory ,pallet-test-sandbox-path)
         (user-emacs-directory ,pallet-test-sandbox-path)
         (package-user-dir ,(f-expand "elpa" pallet-test-sandbox-path)))
     (progn
       (pallet-test-cleanup-sandbox)
       ,@body)))

(defun pallet-test-cleanup-sandbox ()
  "Clean the sandbox."
  (f-entries pallet-test-sandbox-path
             (lambda (entry)
               (f-delete entry t))))
