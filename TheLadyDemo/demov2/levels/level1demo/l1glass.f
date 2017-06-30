0 constant ~l1glass

create glass %billboard instance,
glass {
   0 z !
   glass3.image bitmap! FX_SCREEN blendmode !
      dspt => 0.5 0.5 0.5 tint!
}

: *glassframe
   glass dup fg addto
   {
      0 0 0 x 3! 0.5 0.5 0.5 dspt -> tint!
      1.0 uscale!
   }
;

: *bossglassframe

   glass dup fg addto {
      \ -1.0 0 pivot 2!
      1.33 1.33 dspt >scale 2! 0.0 -180.0 0.1 x 3!
   }
;
