if exists("b:current_syntax")
  finish
endif

" keyword, space sep
syntax keyword veloKeyword fn return
syntax keyword veloType i32

" \v means pure regex
syntax match veloComment "\v//.*$"
syntax match veloNumberDecimal "\v<\d+>"
syntax match veloNumberHex "\v<0[xX]\x+>"
syntax match veloFloat "\v<\d+(.\d+)?>"

" for multi line
syntax region veloString start=/\v"/ skip=/\v\\./ end=/\v"/

" coloring
highlight default link veloKeyword        Keyword
highlight default link veloType           Type
highlight default link veloString         String
highlight default link veloNumberDecimal  Number
highlight default link veloNumberHex      Number
highlight default link veloFloat          Float


" Character	a character constant: 'c', '\n'
" Boolean		a boolean constant: TRUE, false
" Identifier	any variable name
" Function	function name (also: methods for classes)
" Statement	any statement
" Conditional	if, then, else, endif, switch, etc.
" Repeat		for, do, while, etc.
" Label		case, default, etc.
" Operator	"sizeof", "+", "*", etc.
" Keyword		any other keyword
" Exception	try, catch, throw
" PreProc		generic Preprocessor
" Include		preprocessor #include
" Define		preprocessor #define
" Macro		same as Define
" PreCondit	preprocessor #if, #else, #endif, etc.
" StorageClass	static, register, volatile, etc.
" Structure	struct, union, enum, etc.
" Typedef		a typedef
" Special		any special symbol
" SpecialChar	special character in a constant
" Tag		you can use CTRL-] on this
" Delimiter	character that needs attention
" SpecialComment	special things inside a comment
" Debug		debugging statements
" Underlined	text that stands out, HTML links
" Ignore		left blank, hidden  |hl-Ignore|
" Error		any erroneous construct
" Todo		anything that needs extra attention; mostly the keywords TODO FIXME and XXX
" Added		added line in a diff
" Changed		changed line in a diff
" Removed		removed line in a diff

" just there
let b:current_syntax = "velo"
