\ player emotions
0
   enum calm
   enum nervous
   enum panicky
   enum tired
   enum agitated
drop

%actor reopen
   var feeling        \ emotional state #, for commonality
   var emo            \ vtable, prototype-dependent
   var emofam         \ points to a table for generic "mood changing"


   \ use for different prototypes
   : emotable   ( n -- <name> )
      create here emo ! vtable,
      [[ @ emo @ ]] emo @ set-vtable-fetcher ;

   : emofamily  ( emotable -- <name> )
      create stack,
      
   : emostate   ( emotable feeling -- <name> )
      create here >r dup ,
       r@ -rot swap [] !




      does> dup @ feeling ! swap
      \   create dup 1 + cells , 1 + does> flipfix off @ feeling @ + @ execute ;


   : emote   ( emotion actor -- ) feeling ! idle ;

   : emostate    ( feeling ) create , does> dup @ feeling ! swap cell+ emo ! ;

endp
