\ ==============================================================================
\ ForestLib > Brute4X
\ Brute4x parser (v1)
\ ========================= copyright 2014 Roger Levy ==========================

\ 11/21/2013
\ Brute4x XML Parser
\ Current caveats:
\  * Right now node text content isn't even working properly
   \  * Can't process text from anywhere but at the beginning of each node  (effectively it's kind of an either-or thing atm)
\  * No graceful failure on number conversion (it will make your program barf if it's not a number)
\  * XML files can't cause other XML files to be loaded (it's not re-entrant)
\  * You have to be really really careful when you write schemas to make sure to overload any keywords that could cause trouble -
\    for instance if an attribute copies a name, but the data structure has no field for it, it could easily clobber the dictionary.
\    this is a bug that will have to be fixed eventually.

(

Makes use of Forth's parser by interally preprocessing XML files to be friendly to Forth syntax,
and using nested vocabularies to define lexicons local to the xml "schema" and nodes.  

"<?xml" is the kickoff word.  It copies the rest of the current file to a buffer, preprocesses it,
and then executes the buffer.  The rest of the source file input is skipped after processing.

To process a file, fload this module, then fload your schemas, then fload the xml file.  Data
storage is up to the schema code.  The stack is transparently preserved by the parser, so it
can be used for nesting.

A schema for this system is defined in the following manner:

[schema <name>
   [xmlnode <name>
      onprocess: <code> ;
      [xmlnode <name>
         onprocess: <code> ;      
         attribute: <name> <code> ;
         attribute: <name> <code> ;      
         attribute: <name> <code> ;
         onpostprocess: <code> ; 
      xmlnode]
      onpostprocess: <code> ;
   xmlnode]
schema]

"onprocess", "onpostprocess", and "attribute" definitions can use the following words to fetch data from the input buffer
in a handful of formats.

xmltext@
xmlint@
xmlfloat@
xmlflag@
xmlfixed@ [ if the fixed point extension is loaded ]

)

package brute4x
.s

private

fload files
fload general-structs
fload array

public
\ module ~brute4x

general-struct

\ this struct is used for both nodes and attributes
private

0
   var wl
   var onprocess            \ something very strange is going on ... seems that the offset is being overwritten!
   var onpostprocess
drop


private
0 value src
0 value srcsize
0 value buf   \ dynamic system memory
0 value bufsize
0 value >src
0 value >buf
0 value content
0 value contentsize

defer (>)      \ execute onprocess of current node
defer (/>)     \ remove current node wordlist from the search order

create nodes 40 stack,   \ used for both scheme and parser

: node   nodes top@ ;    \ current schema node definition and current node

\ :   / ;
: >  (>) ;   
: /> (/>) ;

\ Hopefully this will help avoid some issues
vocabulary disabled
also disabled definitions
: "  [char] " parse 2drop ;
: =  ;
: ?  ;
previous definitions


: allocate-buf
   srcsize 2* allocate abort" Out of memory allocating xml buffer."
      to buf 
;

: cleanup
   buf free drop src free drop
;


\ -------------------------------------------------------------------
\ Preprocessing

\   <        insert a space before
\   > />     insert a space before and after
\   "        insert a space after
\   =        insert a space before

: buf!+   >buf c!   1 +to >buf   1 +to bufsize ;
: char@   >src c@  ;
: +char@   >src 1 + c@ ;
: adv   1 +to >src  -1 +to srcsize ;
: copy   char@ buf!+ adv ;
: (space)   bl buf!+ ;
: preprocess-char
   char@ $d = char@ $a = or if (space) adv exit then
   char@ [char] = = if   (space) copy exit then
   char@ [char] < = if   (space) copy exit then
   char@ [char] > = if   (space) copy (space) exit then
   char@ [char] / = +char@ [char] > = and if  (space) copy copy (space)  exit then
   char@ [char] " = if  (space) copy (space)  exit then
   copy ;
   
: preprocess
   buf to >buf   src to >src   0 to bufsize
   begin preprocess-char srcsize 0 <= until
;

: skip-first-line
   src srcsize 
;

\ -------------------------------------------------------------------

\ Kickoff
public

\ not currently re-entrant!
: <?xml
   buf if [char] > parse 2drop ( >in ++ ) exit then  \ skips the xml tag
   including ['] file@ catch abort" There was a problem opening an xml file."
      to srcsize to src
      allocate-buf 
      preprocess 
      brute4x open-package public >r >r >r
\      bold cr buf bufsize type cr normal
      ['] not-defined >body @ >r
         \ [[ space type ." ?" ]] is not-defined   \ disable word-not-defined errors ... hopefully this doesn't backfire
         ['] 2drop is not-defined
      
      also disabled   \ overload some words that shouldn't manipulate  the stack
      \ order
      buf bufsize evaluate
      previous
         r> is not-defined
      r> r> r> end-package
      cleanup
   \\
   0 to buf
;

\ Schema / Parser

create localpath  256 allot

: +localpath  localpath count <$ $+ $> ;

: [schema   ( -- <name> ) ( xmlfilepath count -- )
   1 strands   create   nodes vacate   here nodes push   dup , +order definitions
   ['] noop , ['] noop ,
   does>   nodes vacate    dup @ +order   >onprocess @ execute
      2dup -name 1 + localpath place
      ?homepath included 
;
: schema]
   nodes pop drop   previous definitions
;

0 value text
0 value textsize

:noname
\   cr ." </> "
   text to content
   textsize to contentsize
   node >onpostprocess @ execute
   previous
   nodes pop drop
; is (/>)

:noname
\   cr ." > "
   [char] < parse 1 - to textsize to text
   >in --
; is (>)

: does-node   does> nodes push    node =>  onprocess @ execute   wl @ +order ;
: does-closenode   does> drop   />  [char] > skip-past  ;
: [xmlnode
   \ make node opener
   1 strands >r
   >in @
   " <" <$ bl parse $+ $> $create  \ " <name"
      here nodes push
      r> dup , ['] noop , ['] noop , +order definitions
      does-node
   \ make node closer
   >in !
   " </" <$ bl parse $+ $> $create \ " </name"
      does-closenode
;
: xmlnode]
   nodes pop drop
   previous definitions
;

: onprocess:     :noname node >onprocess ! ;
: onpostprocess: :noname node >onpostprocess ! ;

: does-attribute
   does>
      nodes push
         [char] = skip-past
         [char] " skip-past
         [char] " parse to contentsize to content
         node >onprocess @ execute
      nodes pop drop ;


: attribute:
   create
      0 , ( no wordlist ) here   0 , 0 ,
   does-attribute
   :noname swap !  
;

: xmltext@   content contentsize bl skip -trailing ;

: xmlint@
   \ maybe do some error checking here?
   xmltext@
   \ if it's nan, just return 0
      over 3 " nan" compare 0=
         if 2drop 0 exit then      
   number ;          \ right now you have to be sure it's an integer if you use this

: xmlfloat@
   xmltext@   \ " 0" <$ $+ $>
   \ if it's nan, just return 0
      over 3 " nan" compare 0=
         if 2drop 0e exit then
   \ if there's no e, we have to add one
      2dup [char] e scan nip 0=
         if <$ " e" $+ $> then
      number 
;

: xmlflag@
   xmltext@ number 0<>
;

[defined] p* [if]
: xmlfixed@
   xmltext@   \ " 0" <$ $+ $>
   \ if it's nan, just return 0
      over 3 " nan" compare 0=
         if 2drop 0 exit then

      number 
   \ if there's no decimal point, we need to convert it to fixed point
   xmltext@ [char] . scan nip 0= if s>p then
;
[then]

.s
end-package