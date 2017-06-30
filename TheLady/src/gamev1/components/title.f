
\ images
image titlebg.image data/title/Title-Screen-Background.jpg
image gamelogo.image data/title/the lady.png
\ image play.image data/title/menu/play.png
image howtoplay.image data/title/how to play.png
image directions.image data/title/directions.png
image splash.image data\title\splash screen.jpg
image credits.image data\title\Credits One Piece.jpg

\ sounds
stream title.stream data/title/Title Screen Track.ogg
\ sample *ui1* data/title/UI 1.ogg

: screen 0 0 vw vh 2p ;



: howto-controls
   <space> kpressed <enter> kpressed or if
      once *menu* fadeout 3.0 delay clean clear-sounds complete end
   then
;

: howtoplay
   can-pause off
   clean lady/
   screen 0.475 0.5 around at titlebg.image billboard{ 6 +zoom 0.475 0.5 pivot 2! }
   0 0 at yellowfilter50.image billboard{ FX_MULTIPLY blendmode ! }
         %darkcorners one drop
   screen 0.5 0.15 around at
      howtoplay.image billboard{ 0.5 0 pivot 2! FX_SCREEN blendmode ! }
   0 200.0 +at
      directions.image billboard{ 0.5 0 pivot 2! FX_SCREEN blendmode ! }
   0 [[ 2.8 delay howto-controls ]] parallel
   fadein
;



: credits-controls
   <space> kpressed <enter> kpressed or <escape> kpressed or if
      once *menu* fadeout 3 delay complete end
   then
;


: credits
   can-pause off
   clean lady/
   0 0 at credits.image billboard{ }   
   0 0 at yellowfilter50.image billboard{ FX_MULTIPLY blendmode ! }
         %darkcorners one drop
   fadein
   0 [[ 2.8 delay credits-controls ]] parallel
;


0 value titlebgm

\ : title-controls
\    <space> kpressed <enter> kpressed or if
\       *ui1* fadeout 3.0 delay howtoplay
\    then
\ ;

defer title
defer aftertutorial


[[ once *menu* fadeout
   3 delay howtoplay [[ unfade aftertutorial ]] nextup 
   nod
]] menuopt titleplay data\title\menu\play.png

[[ once *menu* fadeout
   0 perform
   3 delay credits [[ title ]] nextup
   nod
]] menuopt titlecredits data\title\menu\credits.png

[[
   0 ExitProcess
]] menuopt titlequit data\title\menu\quit button.png



here cell [array titleplay , titlecredits , titlequit , array] menu titlemenu

%actor ~> %titlemenu
   [[ x 2@ titlemenu >x 2! titlemenu { draw } ]] ondraw !
   start:   titlemenu restart   0 perform titlemenu { actor:step actor:post } ;
endp



: splashscreen
   clean lady/
   screen 0.475 0.5 around at splash.image billboard{ 0.475 0.5 pivot 2! }
   0 0 at yellowfilter50.image billboard{ FX_MULTIPLY blendmode ! }
         %darkcorners one drop
   fadein
   4 [[ delay fadeout 3 delay end complete ]] parallel
;



[[
   0 cam !
   can-pause off
   clean lady/
   screen 0.475 0.5 around at titlebg.image billboard{ 1 +zoom 0.475 0.5 pivot 2! }
   0 0 at yellowfilter50.image billboard{ FX_MULTIPLY blendmode ! }
         %darkcorners one drop
          \ darkcorners.image billboard{ FX_SUBTRACT blendmode ! 0.15 alpha! }

   screen 0.5 0.25 around at gamelogo.image billboard{ 0.5 0.5 pivot 2! FX_SCREEN blendmode ! }
\      0 200.0 +at play.image billboard{ 0.5 0.5 pivot 2! FX_SCREEN blendmode ! }
\      0 [[ 2.8 delay title-controls ]] parallel
   0 200.0 +at %titlemenu one drop
   fadein ]] is title
        

: prelude
   can-pause off
   'complete @ is aftertutorial
   clear-sounds 0 cam !
   looping title.stream snd to titlebgm
   splashscreen
   [[ title ]] nextup
;