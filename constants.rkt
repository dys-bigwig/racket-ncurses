#lang racket/base
(provide (all-defined-out))

(define A_NORMAL         #b0)
(define A_STANDOUT       #b10000000000000000)
(define A_UNDERLINE      #b100000000000000000)
(define A_REVERSE        #b1000000000000000000)
(define A_BLINK          #b10000000000000000000)
(define A_DIMMED         #b100000000000000000000)
(define A_BOLD           #b1000000000000000000000)
(define A_ALTCHARSET     #b10000000000000000000000)
(define A_INVISIBLE      #b100000000000000000000000)
(define A_PROTECT        #b1000000000000000000000010)
(define A_HORIZONTAL     #b10000000000000000000000000)
(define A_LEFT           #b100000000000000000000000000)
(define A_LOW            #b1000000000000000000000000000)
(define A_RIGHT          #b10000000000000000000000000000)
(define A_TOP            #b100000000000000000000000000000)
(define A_VERTICAL       #b1000000000000000000000000000000)
(define COLOR_BLACK   0) 
(define COLOR_RED     1)
(define COLOR_GREEN   2)
(define COLOR_YELLOW  3)
(define COLOR_BLUE    4)
(define COLOR_MAGENTA 5)
(define COLOR_CYAN    6)
(define COLOR_WHITE   7)

(define KEY_DOWN        0402)            ; down-arrow key ;
(define KEY_UP          0403)            ; up-arrow key ;
(define KEY_LEFT        0404)            ; left-arrow key ;
(define KEY_RIGHT       0405)            ; right-arrow key ;
(define KEY_HOME        0406)            ; home key ;
(define KEY_BACKSPACE   0407)            ; backspace key ;
(define KEY_F0          0410)            ; Function keys.  Space for 64 ;
(define KEY_DL          0510)            ; delete-line key ;
(define KEY_IL          0511)            ; insert-line key ;
(define KEY_DC          0512)            ; delete-character key ;
(define KEY_IC          0513)            ; insert-character key ;
(define KEY_EIC         0514)            ; sent by rmir or smir in insert mode ;
(define KEY_CLEAR       0515)            ; clear-screen or erase key ;
(define KEY_EOS         0516)            ; clear-to-end-of-screen key ;
(define KEY_EOL         0517)            ; clear-to-end-of-line key ;
(define KEY_SF          0520)            ; scroll-forward key ;
(define KEY_SR          0521)            ; scroll-backward key ;
(define KEY_NPAGE       0522)            ; next-page key ;
(define KEY_PPAGE       0523)            ; previous-page key ;
(define KEY_STAB        0524)            ; set-tab key ;
(define KEY_CTAB        0525)            ; clear-tab key ;
(define KEY_CATAB       0526)            ; clear-all-tabs key ;
(define KEY_ENTER       0527)            ; enter;send key ;
(define KEY_PRINT       0532)            ; print key ;
(define KEY_LL          0533)            ; lower-left key (home down) ;
(define KEY_A1          0534)            ; upper left of keypad ;
(define KEY_A3          0535)            ; upper right of keypad ;
(define KEY_B2          0536)            ; center of keypad ;
(define KEY_C1          0537)            ; lower left of keypad ;
(define KEY_C3          0540)            ; lower right of keypad ;
(define KEY_BTAB        0541)            ; back-tab key ;
(define KEY_BEG         0542)            ; begin key ;
(define KEY_CANCEL      0543)            ; cancel key ;
(define KEY_CLOSE       0544)            ; close key ;
(define KEY_COMMAND     0545)            ; command key ;
(define KEY_COPY        0546)            ; copy key ;
(define KEY_CREATE      0547)            ; create key ;
(define KEY_END         0550)            ; end key ;
(define KEY_EXIT        0551)            ; exit key ;
(define KEY_FIND        0552)            ; find key ;
(define KEY_HELP        0553)            ; help key ;
(define KEY_MARK        0554)            ; mark key ;
(define KEY_MESSAGE     0555)            ; message key ;
(define KEY_MOVE        0556)            ; move key ;
(define KEY_NEXT        0557)            ; next key ;
(define KEY_OPEN        0560)            ; open key ;
(define KEY_OPTIONS     0561)            ; options key ;
(define KEY_PREVIOUS    0562)            ; previous key ;
(define KEY_REDO        0563)            ; redo key ;
(define KEY_REFERENCE   0564)            ; reference key ;
(define KEY_REFRESH     0565)            ; refresh key ;
(define KEY_REPLACE     0566)            ; replace key ;
(define KEY_RESTART     0567)            ; restart key ;
(define KEY_RESUME      0570)            ; resume key ;
(define KEY_SAVE        0571)            ; save key ;
(define KEY_SBEG        0572)            ; shifted begin key ;
(define KEY_SCANCEL     0573)            ; shifted cancel key ;
(define KEY_SCOMMAND    0574)            ; shifted command key ;
(define KEY_SCOPY       0575)            ; shifted copy key ;
(define KEY_SCREATE     0576)            ; shifted create key ;
(define KEY_SDC         0577)            ; shifted delete-character key ;
(define KEY_SDL         0600)            ; shifted delete-line key ;
(define KEY_SELECT      0601)            ; select key ;
(define KEY_SEND        0602)            ; shifted end key ;
(define KEY_SEOL        0603)            ; shifted clear-to-end-of-line key ;
(define KEY_SEXIT       0604)            ; shifted exit key ;
(define KEY_SFIND       0605)            ; shifted find key ;
(define KEY_SHELP       0606)            ; shifted help key ;
(define KEY_SHOME       0607)            ; shifted home key ;
(define KEY_SIC         0610)            ; shifted insert-character key ;
(define KEY_SLEFT       0611)            ; shifted left-arrow key ;
(define KEY_SMESSAGE    0612)            ; shifted message key ;
(define KEY_SMOVE       0613)            ; shifted move key ;
(define KEY_SNEXT       0614)            ; shifted next key ;
(define KEY_SOPTIONS    0615)            ; shifted options key ;
(define KEY_SPREVIOUS   0616)            ; shifted previous key ;
(define KEY_SPRINT      0617)            ; shifted print key ;
(define KEY_SREDO       0620)            ; shifted redo key ;
(define KEY_SREPLACE    0621)            ; shifted replace key ;
(define KEY_SRIGHT      0622)            ; shifted right-arrow key ;
(define KEY_SRSUME      0623)            ; shifted resume key ;
(define KEY_SSAVE       0624)            ; shifted save key ;
(define KEY_SSUSPEND    0625)            ; shifted suspend key ;
(define KEY_SUNDO       0626)            ; shifted undo key ;
(define KEY_SUSPEND     0627)            ; suspend key ;
(define KEY_UNDO        0630)            ; undo key ;
(define KEY_MOUSE       0631)            ; Mouse event has occurred ;
(define KEY_RESIZE      0632)            ; Terminal resize event ;
(define KEY_EVENT       0633)            ; We were interrupted by an event ;
