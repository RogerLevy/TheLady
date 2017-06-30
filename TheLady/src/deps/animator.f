
\ animation format:
\     (frame data - default is 4 cells for bitmap source region x,y,w,h)
\     ... more frames ...
\     -1, address (end, automatically loops to address )

\ frame size can easily be changed by setting FRAMESIZE (there really isn't a need to subclassspeed)

pstruct %animator
   0.25 var: animator-speed   
   var animptr
   var animctr
   var looped
   4 cells var: framesize
endp

: animstep
   animptr @ -exit
   looped off
   animator-speed @ animctr +!
   begin animctr @ 1.0 >= while
      animctr @ $0000FFFF and animctr !
      framesize @ animptr +!
      animptr @ @ -1 = if
         looped on
         animptr @ cell+ @ animptr !
      then
   repeat ;

: play-animation   ( animation ) animptr ! looped off ;
: stop-animating   animptr off looped off ;