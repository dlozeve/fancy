#!/usr/bin/env gxi

(import :std/build-script)

(defbuild-script
  '("fancy/format"
    "fancy/table")
  optimize: #t)
