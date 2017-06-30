%vec2d object offset    \ integer
   
: offset+   offset xy 2+ ;
: offset-   offset xy 2- ;
: offset-(p)   offset xy 2s>p 2- ;

: at   offset+ 2?p p>f allegro-pen .y sf!  p>f allegro-pen .x sf! ;
: +at  2?p p>f allegro-pen .y sf+!  p>f allegro-pen .x sf+! ;
: at@  allegro-pen .x sf@ f>s allegro-pen .y sf@ f>s offset- ;
: at@p  allegro-pen .x sf@ f>p allegro-pen .y sf@ f>p offset-(p) ;
: at+  allegro-pen .x sf@ f>s allegro-pen .y sf@ f>s 2+ ;

: thick   p>f allegro-thickness f! ;


\ call this before calling BLITSRT etc
: transformed ( transform -- )
   with
   scale xy 2p>f 2sfparms allegro-scale xy!
   s@ angle p>f allegro-angle sf!
   tint rgba 4p>f 4sfparms allegro-color 4! ;

: untransformed
   1e 1e 2sfparms allegro-scale xy!
   0e allegro-angle sf!
   1e 1e 1e 1e 4sfparms allegro-color 4! ;

: pcolor ( r. g. b. a. -- )
   allegro-color a!> >r >r >r p>f sf!+ r> p>f sf!+ r> p>f sf!+ r> p>f sf!+ ;
   
: pcolor@ ( -- r. g. b. a. )
   allegro-color 4@ 4f>p ;
