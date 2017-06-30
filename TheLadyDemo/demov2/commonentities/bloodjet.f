
%script begets %bloodjet
   var jetang
endp

\ Creates a jet of blood that follows the owner around at the offset specified with AT .
\ Force is decremented for each particle until it reaches 0 and then the jet stops.

: bloodjet ( angle. force. -- )
   [[
      ( angle. force. ) swap jetang !
      perform
      begin

         5 rnd 0 > if
            x 2@ owner @ from
            jetang @ 2.0 - 4.0 rnd +
               over 0.9 1.2 between p*
               2vec ( owner @ >vx 2@ 2+ ) gravity blooddrop
         then

         dup 7.0 < if 7.0 over - 1i 2.0 p* pauses 0.3 - else 1 pauses 0.2 - then

      dup 0.001 <= until
      end
   ]] %bloodjet setoff
;
