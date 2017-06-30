\ ==============================================================================
\ ForestLib
\ Quicksort
\ ========================= copyright 2014 Roger Levy ==========================

\ plugin 
\ credit for forth code: wil baden
\ source: http://en.literateprograms.org/quicksort_(forth)

\ can support comparison of indirect values (such as the z coordinate of a entity) by reassigning ( sort@ ) to
\   a bit of code that will fetch the field of the object in the list.

\   usage:  :noname  ( addr -- n ) <code>  ; is sort@
\           <cell array> sort


package quicksorting


defer comparison ( a b -- flag )   ' < is comparison
\ if flag returned is true, then a is less than b.

private

: mid ( l r -- mid ) over - 2/ -cell and + ;

: exchange ( addr1 addr2 -- ) dup @ >r over @ swap ! r> swap ! ;

: part ( l r -- l r r2 l2 )
  2dup mid @ ( sort@ ) >r ( r: ppivot )
  2dup begin
    swap begin dup @ ( sort@ )  r@ comparison while cell+ repeat
    swap begin r@ over @ ( sort@ ) comparison while cell- repeat
    2dup <= if 2dup exchange >r cell+ r> cell- then
  2dup > until  r> drop ;

: (cellsort) ( l r -- )
  part  swap rot
  2dup < if recurse else 2drop then
  2dup < if recurse else 2drop then ;

public

: cellsort ( addr count comparison-xt -- )
   is comparison
   dup 1 > if 1 - cells over + (cellsort) else 2drop then ;

end-package