\ ==============================================================================
\ ForestLib
\ Some floating point conversion routines
\ ========================= copyright 2014 Roger Levy ==========================

\ 4/25/13

[defined] float_tools [if] \\ [then] : float_tools ;

: 3c@f   ( a-f:nnn ) a!> c@+ c>f c@+ c>f c@+ c>f ;
: 4c@f   ( a-f:nnnn ) a!> c@+ c>f c@+ c>f c@+ c>f c@+ c>f ;
: 4h@f   a!> h@+ s>f h@+ s>f h@+ s>f h@+ s>f ;
: 4@f    a!> @+ s>f @+ s>f @+ s>f @+ s>f ;
: 4sf@   a!> sf@+ sf@+ sf@+ sf@+ ;
: 4s>f   >r >r swap s>f s>f r> s>f r> s>f  ;
