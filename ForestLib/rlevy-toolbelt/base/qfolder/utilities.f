\ Copyright 2014 - Leon Konings - Konings Software.
\ Created for Roger Levy

[DEFINED] win32-constants constant WINDOWS?

\
\ CASE SENSITIVITY
\


\ Changes string in z-addr to uppercase in place.
: z-uppercase  ( z-addr -- z-addr ) dup  begin dup c@  dup while  upper over c!  1+ repeat 2drop ;

\ Changes string in c-addr to uppercase in place.
\ An assembler uppercase named upcase, existed already :(
\ : uppercase  ( c-addr u -- c-addr u )
\    dup 0> if 2dup 2>r  bounds do i c@ upper i c! loop  2r> then ;

\ Case insensitive compare.
: uppcompare  ( c-addr1 len1 c-addr2 len2 -- )
   dup>r  pad zplace  pad r@ + 1+ zplace
   pad r> + 1+ zcount  2dup upcase
   pad zcount  2dup upcase
   compare ;

\
\ PATH
\

: absolutepath?  ( c-addr u -- flag )
   over c@ [char] / = if 2drop true exit then
   2 >= if 1+ c@ [char] : = then ;
   
WINDOWS? [if] char \ [else] char / [then] constant pathseparator
   
create spathseparator 1 c, pathseparator c,

: change-pathseparator  ( char -- char' )
   dup [char] / =  over [char] \ =  or  if drop pathseparator then ;

\ Changes string in z-addr to use correct pathseparators in place.
: z-correctpath  ( z-addr -- z-addr )
   dup  begin dup c@  dup while  change-pathseparator over c!  1+ repeat 2drop ;

\ Changes string in z-addr to use correct pathseparators in place.
: correctpath  ( c-addr u -- c-addr u )
   dup 0> if 2dup 2>r  bounds do i c@ change-pathseparator i c! loop  2r> then ;
   
\ Changes string in z-addr to use correct pathseparators and uppercase in place.
: uppercorrectpath  ( c-addr u -- c-addr u )
   dup 0> if 2dup 2>r  bounds do i c@ upper change-pathseparator i c! loop  2r> then ;
   
: pathcompare  ( c-addr1 len1 c-addr2 len2 -- )
   dup>r  pad zplace  pad r@ + 1+ zplace
   pad r> + 1+ zcount uppercorrectpath
   pad zcount uppercorrectpath
   compare ;

: partialpath?  ( c-addr u -- flag )
   2dup absolutepath? if drop zero exit then
   pathseparator scan 0<> nip ;

\
\ FILE EXISTS
\

256 buffer: zabortmessage

: file-exists?  ( c-addr u -- flag )
   s" File: " zabortmessage zplace
   2dup zabortmessage zappend
   s"  does not exist!" zabortmessage zappend
   FILE-STATUS nip dup 0= swap     ( flag ior )
   zabortmessage zcount ?ABORT    ( fileid ) \ abort if ior = 0
;

: absolutepath-exists  ( c-addr u -- c-addr/u/true | false )
   2dup absolutepath? if file-exists else drop zero then ;
   