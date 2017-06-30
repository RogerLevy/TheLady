ForestLib
For: SwiftForth/Win

<roger.levy@gmail.com>
@kidfingers

Released under the Mozilla Public License 2.0. (Free to use for any purpose
commercial or otherwise, but keep the library itself open-source and let me know
about fixes and improvements. You are not required to distribute consumer
executable files with source code.)



Log
=====

7/8/2014     Initial publication



Introduction
============

This is my personal code library, including toolbelt and graphics. I make games,
so it's geared towards doing that. (2D games for now.) There are probably a
bunch of components and modules that are useful in other domains. These are the
files I used to build the game The Lady. Note that it is not a game engine, just
some pieces to make it easier to build one. 

Compliance Disclaimers
----------------------

It modifies ANS94 standard words in a non-backwards-compatible way. For now, if
you need ANS code files you've already written to compile alongside, load them
before loading this stuff. Other than that, basically when you use this package,
you use my dialect, albeit which redefines only a few words (such as 2@).

Alternatively you might create a side-stepping wordlist that aliases the words
required by your code to their ANS-compliant originals.

Later on, things ought to be made possible to be tucked away into a wordlist, or
provide some form of the previously stated workaround. I'm working on ideas on
how to make using standard ANS and multiple toolbelts a viable thing.

This package assumes case-insensitivity.



Setup
-----

Unzip the folder (not just the contents) to your project directory. Whichever
folder you place it in will from here on be your "root folder". Projects should
be placed here alongside the library folder.




Purpose
-------

The primary purpose of publishing this code is not to get other people to adopt
my code as a kind of higher-level standard; actually I am publishing it just to
have something online to refer people to when I mention concepts from it. So
this is more about ideas than code. If people try it, use it, modify it, great,
but it's well-known that every Forth programmer has strong personal preferences
about the way they do things. "The Standard", a.k.a. Forth94/ANS94/ANS
Forth/Forth200x, does not yet have a standard way to allow different author's
dialects to interact easily.

Think of this as an evolving example. It should improve steadily
over time. For some info on versioning see the section below.




Some conventions regarding project structure
============================================

Session Files
-------------

session.f is the entry point for *testing and development*. It sets up the
context needed on startup to test and work on the library. You can copy code
from this into your own chapter loader and add any other component you need to
the load order. I prefer to use session.f files to tuck away "assumptions", e.g.
GILDed stuff that should not be reloaded when you EMPTY.

I use multiple session files to have multiple projects coexisting in the same
folder tree. For example in one project I have session-game.f and
session-demo.f. I've provided an example session file for a typical game
project.


FLOAD
-----

FLOAD is a custom word I use instead of INCLUDE. I created it to allow folders
to be freely moved around, renamed, and reorganized, to allow code to be more
modular (it changes the current folder to the file's containing folder, unlike
INCLUDE), and to make interactive testing more convenient. It first searches
from the current folder, and then it searches from the "home" folder (set by
!HOME) recursively, and if the file is still not found it searches from the
"root folder" (set by !ROOT) recursively, excluding the home folder. The root
folder is meant to point to your codebase (projects folder) and the home folder
is meant to point to the current project folder. FLOAD intelligently skips some
folders (and this can be extended: see file-search.f). 

FLOAD will be enhanced at some point to search for files-within-relative-paths,
to protect against filename collisions when individually loading optional files
from different components, different toolbelts, different authors, etc. For
example: "FLOAD ForestLib/gameblocks/options/animator" will find the correct
file within ForestLib, wherever it finds the file first based on the search
order. Right now your best bet is to copy optional files into your project. You
are also free to copy entire components into project src folders to be able to
freely modify them on an application-basis, though, I recommend instead making a
new version of the files you modify, in their original folders, and appending a
personal identifier and version number to the file to prevent confusion. This is
totally optional and only a recommendation.

I currently don't use any means of automatically protecting against multiple
loads of the same file. Dependencies are documented externally (e.g. in this
file) and need to be loaded in the right order by your chapter loader (in my
case, session files). I will add my own way to do this, built around FLOAD.


Versioning
==========

Whenever a file includes non backwards-compatible changes, it gets an
incremented number. All versions of all files will coexist in the package.

Version #'s will be documented between brackets: [n]


Component descriptions
======================


Component     | Description                               | Dependencies
--------------|-------------------------------------------|-------------------------------------------------

allegro5        Allegro 5.0 and 5.1 bindings                rlevy-toolbelt

opengl-lite     OpenGL bindings (selected)                  rlevy-toolbelt

rlevy-toolbelt  Nonstandard extensions, A, fixed-point,     none
                floating point helpers, RND, FLOAD,
                structs, OOP (Prototype), arrays, regions
                
                [2] Removes some unused stuff &             none
                changes some Prototype semantics

gameblocks      Game programming stuff                      rlevy-toolbelt, allegro5, opengl-lite
                IO wrappers for Allegro5
                
                [2] WIP (significant API changes)           rlevy-toolbelt[2]

sprig           Software bitmap manipulation, selected      rlevy-toolbelt
                SDL bindings.
                
sdl             SDL bindings, DevIL bindings, sdl_image     rlevy-toolbelt, opengl-lite
                bindings, and helper words 

brute4x         XML support (incomplete & buggy)            rlevy-toolbelt

project-        This provides an example of the boiler      See ProjectTemplate\session-game.f
 template       plate for an application.