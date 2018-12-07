#lang racket/base
(require ffi/unsafe
        ffi/unsafe/define)
(define-ffi-definer define-curses (ffi-lib "libncurses" '("5" #f)))
(define-ffi-definer define-panel (ffi-lib "libpanel" '("5" #f)))
;couldn't get it to work without putting a specific version number
;figure out how to fix so as to use available version
(define _WINDOW-pointer (_cpointer 'WINDOW))

;ATTRIBUTE BITMASK CONSTANTS;
; is there a way to define these as bits so it's clearer what they represent?
; or, even better, a way to piggback off of curses constant definitions?
(define A_NORMAL 0)
(define A_STANDOUT 65536)
(define A_UNDERLINE 131072)
(define A_REVERSE 262144)
(define A_BLINK 524288)
(define A_DIMMED 1048576)
(define A_BOLD 2097152)
(define A_ALTCHARSET 4194304)
(define A_INVISIBLE 8388608)
(define A_PROTECT 16777218)
(define A_HORIZONTAL 33554432)
(define A_LEFT 67108864)
(define A_LOW 134217728)
(define A_RIGHT 268435456)
(define A_TOP 536870912)
(define A_VERTICAL 1073741824)

;CURSES FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ADDCH FUNCTIONS;
;; DONE ;;
(define-curses addch (_fun _long -> _int))
(define-curses waddch (_fun _WINDOW-pointer _long -> _int))
(define-curses mvaddch (_fun _int _int _long -> _int))
(define-curses mvwaddch (_fun _WINDOW-pointer _int _int _long -> _int))

;ADDSTR FUNCTIONS
(define-curses addstr (_fun _string -> _int))
(define-curses addnstr (_fun _string _int -> _int))
(define-curses waddstr (_fun _WINDOW-pointer _string -> _int))
(define-curses waddnstr (_fun _WINDOW-pointer _string _int -> _int))
(define-curses mvaddstr (_fun _int _int _string _int -> _int))
(define-curses mvaddnstr (_fun _int _int _string _int -> _int))
(define-curses mvwaddstr (_fun _WINDOW-pointer _int _int _string -> _int))
(define-curses mvwaddnstr (_fun _WINDOW-pointer _int _int _string _int -> _int))

;COLOUR/GRAPHICAL FUNCTIONS
(define-curses assume_default_colors (_fun _int _int -> _int))
(define-curses start_color (_fun -> _int))
(define-curses attroff (_fun _int -> _int))
(define-curses attron (_fun _int -> _int))
(define-curses wattroff (_fun _WINDOW-pointer _int -> _int))
(define-curses wattron (_fun _WINDOW-pointer _int -> _int))
(define-curses attrset (_fun _int -> _int))
(define-curses wattrset (_fun _WINDOW-pointer _int -> _int))
(define-curses bkgd (_fun _long -> _int))
(define-curses wbkgd (_fun _WINDOW-pointer _long -> _int))
(define-curses bkgdset (_fun _long -> _int))
(define-curses wbkgdset (_fun _WINDOW-pointer _long -> _int))
(define-curses border (_fun _long _long _long _long 
                            _long _long _long _long 
                            -> _int))
(define-curses box (_fun _WINDOW-pointer _long _long -> _int))
(define-curses chgat (_fun _int _long _short -> _int))
(define-curses clear (_fun -> _int))
(define-curses wclear (_fun _WINDOW-pointer -> _int))
(define-curses color_content (_fun _short _short _short _short -> _int))
(define-curses color_set (_fun _short -> _int))
(define-curses COLOR_PAIR (_fun _int -> _int))
(define-curses copywin (_fun _WINDOW-pointer _WINDOW-pointer
                             _int _int _int _int _int _int _int
                             -> _int))

;INITIALIZATION FUNCTIONS;
(define-curses initscr (_fun -> _WINDOW-pointer))
(define-curses curs_set (_fun _int -> _int))
(define-curses newwin (_fun _int _int _int _int -> _WINDOW-pointer))
(define-curses endwin (_fun -> _int))
(define-curses newpad (_fun _int _int -> _WINDOW-pointer))
(define-curses delwin (_fun _WINDOW-pointer -> _int))
(define-curses derwin (_fun _WINDOW-pointer
                            _int _int _int _int
                            -> _WINDOW-pointer))

;SCREEN-UPDATE FUNCTIONS;
(define-curses doupdate (_fun -> _void))
(define-curses wnoutrefresh (_fun _WINDOW-pointer -> _int))
(define-curses refresh (_fun -> _int))
(define-curses wrefresh (_fun _WINDOW-pointer -> _int))
(define-curses leaveok (_fun _WINDOW-pointer _bool -> _int))

;INPUT FUNCTIONS;
(define-curses cbreak (_fun -> _int))
(define-curses nocbreak (_fun -> _int))
(define-curses wgetch (_fun _WINDOW-pointer -> _int))
(define-curses keypad (_fun _WINDOW-pointer _bool -> _int))

;MISC;
(define-curses beep (_fun -> _int))
(define-curses baudrate (_fun -> _int))
(define-curses move (_fun _int _int -> _int))
(define-curses wmove (_fun _WINDOW-pointer _int _int -> _int))
(define-curses clearok (_fun _WINDOW-pointer _bool -> _int))
(define-curses clrtobot (_fun -> _int))
(define-curses wclrtobot (_fun _WINDOW-pointer -> _int))
(define-curses clrtoeol (_fun -> _int))
(define-curses wclrtoeol (_fun _WINDOW-pointer -> _int))
(define-curses getmaxy (_fun _WINDOW-pointer -> _int))
(define-curses getmaxx (_fun _WINDOW-pointer -> _int))
(define-curses napms (_fun _int -> _int))

;PANELS;
(define-panel new_panel (_fun _WINDOW-pointer -> _int))
(define-panel update_panels (_fun -> _int))

;RACKET API/INTERFACE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;allows use of scheme chars and ORs any attributes
(define rkt_addch
 (case-lambda
        [(ch) (let ([ch (char->integer ch)])
		   (addch (bitwise-ior ch A_NORMAL)))]
	[(ch attr) (let ([ch (char->integer ch)])
		   (addch (bitwise-ior ch attr)))]
        [(y x ch)  (let ([ch (char->integer ch)])
		   (mvaddch y x (bitwise-ior ch A_NORMAL)))]
        [(y x ch attr)  (let ([ch (char->integer ch)])
		   (mvaddch y x (bitwise-ior ch attr)))]))

(define rkt_waddch
  (case-lambda
    [(win ch)
     (let ([ch (char->integer ch)])
       (waddch win ch))]
    [(win ch attr)
     (let ([ch (char->integer ch)])
       (waddch win (bitwise-ior ch attr)))]
    [(win y x ch)
     (let ([ch (char->integer ch)])
       (mvwaddch win y x (bitwise-ior ch A_NORMAL)))]
    [(win y x ch attr)
     (let ([ch (char->integer ch)])
       (mvwaddch win y x (bitwise-ior ch attr)))]))
              
(define rkt_addstr
  (case-lambda
    [(str) (addstr str)]
    [(str attr)
     (attron attr)
     (addstr str)
     (attroff attr)]
    [(y x str) (mvaddstr y x str)]
    [(y x str attr)
     (attron attr)
     (mvaddstr y x str)
     (attroff attr)]))     
     
(define rkt_waddstr
  (case-lambda
    [(win str) (waddstr str)]
    [(win str attr)
     (attron attr)
     (waddstr win str)
     (attroff attr)]
    [(win y x str) (mvwaddstr win y x str)]
    [(win y x str attr)
     (wattron win attr)
     (mvwaddstr win y x str)
     (wattroff win attr)]))   

;implemented as a macro in curses.
;IIRC the variables you want the values stored in are
;passed to the "function" which is replaced with: 
;y = (getmaxy win); x = (getmaxx win);
(define (getmaxyx win)
  (values (getmaxy win) (getmaxx win)))

;need a better way to do this
;if an error occurs during main, the terminal state is not reset.
(define (wrapper func)
  (define stdscr (initscr))
  (void (cbreak))
  (void (start_color))
  (func stdscr)
  (void (endwin)))

(define (main stdscr)
  (define-values
    [max_y max_x]
    [values (getmaxy stdscr) (getmaxx stdscr)])
  (curs_set 0)
  (add_border)
  (attron A_BOLD)
  ;I'm so sorry Daniel P. Friedman:
  (let loop ([y (quotient (- max_y 5) 2)]
             [x (quotient (- max_x 5) 2)]
             [ls       '("SATOR"
                         "AREPO"
                         "TENET"
                         "OPERA"
                         "ROTAS")])
    (rkt_addstr y x (car ls))
    (unless (eq? (cdr ls) '()) (loop (add1 y) x (cdr ls))))
    (rkt_addch 2 2 #\A)
  (wgetch stdscr))

(wrapper main)
