\ relies on:
\  pool


2e fconstant 2e

\ These parameters that you can pass to TWEEN et al transform curves internally.

aka noop EASE-IN

:xt EASE-OUT
   negate 1.0 + >r swap over + swap negate r> ;

:xt EASE-IN-OUT
  dup 0.5 < if 2* swap 2/ swap
    else swap 2/ rot over + -rot swap 0.5 - 2* [ ease-out compile, ] then ;

\ eases - all these describe the "in" animations
( startval ratio. change. -- val )

\ exponential formula: c * math.pow(2, 10 * (t / d - 1)) + b;
\ quadratic formula: c * (t /= d) * t + b


pstruct %tween
   [i
   noop: 'in/out
   noop: '!
   noop: 'ease
   var interval
   var frames
   var change
   var startval
   var addr
   var en
   var curval

   : addr!   addr @ '! @ execute ;
   
   i]

endp

500 %tween pool tweens

%tween innards

   : tween:step
      interval @ curval +!
      startval @ change @ curval @ 'in/out @ execute 'ease @ execute addr!
      frames --
      frames @ 0< if
         startval @ change @ + addr! 
         en off struct tweens pool-return
      then    
   ;

   : (tween) ( 'ease 'in/out addr startval change #frames '! -- )
      tweens pool-one =>
      '! !   1 max 1.0 over / interval ! frames ! change ! startval ! addr ! 'in/out ! 'ease !
      en on   0 curval ! ;
   
   : tween ( 'ease 'in/out addr destval #frames -- )
      >r   over @ swap over -   r> ['] ! (tween) ;
   
   : ctween ( 'ease 'in/out addr destval #frames -- )
      >r   over c@ swap over -  r> ['] c! (tween) ;
   
   : htween ( 'ease 'in/out addr destval #frames -- )
      >r   over h@ swap over -  r> ['] h! (tween) ;

   : clear-tweens tweens reset-pool ;
   
   : process-tweens [[ s! en @ -exit tween:step ]] tweens each ;
   
previous

:xt LINEAR        p* + ;
:xt EXPONENTIAL   1.0 - 10.0 p* 2e p>f f**  f>p p* + ;
:xt SINE          90.0 p* 90.0 - psin 1.0 + p* + ;
:xt QUADRATIC     dup p* p* + ;
:xt CUBIC         dup p* dup p* p* + ;
:xt QUARTIC       dup p* dup p* dup p* p* + ;
:xt QUINTIC       dup p* dup p* dup p* dup p* p* + ;
:xt CIRCULAR      dup p* 1.0 swap - psqrt 1.0 - p* negate + ;
: (overshoot)     >r dup dup r@ 1.0 + p* r> - p* p* p* + ;
:xt OVERSHOOT     1.70158 (overshoot) ;


