0 constant ~l1glass

create glass %billboard instance,
glass {
   glass3.image bitmap!
   FX_SCREEN blendmode !
   0.5 0.5 0.5 dspt -> tint!
}

: *glassframe glass dup fg addto { vis on 0 0 0 x 3! 1.0 dspt -> uscale! } ;
: *bossglassframe glass dup fg addto { vis on 0.0 -180.0 0.1 x 3! 1.33 dspt -> uscale! } ;
