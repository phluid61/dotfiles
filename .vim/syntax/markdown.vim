if exists("b:current_syntax")
    finish
endif

" --- Optional: full HTML syntax (heavy; includes entire syntax/html.vim) ---
"runtime! syntax/html.vim
"unlet! b:current_syntax

" --- Optional: per-language highlighting inside fenced code blocks ---
" Configure: let g:markdown_fenced_languages = ['ruby', 'python', 'javascript']
"if !exists('g:markdown_fenced_languages')
"  let g:markdown_fenced_languages = []
"endif
"for s:type in g:markdown_fenced_languages
"  exe 'syn include @mdHighlight_'.s:type.' syntax/'.s:type.'.vim'
"  unlet! b:current_syntax
"  exe 'syn region mdHighlight_'.s:type.' matchgroup=mdFencedCodeFence start="^\z(`\{3,\}\)\s*'.s:type.'\s*$" end="^\z1\s*$" keepend contains=@mdHighlight_'.s:type
"  exe 'syn region mdHighlight_'.s:type.' matchgroup=mdFencedCodeFence start="^\z(\~\{3,\}\)\s*'.s:type.'\s*$" end="^\z1\s*$" keepend contains=@mdHighlight_'.s:type
"endfor
"unlet! s:type


" === Escaped characters ===

syntax match mdEscape /\\[][\\`*_{}()#+\-.!~<>|:"'$=]/


" === HTML ===

syntax region mdHTMLComment start="<!--" end="-->" keepend fold contains=NONE
syntax match mdHTMLEnt "&\(\w\+\|#\d\+\|#x[0-9A-Fa-f]\+\);"
syntax match mdHTMLSelfClose "<\h[^>]*/>"
syntax region mdHTML matchgroup=mdHTMLTag start="<\z(\h\W*\)\>[^>]*>" end="</\z1>" contains=@mdInline,mdBlock,mdEndBlock,mdEOL,mdEOLSpace,mdHTML,mdHTMLSelfClose,mdH1,mdH2,mdH3,mdH4,mdH5,mdH6,mdNomarkdown,mdComment,mdEscape,mdFencedCode,mdHTMLComment


" === kramdown: comments and nomarkdown ===

syntax region mdComment matchgroup=mdKramdownDelim start="{::comment}" end="{:/\(comment\)\?}" fold contains=NONE
syntax region mdNomarkdown matchgroup=mdKramdownDelim start="{::nomarkdown}" end="{:/\(nomarkdown\)\?}" fold contains=mdComment


" === kramdown: inline attribute lists ===

syntax region mdIALString start='"' skip='\\"' end='"' contained contains=NONE
syntax region mdIALString start="'" skip="\\'" end="'" contained contains=NONE
syntax region mdIAL matchgroup=mdKramdownDelim start="{:" skip="\\}" end="}" contains=mdIALString


" === Headings ===

syntax match mdHeaderAnchor "{#.\+}" contained contains=NONE

syntax match mdH1 "^#\s.\+$" contains=@mdInline,mdHeaderAnchor
syntax match mdH2 "^##\s.\+$" contains=@mdInline,mdHeaderAnchor
syntax match mdH3 "^###\s.\+$" contains=@mdInline,mdHeaderAnchor
syntax match mdH4 "^####\s.\+$" contains=@mdInline,mdHeaderAnchor
syntax match mdH5 "^#####\s.\+$" contains=@mdInline,mdHeaderAnchor
syntax match mdH6 "^######\s.\+$" contains=@mdInline,mdHeaderAnchor

syntax match mdH1 "^.\+\n=\+\s*$" contains=@mdInline
syntax match mdH2 "^.\+\n-\+\s*$" contains=@mdInline


" === Links ===

syntax region mdLinkTitleString start='"' skip='\\"' end='"' contained contains=NONE
syntax region mdLinkTitleString start="'" skip="\\'" end="'" contained contains=NONE
syntax match mdLinkTitle "\S\+" contained contains=mdItalic,mdBold,mdCode,mdEscape
syntax match mdLinkHref "[^()[:space:]]\+" contained nextgroup=mdLinkTitle,mdLinkTitleString

syntax region mdLink matchgroup=mdLinkOp start="\[" end="]" contains=@mdInline,mdImage nextgroup=mdLinkURL,mdLinkRef,mdLinkDef
syntax region mdImage matchgroup=mdLinkOp start="!\[" end="]" contains=@mdInline nextgroup=mdLinkURL,mdLinkRef,mdLinkDef
syntax region mdLinkURL matchgroup=mdLinkOp start="(" end=")" contained contains=mdLinkHref
syntax region mdLinkRef matchgroup=mdLinkOp start="\[" end="]" contained contains=NONE
syntax region mdLinkDef matchgroup=mdLinkOp start=":" end="$" contained contains=mdLinkHref

syntax match mdAutoLink "<\(https\?\|ftp\)://[^>]*>"
syntax match mdAutoLink "<[A-Za-z0-9._%+\-]\+@[A-Za-z0-9.\-]\+\.[A-Za-z]\{2,}>"

syntax match mdFootnote "\[^[^\]]\+\]"
syntax match mdFootnoteDef "^\[^[^\]]\+\]:"


" === kramdown: references and EOL markers ===

syntax region mdRef start="{{" end="}}" contains=NONE
syntax match mdEOL "//$"
syntax match mdEOLSpace " $"


" === Typography and punctuation ===

syntax match mdPunct "\(---\?\|\.\.\.\|<<\|>>\)"


" === Horizontal rules ===

syntax match mdRule "^\s*\*\s*\*\s*\*[\s*]*$"
syntax match mdRule "^\s*-\s*-\s*-[\s-]*$"
syntax match mdRule "^\s*_\s*_\s*_[\s_]*$"


" === kramdown: section markers ===

syntax match mdSection "^--- \(middle\|back\)$"


" === Block-level elements ===

syntax match mdBlock "^\s*\(>\s*\)\{-}\([>:*+-]\|\d\+\.\) " contains=NONE
syntax match mdEndBlock "^\^ *$"


" === Inline code (1-2 backticks; 3+ reserved for fenced code blocks) ===

syntax region mdCode start="\z(`\{1,2}\)\(`\)\@!\([^ 	`]\)\@=" end="\(\S\)\@<=\z1\(`\)\@!" contains=NONE


" === Bold / italic — asterisks ===

syntax region mdBold matchgroup=mdBoldDelim start="\*\*\([^ 	*]\| \*\)\@=" end="\([^ 	*]\|\* \)\@<=\*\*" contains=mdItalic,mdCode,mdEscape
syntax region mdItalic matchgroup=mdItalicDelim start="\*\([^ 	*]\| \*\*\)\@=" end="\([^ 	*]\|\*\* \)\@<=\*" contains=mdBold,mdCode,mdEscape


" === Bold / italic — underscores (word-boundary aware) ===

syntax region mdBold matchgroup=mdBoldDelim start="\(\w\)\@<!__\(\S\)\@=" end="\(\S\)\@<=__\(\w\)\@!" contains=mdItalic,mdCode,mdEscape
syntax region mdItalic matchgroup=mdItalicDelim start="\(\w\)\@<!_\(\S\)\@=" end="\(\S\)\@<=_\(\w\)\@!" contains=mdBold,mdCode,mdEscape


" === Bold-italic (triple markers; defined after bold/italic for priority) ===

syntax region mdBoldItalic matchgroup=mdBoldItalicDelim start="\*\*\*\S\@=" end="\S\@<=\*\*\*" contains=mdCode,mdEscape
syntax region mdBoldItalic matchgroup=mdBoldItalicDelim start="\(\w\)\@<!___\(\S\)\@=" end="\(\S\)\@<=___\(\w\)\@!" contains=mdCode,mdEscape


" === Strikethrough ===

syntax region mdStrike matchgroup=mdStrikeDelim start="\~\~\S\@=" end="\S\@<=\~\~" contains=NONE


" === Fenced code blocks (after inline code for priority) ===

syntax region mdFencedCode matchgroup=mdFencedCodeFence start="^\z(\~\~\~\+\|```\+\)\(\s*\w\+\)\?$" end="^\z1$" contains=NONE


" === Indented code blocks (preceded by blank line) ===

syntax region mdIndentedCode start="^\n\( \{4,}\|\t\)" end="^\ze \{,3}\S.*$" keepend contains=NONE


" === RFC 2119 keywords (kramdown-rfc) ===

syntax keyword mdRFC2119 MUST REQUIRED SHALL SHOULD RECOMMENDED MAY OPTIONAL NOT


" === Inline element cluster ===

syntax cluster mdInline contains=mdItalic,mdBold,mdBoldItalic,mdCode,mdStrike,mdEscape,mdPunct,mdHTMLEnt,mdRFC2119,mdLink,mdImage,mdAutoLink,mdFootnote,mdRef,mdIAL


" === Front matter / metadata ===

syntax region mdMetaString start=/"/ end=/"/ contained contains=NONE
syntax match mdMetaComment /#.*$/ contained contains=NONE
syntax region mdFrontMatter matchgroup=mdSection start="\%^---\s*$" end="^---\(\s\+abstract\)\?\s*$" keepend contains=mdMetaString,mdMetaComment


" === Highlighting ===

" Headings
highlight default link mdH1 Title
highlight default link mdH2 Title
highlight default link mdH3 Title
highlight default link mdH4 Title
highlight default link mdH5 Title
highlight default link mdH6 Title
highlight default link mdHeaderAnchor Identifier

" Structure
highlight default link mdRule PreProc
highlight default link mdSection Constant
highlight default link mdBlock Operator
highlight default link mdEndBlock Operator

" Emphasis
highlight default mdItalic term=italic cterm=italic gui=italic
highlight default link mdItalicDelim mdItalic
highlight default mdBold term=bold cterm=bold gui=bold
highlight default link mdBoldDelim mdBold
highlight default mdBoldItalic term=bold,italic cterm=bold,italic gui=bold,italic
highlight default link mdBoldItalicDelim mdBoldItalic
highlight default link mdStrike Comment
highlight default link mdStrikeDelim mdStrike

" Code
highlight default link mdCode String
highlight default link mdFencedCode String
highlight default link mdFencedCodeFence Operator
highlight default link mdIndentedCode String

" Links
highlight default link mdLink Include
highlight default link mdImage Include
highlight default link mdLinkOp Operator
highlight default link mdLinkHref Underlined
highlight default link mdLinkTitle String
highlight default link mdLinkTitleString String
highlight default link mdLinkRef Include
highlight default link mdAutoLink Underlined
highlight default link mdFootnote Typedef
highlight default link mdFootnoteDef Typedef

" HTML
highlight default link mdHTMLTag Tag
highlight default link mdHTMLSelfClose Tag
highlight default link mdHTMLComment Comment
highlight default link mdHTMLEnt Character

" kramdown
highlight default link mdKramdownDelim Function
highlight default link mdIALString String
highlight default link mdComment Comment
highlight default link mdRef Include
highlight default link mdRFC2119 Type
highlight default link mdEOL Operator

" Misc
highlight default link mdPunct Special
highlight default link mdEscape Special

" Front matter
highlight default mdFrontMatter ctermbg=236 guibg=#303030
highlight default link mdMetaString String
highlight default link mdMetaComment Comment


let b:current_syntax = "markdown"
