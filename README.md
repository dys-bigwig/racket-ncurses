# racket-ncurses
Heavily WIP and therefore subject to change. However, feel free to use what is currently supported to your heart's content. Feedback is greatly appreciated. Requires libncurses5.

First, install this package by typing "raco pkg install https://github.com/dys-bigwig/racket-ncurses.git" into your terminal.

Now you can start using the libary by adding ```(require ncurses)``` to the top of your project.\
Here's the (admittedly silly) example from test.rkt to give an example of what you can currently do:
```
#lang racket
(require ncurses)

(define (test)
  (noecho!)
  (curs-set 0)
  (border)
  (define-values (screen-height screen-width)
    (getmaxyx))
  (init-pair! 1 COLOR_WHITE COLOR_RED)
  (let ([ch (getch)])
  (addstr (format "YOU PRESSED ~a!" ch)         
            (color-pair 1) A_BOLD A_UNDERLINE
            #:y (quotient screen-height 2)
            #:x (quotient (- screen-width
                             (string-length "YOU PRESSED ~a!"))
                          2)))
  (define foowin (newwin 10 10 4 4))
  (addstr "WIZARDS" #:win foowin)
  (refresh)
  (getch #:win foowin)
  (delwin foowin))

(with-ncurses test)
```
The ```with-ncurses``` function is used at the start of your program to automatically initialise ncurses - if you've used the Python api for ncurses before, it serves the same purpose as its ```wrapper``` function. You pass your main function as a callback, and it will be run after the curses environment has been initialised. It takes ```#:start-color?``` as a keyword argument; however, color will be enabled by default, so you need only use this argument if you wish for color to be disabled, in which case you would pass #f as the argument.

Though the usage of curses itself is somewhat outside the scope of this readme, here is a brief explanation of the functions used, with a particular emphasis upon those elements which are racket-specific:
* ```getmaxyx``` - returns the height and width (maximum y and x values) of the screen as values. Due to the result being returned as values, ```define-values``` is best used for binding its results.
* ```init-pair!``` - used to initialise a pair of colors for use as a text attribute. The first color is the foreground (i.e. the color of the text itself) and the second colour is the background. The list of predefined colors is:
```
COLOR_BLACK
COLOR_RED
COLOR_GREEN
COLOR_YELLOW
COLOR_BLUE
COLOR_MAGENTA
COLOR_CYAN
COLOR_WHITE
```
* ```getch``` - reads a single character. You can use the keyword argument ```#:win``` to read from specific window. If no argument is given, then stdscr (the default screen which is initialised automatically using ```with-curses```) will be used.
* ```addstr``` - draws a string to the chosen window (default is stdscr). The keyword arguments ```#:y```, ```#:x```, and ```#:win``` can be used to specify the location the string is to be drawn, and the window to which it is to be drawn. The default x and y positions are the current cursor position. Any number of attributes - such as bold, underline... and a single color-pair - can be provided after the string argument as a rest-arg. In the above example, ``(color-pair 1)``, ```A_BOLD``` and ```A_UNDERLINE``` are given as attributes to be apllied to the string. The list of text attributes is:
```
A_NORMAL       
A_STANDOUT     
A_UNDERLINE    
A_REVERSE      
A_BLINK        
A_DIMMED       
A_BOLD         
A_ALTCHARSET   
A_INVISIBLE    
A_PROTECT      
A_HORIZONTAL   
A_LEFT         
A_LOW          
A_RIGHT        
A_TOP          
A_VERTICAL
```
* ```addch``` - same as addstr, but adds a single Racket char (e.g. ```#\A```)
* ```addchstr``` - similar to addstr, but with some difference which are outside the scope of this readme. For one, it does not advance the cursor, whereas addstr does.
* ```newwin``` - creates a new window, taking the following arguments: lines, columns, x-origin, y-origin.
* ```delwin``` - deletes a window.
* ```refresh``` - refreshes the window given as #:win kwarg, with the default being stdscr. 
* ```echo! and noecho!``` - toggles whether typed text is echoed back to the user or not.
* ```curs-set``` - toggles cursor visibility, with 0 being invisible and 2 being bold.
* ```nodelay``` takes #f or #t, setting getch to be blocking or non-blocking respectively.

If you're working on a particular window (other than stdscr) and you don't want to keep providing the #:win kwarg over-and-over again, you can use parameterize (https://docs.racket-lang.org/guide/parameterize.html) to set stdscr to your window of choice within the parameterize block.
