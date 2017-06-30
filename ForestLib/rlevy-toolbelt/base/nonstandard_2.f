\ ==============================================================================
\ ForestLib
\ Non-standard core extensions.  FLOAD, closures/lambda functions, more
\ ========================= copyright 2014 Roger Levy ==========================

[defined] rlevy-nonstandard [if] \\ [then]
true constant rlevy-nonstandard

\ win32/Linux compatibility... incomplete

: getdir
   [defined] GetCurrentDirectory [if]
      GetCurrentDirectory
   [else]
      swap getcwd zcount
   [then] ;

\ PAD 256 OVER GetCurrentDirectory TYPE ;
\ PAD 256 getcwd ZCOUNT TYPE ;

: setdir
   [defined] SetCurrentDirectory [if]
      SetCurrentDirectory
   [else]
      chdir
   [then] ;

\ DIRSTACK SetCurrentDirectory DROP
\ DIRSTACK chdir DROP




aka s" " immediate
: ]#   ] postpone literal ;
: cell/   cell / ;

\ -------------------------------------------------------------------------------------------------
\ Psuedo-closures

: does-:[  ( -- )
   IMMEDIATE DOES> @  ( xt )  compile,  postpone (else) here +bal  false ;

: >quote
   5 + code> ;

: :[] ( -- <name> )
   CREATE here 0 , does-:[
   :NONAME swap ! postpone r@ postpone >quote ;

: ]] ( -- )
   if postpone noop ( thwart some nasty bugs ) postpone ; exit then
   postpone exit  >resolve ; IMMEDIATE

