# ADA-Othello
## Othello board game made in ADA programming language
This is a version of the game Othello made in the ADA programming language. I made this as an exercice in recursion,
im preperation of some upcoming labwork. 

While I'm sure the code could be optimised and be made more readable, I'm leaving it as is
because this was my first project and I do not want to tamper with it any more.
If I improve it it would no longer have the charm it has today as my first ever project.

## HOW TO COMPILE
As ADA isn't the most common programming language I'm adding an installation guide for the compiler

### Requirements and dependencies
- Linux (I'm using Fedora)
- GNAT ADA compiler
- ADA_Text.IO (built in ADA, will be installed with the compiler)

### Installing the compiler
On fedora you install gcc-gnat compiler with this command  <br>
$ sudo dnf install gcc-gnat

### Compiling and running the code
$ gnatmake ./othello.adb <br>
$ ./othello.adb

