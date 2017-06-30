\ ==============================================================================
\ ForestLib
\ External library binding utilities
\ ========================= copyright 2014 Roger Levy ==========================

package cdefines

\ Structs
\ --------------------------------------------------

\ [ wordlist , size , ]
: cstruct
   get-current
   wordlist Create here >r dup , 0 , +order definitions r> 0
   immediate does> @ dup +order >r bl word count evaluate r> -order ;

: end-cstruct
   previous swap cell+ !
   set-current ;

: ?+align  ( offset fieldsize -- offset fieldsize )
   over 0= if exit then
   2dup mod if dup >r 2dup mod - + r> then
   ;

: ?+   over 0= if + else 2dup mod 0= if + then then ;


: cfield  ( offset fieldsize -- offset )
   Create over , + does> @ + ;

: afield  ( offset fieldsize -- offset )
   ?+align Create over , ?+ does> @ + ;

: datatype
   Create , does> @ afield ;

\ We'll see if this is ok
: structfield
   ' >body cell+ @ cfield ;

AKA CStruct Struct
AKA End-CStruct End-Struct

: sizeof
   ' >body cell+ @ ;

\ --------------------------------------------------

\ Enum types
: enumtype   Create , does> drop 4 cfield ;

\ Standard C types
1 datatype byte
1 datatype cchar
1 datatype uint8
1 datatype int8
2 datatype short
2 datatype ushort
2 datatype int16
2 datatype uint16
4 datatype int
4 datatype int32
4 datatype uint
4 datatype uint32
4 datatype float
4 datatype int*
4 datatype uint*
4 datatype float*
4 datatype void*

4 Datatype Long
4 Datatype uLong
4 Datatype DWord
8 Datatype PointL

2 Datatype CWord \ <- ???

4 Datatype COLORREF
: union   ' >body cell+ @ Max   bl word drop ;

public

: build   ' Create >body cell+ @ /allot ;

end-package
