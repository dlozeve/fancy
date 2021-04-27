(export spinner)

(import :std/misc/string
	:dlozeve/fancy/format)

(def +spinner-styles+
  '((dots . "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏")
    (block . "▖▘▝▗")
    (triangle . "◢◣◤◥")
    (circle . "◐◓◑◒")
    (vertical . "▁▃▄▅▆▇█▇▆▅▄▃")
    (horizontal . "▉▊▋▌▍▎▏▎▍▌▋▊▉")
    (ascii . "|/-\\")))

(def (spinner i text-before text-after style: (style 'dots))
  (def spinner-chars (assgetq style +spinner-styles+))
  (str (cursor-up 1)
       (parse-markup text-before)
       " "
       (string-ref spinner-chars (modulo i (string-length spinner-chars)))
       " "
       (parse-markup text-after)
       "\n"))
