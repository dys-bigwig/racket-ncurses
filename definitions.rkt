#lang racket/base
(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/cvector)
(provide (all-defined-out))

(define-ffi-definer define-curses (ffi-lib "libncurses" '("5" #f)))
(define-ffi-definer define-panel (ffi-lib "libpanel" '("5" #f)))

(define _WINDOW-pointer (_cpointer 'WINDOW))
(define _chtype _ulong)
(define _chstr _cvector)
(define (chlist->chstr chars) (list->cvector (append chars '(0)) _chtype))

;ADDCH FUNCTIONS;

(define-curses addch (_fun _chtype -> _int))
(define-curses waddch (_fun _WINDOW-pointer _chtype -> _int))
(define-curses mvaddch (_fun _int _int _chtype -> _int))
(define-curses mvwaddch (_fun _WINDOW-pointer _int _int _chtype -> _int))
(define-curses addchstr (_fun _chstr -> _int))

;ADDSTR FUNCTIONS
(define-curses addstr (_fun _string -> _int))
(define-curses addnstr (_fun _string _int -> _int))
(define-curses waddstr (_fun _WINDOW-pointer _string -> _int))
(define-curses waddnstr (_fun _WINDOW-pointer _string _int -> _int))
(define-curses mvaddstr (_fun _int _int _string -> _int))
(define-curses mvaddnstr (_fun _int _int _string _int -> _int))
(define-curses mvwaddstr (_fun _WINDOW-pointer _int _int _string -> _int))
(define-curses mvwaddnstr (_fun _WINDOW-pointer _int _int _string _int -> _int))
(define-curses mvwaddchstr (_fun _WINDOW-pointer _int _int _chstr -> _int))

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
(define-curses getch (_fun -> _int))
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
(define-curses getcury (_fun _WINDOW-pointer -> _int))
(define-curses getcurx (_fun _WINDOW-pointer -> _int))
(define-curses napms (_fun _int -> _int))
(define-curses can_change_color (_fun -> _bool))

;PANELS;
(define-panel new_panel (_fun _WINDOW-pointer -> _int))
(define-panel update_panels (_fun -> _int))

