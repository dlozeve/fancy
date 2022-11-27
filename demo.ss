#!/usr/bin/env gxi

(export main)

(import :std/format
	:std/iter
	:gerbil/gambit/threads
	:dlozeve/fancy/format
	:dlozeve/fancy/table
	:dlozeve/fancy/rule
	:dlozeve/fancy/progress
	:dlozeve/fancy/spinner)

(def (main)
  (display (rule "[bold green]Fancy demo" style: 'simple width: 100))
  (displayln)
  (displayln (parse-markup
	      "[bold red]Lorem ipsum[/bold red] dolor sit amet, [underline]consectetur[/underline] adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
minim veniam, [cyan]quis nostrud exercitation [yellow]ullamco[/yellow] laboris[/cyan] nisi ut
aliquip ex ea commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
pariatur. [black on yellow]Excepteur sint [on red]occaecat[/on red] cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum."))
  (displayln)

  (def tab (table '("[bold]#" "[bold]Name" "[bold]Property") '(3 20 20)))
  (display (table-header tab))
  (display (table-row tab "42" "[green]Foo" "Bar"))
  (display (table-row tab "21" "[red]Toto" "Blublu"))
  (display (table-footer tab))
  (displayln)
  (displayln)
  (def pbar (progress-bar 100 "[green]Progress: " percent: #f style: 'line))
  (for ((i (in-range 100)))
    (display (progress pbar (1+ i)))
    (thread-sleep! 0.05))
  (displayln)
  (for ((i (in-range 20)))
    (display (spinner i "[yellow]Waiting:" (format "(computing ~d/20)" (1+ i))
		      style: 'dots))
    (thread-sleep! 0.1))
  (displayln))
