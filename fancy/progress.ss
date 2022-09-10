(export (struct-out progress-bar)
	progress)

(import :std/misc/string
	:std/format
	:dlozeve/fancy/format)

(def +progress-styles+
  '((ascii  . (#\[ #\= #\> #\  #\]))
    (line   . (#\┝ #\━ #\━ #\  #\┥))
    (double . (#\╞ #\═ #\═ #\  #\╡))
    (block  . (#\│ #\█ #\█ #\ #\│))
    (halfblock . (#\╻ #\▄ #\▄ #\ #\╻))
    (dots   . (#\⣿ #\⠶ #\⠶ #\⠀ #\⣿))))

(defstruct progress-bar (total description length style percent)
  constructor: :init!)

(defmethod {:init! progress-bar}
  (lambda (self total (description #f) length: (length 80) style: (style 'line) percent: (percent #f))
    (struct-instance-init! self total description length style percent)))

(def (progress pbar n)
  (with ((progress-bar total description length style percent) pbar)
    (let* ((n (min total (max 0 n)))
	   (n-done (inexact->exact (floor (* (- length 3) (/ n total)))))
	   (n-remaining (inexact->exact (ceiling (* (- length 3) (/ (- total n) total)))))
	   (progress-chars (assgetq style +progress-styles+))
	   (bar (format "~c~a~c~a~c"
			(list-ref progress-chars 0)
			(make-string n-done (list-ref progress-chars 1))
			(list-ref progress-chars 2)
			(make-string n-remaining (list-ref progress-chars 3))
			(list-ref progress-chars 4)))
	   (progress (if percent
		       (format "~3,0F%" (* 100 (/ n total)))
		       (format "(~d/~d)"  n total))))
      (str (cursor-up 1)
	   (parse-markup description) bar " " progress "\n"))))
