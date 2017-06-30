\ images
image titlebg.image data/title/Title-Screen-Background.jpg
image gamelogo.image data/title/menu/the lady.png
image play.image data/title/menu/play.png
image howtoplay.image data/title/menu/how to play.png
image directions.image data/title/menu/directions.png

\ sounds
stream title.stream data/title/Title Screen Track.ogg
sample *ui1* data/title/UI 1.ogg



: howto-controls
   <space> kpressed <enter> kpressed or if
      *ui1* fadeout 3.0 delay clean clear-sounds complete end
   then
;




: screen 0 0 vw vh 2p ;

\ inverted bg version
: howtoplay
   clean lady/ fadein
   view 0.475 0.5 around at titlebg.image billboard{ 0.475 0.5 pivot 2! 1.6 uscale! FX_INVERSE blendmode !
      me atop %darkness one { 0.25 alpha! } }
   view 0.5 0.15 around at howtoplay.image billboard{ 0.5 0 pivot 2! FX_SCREEN blendmode ! }
   0 200.0 +at directions.image billboard{ 0.5 0 pivot 2! FX_SCREEN blendmode ! }
   0 0 at yellowfilter75.image billboard{ FX_MULTIPLY blendmode ! }
          %darkcorners one drop
   0 [[ 3.0 delay howto-controls end ]] parallel
;

: howtoplay
   clean lady/ fadein
   screen 0.475 0.5 around at titlebg.image billboard{ 6 +zoom 0.475 0.5 pivot 2! }
   0 0 at yellowfilter50.image billboard{ FX_MULTIPLY blendmode ! }
         %darkcorners one drop
   screen 0.5 0.15 around at
      howtoplay.image billboard{ 0.5 0 pivot 2! FX_SCREEN blendmode ! }
   0 200.0 +at
      directions.image billboard{ 0.5 0 pivot 2! FX_SCREEN blendmode ! }
   12345 . 
   0 [[ 2.8 delay howto-controls ]] parallel
;



0 value titlebgm

: title-controls
   <space> kpressed <enter> kpressed or if
      *ui1* fadeout 3.0 delay howtoplay 
   then 
;


: title
   clear-sounds clean 0 cam ! lady/ fadein
   looped title.stream snd to titlebgm
   screen 0.475 0.5 around at titlebg.image billboard{ 6 +zoom 0.475 0.5 pivot 2! }
   0 0 at yellowfilter50.image billboard{ FX_MULTIPLY blendmode ! }
         %darkcorners one drop
          \ darkcorners.image billboard{ FX_SUBTRACT blendmode ! 0.15 alpha! }
   
   screen 0.5 0.25 around at gamelogo.image billboard{ 0.5 0.5 pivot 2! FX_SCREEN blendmode ! }
   0 200.0 +at play.image billboard{ 0.5 0.5 pivot 2! FX_SCREEN blendmode ! }
   0 [[ 2.8 delay title-controls ]] parallel
;
