(export (struct-out table)
	table-header
	table-row
	table-footer)

(import :std/misc/string
	:dlozeve/fancy/format)

(defstruct table (names widths style)
  constructor: :init!)

(defmethod {:init! table}
  (lambda (self names widths (style #f))
    (set! (table-names self) names)
    (set! (table-widths self) widths)
    (set! (table-style self) style)))

(def (column-text text width (style #f))
  (match style
    ('markdown
     (str " " (remove-markup text) (make-string (- width (string-length (remove-markup text)) 1) #\ )))
    (else
     (str " "
	  (parse-markup text)
	  (make-string (- width (string-length (remove-markup text)) 1) #\ )))))

(def (table-header tab)
  (match tab
    ((table names widths 'markdown)
     (str "|" (string-join (map (lambda (name width) (column-text name (+ 2 width) 'markdown)) names widths) #\|) "|\n"
	  "|" (string-join (map (lambda (w) (make-string (+ 2 w) #\-)) widths) #\|) "|\n"))
    ((table names widths _)
     (str "┌" (string-join (map (lambda (w) (make-string (+ 2 w) #\─)) widths) #\┬) "┐\n"
	  "│" (string-join (map (lambda (name width) (column-text name (+ 2 width))) names widths) #\│) "│\n"
	  "├" (string-join (map (lambda (w) (make-string (+ 2 w) #\─)) widths) #\┼) "┤\n"))))

(def (table-row tab . args)
  (match tab
    ((table names widths 'markdown)
     (str "|"
	  (string-join (map (lambda (text width) (column-text text (+ 2 width) 'markdown)) args widths) #\|)
	  "|\n"))
    ((table names widths _)
     (str "│"
	  (string-join (map (lambda (text width) (column-text text (+ 2 width))) args widths) #\│)
	  "│\n"))))

(def (table-footer tab)
  (match tab
    ((table names widths 'markdown) "\n")
    ((table names widths _)
     (str "└" (string-join (map (lambda (w) (make-string (+ 2 w) #\─)) widths) #\┴) "┘\n"))))
