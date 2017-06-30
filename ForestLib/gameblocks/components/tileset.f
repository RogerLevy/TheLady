
0 value tb
: tb!   to tb ;


pstruct %tileset
   [[ create-field does> @ tb + ]] is ifield
   [i var img i]
   %box inline tile
      
\   var bankcols
\   var bankrows
   
   \ with DRAW-TILE, instead of giving an index you give an x and y.
   \ this way tilesets can be any size, even mixed sizes in the same image,
   \ and you can do weird things with unaligned offsets.
   : draw-tile  ( x y -- )
      tile dims part! img @ blitpartsrt ;

   \ this one doesn't set the part's dimensions repeatedly
   : draw-another-tile ( x y -- )
      partxy! img @ blitpart ;
   
\   : !bankcols   img @ image.w tile width / bankcols ! ;
\   : !bankrows   img @ image.h tile height / bankrows ! ;
            
   : tileset.image   .img @ ;
   : tileset.width   .img @ image.size drop ;
   : tileset.height   .img @ image.size nip ;

   : init-tileset ( image tilew tileh tileset -- )
      tb!   tile dims!   img ! ;
      
   : tileset ( image tilew tileh -- <name> )
      create %tileset instance init-tileset ;

   macro: packtile ( x y -- n ) 16 << or ;
   
   macro: unpacktile ( n -- x y )  lohi ;

   
endp

