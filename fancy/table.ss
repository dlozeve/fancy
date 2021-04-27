(export (struct-out table)
	table-header
	table-row
	table-footer)

(import :std/misc/string
	:dlozeve/fancy/format)

(defstruct table (names widths))

(def (column-text text width)
  (str " "
       (parse-markup text)
       (make-string (- width (string-length (remove-markup text)) 1) #\ )))

(def (table-header tab)
  (with ((table names widths) tab)
    (str "┌" (string-join (map (lambda (w) (make-string (+ 2 w) #\─)) widths) #\┬) "┐\n"
	 "│" (string-join (map (lambda (name width) (column-text name (+ 2 width))) names widths) #\│) "│\n"
	 "├" (string-join (map (lambda (w) (make-string (+ 2 w) #\─)) widths) #\┼) "┤\n")))

(def (table-row tab . args)
  (with ((table names widths) tab)
    (str "│"
	 (string-join (map (lambda (text width) (column-text text (+ 2 width))) args widths) #\│)
	 "│\n")))

(def (table-footer tab)
  (with ((table names widths) tab)
    (str "└" (string-join (map (lambda (w) (make-string (+ 2 w) #\─)) widths) #\┴) "┘\n")))
