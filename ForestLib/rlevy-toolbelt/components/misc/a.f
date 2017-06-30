\ ==============================================================================
\ ForestLib
\ A register
\ ========================= copyright 2014 Roger Levy ==========================

\ 4/23/13

[defined] `a [if] \\ [then] : `a ;

variable 'a
: a@   " 'a @ " evaluate ; immediate 
: a!   " 'a ! " evaluate ; immediate
: @+   " 'a @ @ cell 'a +! " evaluate ; immediate
: !+   " 'a @ ! cell 'a +! " evaluate ; immediate
macro: 2!+  swap !+ !+ ;
macro: !a   'a @ ! ;
macro: @a   'a @ @ ;
macro: +a   'a +! ;
: a!>   r> 'a @ >r swap 'a ! call r> 'a ! ;
: $@+  'a @ count dup 1 + 'a +! ;
macro: c@+  'a @ c@ 'a ++ ;
macro: c!+  'a @ c! 'a ++ ;
: h!+   " 'a @ h! 2 'a +! " evaluate ; immediate
: h@+   " 'a @ h@ 2 'a +! " evaluate ; immediate
macro: sf@+   'a @ sf@ cell 'a +! ;
macro: sf!+   'a @ sf! cell 'a +! ;
aka a@ a>
: string!+   dup c!+ dup >r a@ swap move r> +a ;

\ replaces function of old @+, !+...
\ macro: sized   ( addr size -- addr+size addr ) dup u+ ;