AKA ]] ;] IMMEDIATE
:[] [[ ( -- xt )  ;
: [[   state @ if postpone [[ else :noname true then ; IMMEDIATE


\ -------------------------------------------------------------------------------------------------
\ Extended primitives

: --   -1 swap +! ;
: toggle   ( addr -- ) DUP @ NOT SWAP ! ;
: 2negate  ( x y -- -x -y ) negate swap negate swap ;
: u+  ( a b c -- a+c b ) rot + swap ;
: nips   ( ... n1 count -- ) 0 do nip loop ;
: reverse   ( ... count -- ... ) 1+ 1 max 1 ?do i 1- roll loop ;
: w,  ( n -- ) here w! 2 allot ;
\ keep value in range using wrap; integer or fixed point OK
: wrap  ( n u-start u-range -- n ) >r swap over - r> swap over 2* + swap mod + ;

\ ------------------------------------------------------------------------------
\ simple backwards linked-list function
: link!  ( item item-link lastitem-link -- ) dup @ rot ! ! ;
\ dup @ ( lastitem ) rot ( lastitem itemlink ) ! ( item lastitem-link ) ! ;

\ ------------------------------------------------------------------------------
\ and forwards
: list,   ( -- addr )
   here   ( first ) 0 , ( last ) 0 , ( count ) 0 , here here third 2!
   ( link-addr ) ( next ) 0 , ( data ) 0 , ;

5 cells constant /list

: list   ( -- <name> )
   create list, drop ;

: link,    ( item list -- )
   swap >r   dup cell+ @   here    0 , r> ,   locals| thislink lastlink list |
   thislink lastlink !   thislink list cell+ !    1 list cell+ cell+ +! ;

\ circular link
: clink,    dup >r   link,   r@ @ r> cell+ @ ! ;

: howmany   ( list -- count ) cell+ cell+ @ ;

0 value xt
: traverse  ( xt list -- )  ( item -- )  \ don't use with circular lists
   xt >r  swap to xt
   @ ( skip first dummy link )
   begin @ dup while dup >r   cell+ @ xt execute   r> repeat
   drop  r> to xt ;

: startover   ( list -- ) dup cell+ cell+ off dup dup @ swap cell+ ! @ 2 cells erase ;

\ ------------------------------------------------------------------------------

\ compile literal if in compile mode
: ?literal  state @ if postpone literal then ;

\ keep value in range using clamp
: clamp  ( n min max -- n )
   >r max r> min ;

: << " LSHIFT " EVALUATE ; IMMEDIATE
: >> " RSHIFT " EVALUATE ; IMMEDIATE

: h.  ( n -- ) ." $" h. ;
: 2.   ( x y -- ) swap . . ;
: drops   ( ... n -- ) 0 ?do drop loop ;
: nips    ( ... X n -- ) 0 ?do nip loop ;


\ ------------------------------------------------------------------------------
\ string concatenation
Create $buffers   16384 allot
Variable >$
: <$   >$ @ 256 + 16383 and >$ !   >$ @ $buffers + place ;
: $+   >$ @ $buffers + append ;
: c$+  >$ @ $buffers + count + c!   1 >$ @ $buffers + c+! ;
: $>   >$ @ $buffers + count   ( >$ @ 256 - 16383 and >$ ! ) ;

\ convert string to zero-terminated string
: z$   ( addr c -- zaddr ) >$ @ $buffers + zplace  >$ @ $buffers +   >$ @ 256 + 16383 and >$ ! ;

\ create a word from a given string
: $create ( addr c -- )
   skip-cl  get-current (wid-create) last @ >create ! ;

\ -------------------------------------------------------------------------------------------------
\ Directory utility classes

\ improved path stack ... circular buffer
create dirstack 2048 cell+ /allot
: dirstack>  dirstack cell+ dirstack @ 2047 and + ;

: pushpath ( -- )
   255 dirstack> getdir drop
   256 dirstack +! ;

: lastpath
   -256 dirstack +!   dirstack> zcount  256 dirstack +! ;

: poppath ( -- )
   -256 dirstack +!
   dirstack> setdir drop ;

\ I can't fathom a single use for this word other than creating complexity.
: droppath ( -- )
   -1 abort" DROPPATH? WTF???" ;



\ ------------------------------------------------------------------------------

\ include file-search

\ -------------------------------------------------------------------------------------------------
\ Enhanced include facility - FLOAD 
\  Features:
\   If only a filename is given, FLOAD automatically searches the directory structure for the file, recursively,
\   starting with the current folder, then if it isn't found, from the directory of THIS file, by default.
\   To change the root folder for searching, use ROOT!
\   Automatic saving and restoring of search order using circular buffer, to relieve user of need to keep track of it
\   Moves the current directory to the given source file, as expected.  Restores it after loading it or if there was an error.
\   4/27/13 after checking the current folder and subdirs, it checks the new "home" folder's direct child folders
\           before checking the "root" recursively.

create zroot 256 /allot  \ "project" root folder
create zhome 256 /allot  \ "work" root folder
create efolder 256 /allot  \ exclude from search
\ create zfolder 256 /allot

: !root ( -- ) 256 zroot getdir drop ; !root  \ gets overwritten anyway, but for testing...
: !home ( -- ) 256 zhome getdir drop ; !home
{
: ?folder  ( zfilepath -- folderpath count true | false )
   dup zcount -name ?dup if rot drop true exit then drop
   [OBJECTS FILE-FINDER MAKES FF OBJECTS]
   zfolder ff file-search dup if
      zcount true
   else drop false
   then ;

: ?shallow  ( zfilepath -- folderpath count true | false )
   dup zcount -name ?dup if rot drop true exit then drop
   [OBJECTS FILE-FINDER MAKES FF OBJECTS]
   zfolder ff file-shallow-search dup if
      zcount true
   else drop false
   then ;
}
: default.ext
   \ 2dup 2 string/ " .f" compare(nc) 0<> if <$ " .f" $+ $> then ;
   2dup [char] . skip " ." search nip nip 0= if <$ " .f" $+ $> then ;


\ "A" register 
wordlist constant [a]
[a] +order definitions
variable 'a
: @+   'a @ @ cell 'a +! ;
: !+   'a @ ! cell 'a +! ;
: !a   'a @ ! ;
: @a   'a @ @ ;
: a>   r> 'a @ >r swap 'a ! call r> 'a ! ;
only forth definitions
[a] +order


20 constant #orders
20 cells constant /order
create orders /order #orders * /allot
variable o    \ index of the next "order" in the circular buffer
variable 'm   \ contains voc for 'protected' words - current plugin
variable 'm2  \ contains voc for 'exposed' words

: order>   o @ /order * orders + ;

: +o       o @ + 0 #orders wrap o ! ;

: push-order
   order> a> get-order !a @a reverse @+ 0 ?do !+ loop get-current !+ 'm @ !+ 'm2 @ !+
   1 +o ;

: pop-order
   -1 +o
   order> a> @+ dup >r 0 ?do @+ loop r> set-order @+ set-current @+ 'm ! @+ 'm2 ! ;

[a] -order

\ this allows scripts to use QUIT to stay in the current directory or for debugging

variable reloading?
variable fnest
variable lti
create files   4096 allot
variable >files
: >file   >files @ files + place   >files @ 256 + 4095 and >files ! ;
: file>   >files @ 256 - 4095 and >files !   >files @ files + count ;
: quit   'source-id @ 0 > if 'source-id @ close-file drop then quit ;
: /fnest   fnest -- fnest @ 0 = if lti ++ then ;

: ((fload))
   2swap zfolder zplace
   pushpath push-order
      zfolder setdir drop
      -path ['] included catch ?dup if /fnest throw then
   poppath pop-order
;

: (fload)   ( addr c -- )
   'source-id @ 0 > if
      including >file 'source-id @ close-file drop
      ((fload))
      file> r/o open-file drop 'source-id !
   else
      ((fload))
   then
;

: dot...folder ( addr c -- flag )
   1 >  swap c@ [char] . = and ;

: exclude-dot...folder-filter  ( zfolderpath -- enter? )
   zcount dot...folder not ;
   
: exclude-folder-filter  ( zfolderpath -- enter? )
   zcount
   2dup 2>r  efolder zcount uppcompare 0=
   2r>  dot...folder or not
;

: $fload
   /bal
   fnest ++
   r-buf
   default.ext r@ zplace

   \ cr pwd
   0 efolder c!
   " ." zfolder zplace
   zfolder setdir drop
   r@ ['] exclude-dot...folder-filter ?folder-fast2 if r> zcount (fload) /fnest exit then

   \ ." home"
   256 efolder getdir drop
   zhome zcount zfolder zplace
   zfolder setdir drop
   r@ ['] exclude-folder-filter ?folder-fast2 if r> zcount (fload) /fnest exit then

   \ ." root"
   zhome zcount efolder zplace
   zroot zcount zfolder zplace
   zfolder setdir drop
   r@ ['] exclude-folder-filter ?folder-fast2 if r> zcount (fload) /fnest exit then

   0 fnest !
   r> zcount here place  -38 throw
;

: fload ( -- <filepath> )
   pushpath bl word count $fload poppath ;

: ?fload   if fload else bl word drop then ;


\ ------------------------------------------------------------------------------

\ if value doesn't exist, create it.
\ if it does, change it.
: ?value
   >in @ >r
   absent if r> >in !  value
   else
      r> >in !  ' >body !
   then ;

\ if constant doesn't exist, create it.  otherwise do nothing.
: ?constant
   >in @ >r
   absent if r> >in ! constant
   else
      r> drop drop
   then ;


: string,  string, -1 allot ;
: last-xt   last @ name> ;

create pad 1024 allot
: #define   Create 0 parse bl skip string, does> count evaluate ;


\ ------------------------------------------------------------------------------

variable reporting

: report"  \ compiling: ( "ccc<">" -- )  executing: ( -- )
   reporting @ not if [char] " parse 2drop exit then
   postpone s" s" inverse cr type normal " evaluate ;  immediate

: report( ( -- )
   reporting @ not if [char] ) parse 2drop exit then
   inverse cr [char] ) echo-until normal ; immediate

: alert  ( a c ) z$ 0 swap z" Alert" MB_OK MessageBox drop ;
: uncount   drop 1 - ;
: strjoin   2swap <$ $+ $> ;
: input   over 1 + swap accept swap c! ;

fload imove

: ?homepath  ( path c -- path c )
   2dup file-exists ?exit   zhome zcount <$ " \" $+ $+ $>  ;

\ must be a one-liner.
: macro:
   create immediate
   [char] ; parse string,
   does> count evaluate ;
   
   
\ ------------------------------------------------------------------------------
\ Sessions

create session$ 256 allot

: session  ( -- <name> )
   create
   !home pushpath
   including session$ place
   ; \ cr inverse session$ count -name [char] \ scanlast type normal cr ;

: rld
   " empty" evaluate  \ make sure we use the newest one
   zhome SetCurrentDirectory drop
   session$ count included ;

\ ------------------------------------------------------------------------------

: 2,  swap , , ;

\ ------------------------------------------------------------------------------

: cappend   dup >r count + c! 1 r> c+! ;
: s.depth depth ;
: copy,  ( addr length ) ?dup if here swap dup allot move    else drop then ;
: udup   over swap ;
: megs   1024 * 1024 * ;