\ ==============================================================================
\ ForestLib > GameBlocks
\ 2D arrays
\ ========================= copyright 2014 Roger Levy ==========================

\ relies on:
\  IMOVE IFILL /ARRAY


: 2array,   ( w h itemsize )
   >r 2dup * r> here => arrayheader, swap cols 2! ;

: 2array>   ( w h itemsize )
   >r 2dup * r> here => arrayheader, swap cols 2! ;


: [][]   ( col row 2array -- addr )
   dup >r >cols @ * + r> [] ;

: dims   >cols 2@ ;

\ src and dest item sizes must be the same, and CELL aligned
: 2move   ( col row src col row dest cols rows )
   third >itemsize @ cell/ locals| item rows cols dest drow dcol src srow scol |

   \ todo: clipping

   rows 0 do
      scol srow i + src [][]
      dcol drow i + dest [][]  item cols * imove
   loop ;

\ for when item size is CELL only
: 2fill  ( value col row cols rows dest )
   locals| dest rows cols row col val |

   \ todo: clipping

   rows 0 do
      col row i + dest [][] cols val ifill
   loop ;

: 2entire
   => 0 dup cols 2@ struct ;

: 2clear ( dest )
   0 swap 2entire 2fill ;


: .cells  ( 2array )
   =>
   rows @ 0 do
      cr
      cols @ 0 do
         i j struct [][] @ 9 h.0 space
      loop
   loop ;
