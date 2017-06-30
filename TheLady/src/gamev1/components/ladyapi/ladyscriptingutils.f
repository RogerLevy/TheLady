
\ ----------------------------------------------------------------------
\ Common scripts

: slowfade   cflags off   0 perform   -0.004 alpha+!   alpha@ 0= when    end ;

: +zoom   perform  dup dup scale 2+! ;

   %script ~> %fadescript
      var onend
      var target \ actor
      var destval
   endp

: fade   ( speed. onend-xt -- )
   me [[
      target ! onend !
      ( speed. ) perform
         target @ { dup alpha+! alpha@ } dup 0 = swap 1.0 = or when onend @ target @ { execute } end
   ]] %fadescript setoff
;

: fadeto   ( speed. to. onend-xt -- )
   me [[
      target ! onend ! destval !
      ( speed. ) perform
         dup 0< if
            perform target @ { dup alpha+! alpha@ } destval @ <= when onend @ destval @ target @ { alpha! execute } end
         else
            perform target @ { dup alpha+! alpha@ } destval @ >= when onend @ destval @ target @ { alpha! execute } end
         then
   ]] %fadescript setoff
;

: heavens   view 0.01 0.99 between 0 around ;
