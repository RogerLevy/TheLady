\ ==============================================================================
\ ForestLib
\ Base of toolbelt
\ ========================= copyright 2014 Roger Levy ==========================


\ Floating-point support
include fpmath  \ note this version adds fixed point recognition to the interpreter

: f?  f@ f. ;

aka (f>s) f>s  \ disables rounding.  this fixes random crashes.

include nonstandard   \ so-called because it changes 2+ , @+ , pushpath , 2@ , and more.



: ENDING ( addr len char -- addr len )
   >R BEGIN  2DUP R@ SCAN
      ?DUP WHILE  2SWAP 2DROP  1 /STRING
   REPEAT  R> 2DROP ;

: -EXT ( a n -- a n )
   2dup [char] . scan nip 0= ?exit \ no dot
   2DUP  [CHAR] . ENDING  NIP -  1-  0 MAX ;



\ Just search for a file from the current directory
: ?file  ( zfilename -- filepath count true | false )
   zcount z$
   [OBJECTS FILE-FINDER MAKES FF OBJECTS]
   dup z" ." ff file-search dup if
      zcount <$ " \" $+ zcount $+ $>
      true
   else drop drop false
   then
   ;

: empty
   empty only forth definitions ;



\ Session stuff

create session$ 256 allot

: session  ( -- <name> )
   create
   !home pushpath
   including session$ place
   cr inverse session$ count -name [char] \ scanlast type normal cr ;

: rld
   " empty" evaluate  \ make sure we use the newest one
   zhome SetCurrentDirectory drop
   session$ count $fload ;



file-viewer +order
name-tools +order
also forth

: echo-line ( fid -- flag )
   r-buf  r@ 250 rot aline drop   r> rot
   bl skip type  ;

: view-lines ( start len fid -- ior )
   dup rewind-file drop  rot goto-line  swap 0 ?do
      dup echo-line  0= if  leave
   then loop  drop 0 ;

: get-viewline ( line addr len -- addr len )
   r/o open-file if  2drop  s" ..."  exit  then
   swap goto-line ( fid)
   pad 1+ 250 third read-line 2drop pad c!
   close-file drop  pad count ;

: viewing-lines ( line addr len #lines -- )   >r
   r/o open-file throw ( line fid)
   swap r> third view-lines drop
   close-file drop ;

: viewline ( xt -- )
   locals| xt |
   xt false word-location dup 0= if
      3drop xt >name count type space ."  (Source not available) " exit
   then
   ( line path c ) 1 viewing-lines ;

\ : .contextdefs
\    context @ [[ cr dup count type get-xy nip 32 swap at-xy name> viewline ]] .wid-words ;


\ : .definitions
\    wids begin @rel ?dup while
\       dup
\       cell+ -origin
\       cr cr ." wordlist> " dup .wid cr
\       dup [[ cr dup count type get-xy nip 32 swap at-xy name> viewline ]] .wid-words
\       drop
\    repeat ;


: (explore)   ( path& len -- )
   s" explorer " pad place ( path& len ) pad append pad count >shell ;

: explore   ( -- <path> )
   0 parse dup 0= if 2drop s" . " then (explore) ;


gild empty

report( Loaded rlevy-base )