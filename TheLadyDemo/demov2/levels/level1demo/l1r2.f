\ ---------------------------------------------------------------------------
\ Barbwire room


absent %barbwirewall ?fload barbwirewall

500.0 constant threshl
4096.0 500.0 - constant threshr
2048.0 constant midthresh

3.0 1.0 %l1baseroom room: l1r2   Barbwire room


%script begets %l1r2camscript
   var broken
endp

%l1r2camscript script

start:
   0 broken !  hide-doors
   
   post
   %barbwirewall typecount ?exit

   cam @ threshl <= if
      1 broken or!
      broken @ 3 = if
         post   cam @ midthresh >= if
            reveal-doors end
         then
         exit
      then
   then

   cam @ threshr >= if
      2 broken or!
      broken @ 3 = if
         post   cam @ midthresh <= if
            reveal-doors end
         then
         exit
      then
   then
;


[layout barblayout
   vw 3 * 2 /
      dup 1000 + , 0 , %barbwirewall , .. ,
      dup 600 - , 0 , %barbwirewall , .. ,
      dup 2000 + , 0 , %barbwirewall , .. ,
      dup 2000 - , 0 , %barbwirewall , .. ,
\      dup 2400 + , 0 , %barbwirewall , .. ,
\      dup 2400 - , 0 , %barbwirewall , .. ,
   drop
layout]


roomdef defineroom
2944.0 1152.0 startpos 2!
construct:
   \ ambience
   l1-defaultbgm

   \ bg/fg
   l1-defaultbgfg

   \ objects
   0 0 vw vh 2p 0.15 1.0 around 2dup at   [[ north ]] 1 *doors
                             boundaries 0.85 1.0 around 2+ at   [[ north ]] 1 *doors

   barblayout
   
   \ scripts
   %l1r2camscript one script1 !
   make-glass-start-falling
   l1r2:| player emote
;
