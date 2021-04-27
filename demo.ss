#!/usr/bin/env gxi

(export main)

(import :std/format
	:std/iter
	:gerbil/gambit/threads
	:dlozeve/fancy/format
	:dlozeve/fancy/table
	:dlozeve/fancy/rule
	:dlozeve/fancy/spinner)

(def (main)
  (display (rule "[bold green]Fancy demo" style: 'simple))
  (displayln)
  (displayln (parse-markup
	      "[bold red]Lorem ipsum[/bold red] dolor sit amet, [underline]consectetur[/underline] adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
minim veniam, [cyan]quis nostrud exercitation [bold]ullamco[/bold] laboris[/cyan] nisi ut
aliquip ex ea commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
pariatur. [yellow]Excepteur sint [underline]occaecat[/yellow underline] cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum."))
  (displayln)

  (def tab (table '("[bold]#" "[bold]Name" "[bold]Property") '(3 20 20)))
  (display (table-header tab))
  (display (table-row tab "42" "[green]Foo" "Bar"))
  (display (table-row tab "21" "[red]Toto" "Blublu"))
  (display (table-footer tab))
  (displayln)
  (displayln)
  (for ((i (in-range 20)))
    (display (spinner i "[yellow]Waiting:" (format "(computing ~d/20)" (1+ i))
		      style: 'dots))
    (thread-sleep! 0.1))
  (displayln))
