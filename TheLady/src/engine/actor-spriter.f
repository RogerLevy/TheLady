scmlanimator open-package public

%actor reopen

   : animspeed!   ( speed. -- ) scmlanm speed! ;
   : animspeed@   ( -- speed. ) scmlanm speed@ ;
   : animpos!     ( pos -- ) scmlanm pos! ;
   : animpos@   ( -- pos ) scmlanm pos@ ;
   \ : animdata!  ( scmlobject -- ) scmlanm >obj ! ;
   \ : animate!  ( animation -- ) scmlanm -> animate!   1.0 animspeed! ;
   : animate   ( entity# animation# -- ) scmlanm -> animate   1.0 animspeed! ;
   : onanimloop! ( xt -- ) scmlanm >onloop ! ;
   \ : pace      ( entity# animation# speed. -- )  animspeed!   scmlanm -> animate ;

   : (flip)     dspt >scale >x @ negate dspt >scale >x ! ;
   : ?flipfix   flipfix @ if (flip) r> call (flip) then ;

   : actor:spriter
      scmlanm >OBJ 2@ and -exit
      vis @ if
         blendmode @ colorfx   x 3@ scrolled at   ?flipfix   scmlanm dspt tdraw
      then
      scmlanm -> step ;

   ' actor:spriter is actor:draw

   previous

endp



\ TODO: i'd like to make it possible to as an option *conditionally* change the animation
\   only if it's not the current animation.  (this option gets reset with each call to ANIMATE and ANIMATE! )
: animation  ( animdata -- <name> <path> )
   create dup use-scml namespec find-animation , , does>
   2@ scmlanm => obj ! animate! 1.0 animspeed! ;

end-package