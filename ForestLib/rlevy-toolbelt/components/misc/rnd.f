\ ==============================================================================
\ ForestLib
\ Random number generator
\ ========================= copyright 2014 Roger Levy ==========================

variable bud

: rand  ( -- u )  bud @  3141592621 *  1+  dup bud ! ;
: rnd   ( n -- u )  rand um* nip ;
: /rnd ( -- ) dcounter drop bud ! ;

/rnd
