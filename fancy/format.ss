(export
  ;; Control sequences
  cursor-up
  cursor-down
  cursor-forward
  cursor-back
  cursor-next
  cursor-previous
  cursor-hor
  cursor-pos
  erase-in-display
  erase-in-line
  scroll-up
  scroll-down
  save-pos
  restore-pos
  ;; Graphics rendition parameters
  graphics-style
  ;; Console markup
  parse-markup
  remove-markup)

(import :std/format
	:std/pregexp
	:std/misc/string
	:std/srfi/1)


;; ========================= Constants ========================= 

(def +CSI+ "\033[")

(def +basic-colors+
  '((black . 0)
    (red . 1)
    (green . 2)
    (yellow . 3)
    (blue . 4)
    (magenta . 5)
    (cyan . 6)
    (white . 7)))
(def +basic-bg-colors+
  '((on-black . 0)
    (on-red . 1)
    (on-green . 2)
    (on-yellow . 3)
    (on-blue . 4)
    (on-magenta . 5)
    (on-cyan . 6)
    (on-white . 7)))

(def +re-tags+ (pregexp "\\[([a-z#\\/].*?)\\]"))


;; ========================= Control sequences =========================

(def (cursor-up (n 1)) (format "~a~dA" +CSI+ n))
(def (cursor-down (n 1)) (format "~a~dB" +CSI+ n))
(def (cursor-forward (n 1)) (format "~a~dC" +CSI+ n))
(def (cursor-back (n 1)) (format "~a~dD" +CSI+ n))
(def (cursor-next (n 1)) (format "~a~dE" +CSI+ n))
(def (cursor-previous (n 1)) (format "~a~dF" +CSI+ n))
(def (cursor-hor (n 1)) (format "~a~dG" +CSI+ n))
(def (cursor-pos (n 1) (m 1)) (format "~a~d;~dH" +CSI+ n m))
(def (erase-in-display (n 0)) (format "~a~dJ" +CSI+ n))
(def (erase-in-line (n 0)) (format "~a~dK" +CSI+ n))
(def (scroll-up (n 1)) (format "~a~dS" +CSI+ n))
(def (scroll-down (n 1)) (format "~a~dT" +CSI+ n))
(def (save-pos) (format "~as" +CSI+))
(def (restore-pos) (format "~au" +CSI+))


;; ========================= Graphics rendition parameters =========================

(def (graphics-rendition-code tag)
  (match tag
    ('bold "2")
    ('italic "3")
    ('underline "4")
    ((? (lambda (t) (assgetq t +basic-colors+)) => code) (format "3~d" code))
    ((? (lambda (t) (assgetq t +basic-bg-colors+)) => code) (format "4~d" code))
    (else #!void)))

(def (graphics-style style)
  (def colors (lset-intersection eq? style (map car +basic-colors+)))
  (def bg-colors (lset-intersection eq? style (map car +basic-bg-colors+)))
  (def style-without-colors (lset-difference eq? style
					     (map car +basic-colors+)
					     (map car +basic-bg-colors+)))
  (def final-style (cons* (unless (null? colors) (car colors))
			  (unless (null? bg-colors) (car bg-colors))
			  style-without-colors))
  (format "~a~am" +CSI+
	  (string-join (filter string? (map graphics-rendition-code final-style)) #\;)))


;; ========================= Console markup =========================

(def (parse-tag contents (style []))
  (def closing (eq? #\/ (string-ref contents 0)))
  (def clean-contents (string-subst (string-trim-prefix "/" contents) "on " "on-"))
  (def tags (map string->symbol (string-split clean-contents #\ )))
  (def new-style (if closing
		   (lset-difference eq? style tags)
		   (lset-union eq? style tags)))
  (def control-seq (graphics-style new-style))
  (values control-seq new-style))

(def (parse-markup text (style []))
  (match (pregexp-match +re-tags+ text)
    ([tag contents] (let-values (((control-seq new-style) (parse-tag contents style)))
		      (parse-markup (pregexp-replace +re-tags+ text control-seq) new-style)))
    (else (str text (graphics-style [])))))

(def (remove-markup text)
  (pregexp-replace* +re-tags+ text ""))
