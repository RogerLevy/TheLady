\ player emotions
0
   enum calm
drop
\ constant #feelings

\ enemy emotions
calm 1 +
   enum agitated
drop

%actor reopen
   var feeling        \ emotional state
   : do-emotion ( -- )
      flipfix off
      feeling @ ( 0 [ #feelings 1 - ]# clamp ) cells + @ execute  ;
   : emotion   create does> do-emotion ;
   : emote   ( constant actor -- ) { feeling ! idle } ;
endp
