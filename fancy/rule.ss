(export rule)

(import :std/misc/string
	:dlozeve/fancy/format)

(def (rule text width: (width 80) style: (style 'simple))
  (def rule-len (- width (+ 2 (string-length (remove-markup text)))))
  (def left-len (1- (quotient rule-len 2)))
  (def right-len (1- (+ (remainder rule-len 2) (quotient rule-len 2))))
  (def c (match style
	   ('simple #\━)
	   ('double #\═)
	   ('dashed #\╌)))
  (str (make-string left-len c)
       " "
       (parse-markup text)
       " "
       (make-string right-len c)
       "\n"))
