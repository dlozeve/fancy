#!/usr/bin/env gxi

(import :std/build-script)

(defbuild-script
  '("fancy/format"
    "fancy/table"
    "fancy/rule"
    "fancy/progress"
    "fancy/spinner")
  optimize: #t debug: 'src)
