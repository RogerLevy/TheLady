image rain.image data/ame/rainsingle.png

800 %particle pool rains1
400 %particle pool rains2
variable rain
0 value rain1
0 value rain2

: cull-rain
   [[ struct >y @ vh 1p 400.0 + > if particle:delete then ]] dup rains1 all-particles
                                                                 rains2 all-particles ;

%actor ~> %rain
   var ppool
   1 var: rainfreq
   stays on

   : raindrop   1 ppool @ pool-free? -exit  0 vy @ 0 0 rain.image -1 ppool @ pool-one init-particle ;

   start:
      0 perform
      rainfreq @ 0 do cam @ 40.0 - z @ p* dup vw 1p + 80.0 + between -400.0 at raindrop loop
      ppool @ step-particles 
   ;

   ondelete:   [[ particle:delete ]] ppool @ all-particles ; \ ppool @ reset-pool    

   [[ vis @ -exit cull-rain FX_NORMAL colorfx ppool @ draw-particles ]] ondraw !

endp

%actor ~> %rainmgr
   stays on
   start: 0 perform rain @ dup rain1 { dup vis ! en ! } rain2 { dup vis ! en ! }  ;
endp

: init-rain
   [[ s! [[ struct rains1 pool-return ]] particle:delete! ]] rains1 each
   [[ s! [[ struct rains2 pool-return ]] particle:delete! ]] rains2 each
   %rain one dup to rain1 be   rains1 ppool !   40.0 vy !   =bgrain priority !    0.5 z !   3 rainfreq !   0.9 dspt -> alpha!
   %rain one dup to rain2 be   rains2 ppool !   65.0 vy !   =fgrain priority !    1.1 z !   2.0 dup dspt >scale 2!
   %rainmgr one drop ;

init-rain
rain off
