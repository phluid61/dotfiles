if exists("b:current_syntax")
    finish
endif


syntax region IDHTMLComment start="<!--" end="-->" keepend fold contains=NONE

syntax region IDFigure matchgroup=IDFigureFence start="^\z(\~\~\~\+\)\(\s\+\w\+\)\?$" end="^\z1$" contains=NONE

syntax match IDEscape /\\[\\.*_+-=`()[\]{}<>#!:|"'$]/

syntax region IDComment matchgroup=IDIALDelim start="{::comment}" end="{:/\(comment\)\?}" fold contains=NONE

syntax region IDNomarkdown matchgroup=IDIALDelim start="{::nomarkdown}" end="{:/\(nomarkdown\)\?}" fold contains=IDComment

syntax match IDHeaderAnchor "{#.\+}" contained contains=NONE
syntax match IDHeader "^#\+.\+$" contains=IDHeaderAnchor

syntax match IDHTMLClosed "<\h[^>]*/>"
syntax region IDHTML matchgroup=IDHTMLTag start="<\z(\h\W*\)\>[^>]*>" end="</\z1>" contains=IDRFC2119,IDItalic,IDBold,IDCode,IDPunct,IDBlock,IDEndBlock,IDEOL,IDEOLSpace,IDRef,IDLink,IDImage,IDIAL,IDHTML,IDHTMLClosed,IDHeader,IDNomarkdown,IDComment,IDEscape,IDFigure,IDHTMLComment
"syntax region IDHTML matchgroup=IDHTMLTag start="<\z(\h\W*\)\>[^>]*>" end="</\z1>"

syntax region IDIALString start='"' skip='\\"' end='"' contained contains=NONE
syntax region IDIALString start="'" skip="\\'" end="'" contained contains=NONE
syntax region IDIAL matchgroup=IDIALDelim start="{:" skip="\\}" end="}" contains=IDIALString

syntax region IDLinkTitleString start='"' skip='\\"' end='"' contained contains=NONE
syntax region IDLinkTitleString start="'" skip="\\'" end="'" contained contains=NONE
syntax match IDLinkTitle "\S\+" contained contains=IDItalic,IDBold,IDCode,IDEscape
syntax match IDLinkHref  "\S\+" contained nextgroup=IDLinkTitle,IDLinkTitleString

syntax region IDLink    matchgroup=IDLinkOp start="\["  end="]" contains=@IDSpanElements nextgroup=IDLinkURL,IDLinkRef,IDLinkDef
syntax region IDImage   matchgroup=IDLinkOp start="!\[" end="]" contains=@IDSpanElements nextgroup=IDLinkURL,IDLinkRef,IDLinkDef
syntax region IDLinkURL matchgroup=IDLinkOp start="(" end=")" contained contains=IDLinkHref
syntax region IDLinkRef matchgroup=IDLinkOp start="\[" end="]" contained contains=NONE
syntax region IDLinkDef matchgroup=IDLinkOp start=":" end="$" contained contains=IDLinkHref

syntax region IDRef start="{{" end="}}" contains=NONE

syntax match IDEOL "//$"
syntax match IDEOLSpace " $"

syntax match IDPunct "\(---\?\|\.\.\.\|<<\|>>\)"

syntax match IDSection "^--- \(middle\|back\)$"

syntax region IDCode start="\z(`\+\)\([^ 	`]\)\@=" end="\(\S\)\@<=\z1" contains=NONE
syntax region IDBold   matchgroup=IDBoldX   start="\*\*\([^ 	*]\| \*\)\@=" end="\([^ 	*]\|\* \)\@<=\*\*" contains=IDItalic
syntax region IDItalic matchgroup=IDItalicX start="\*\([^ 	*]\| \*\*\)\@=" end="\([^ 	*]\|\*\* \)\@<=\*" contains=IDBold
syntax region IDBold   matchgroup=IDBoldX   start="\(\w\)\@<!__\(\S\)\@=" end="\(\S\)\@<=__\(\w\)\@!" contains=IDItalic
syntax region IDItalic matchgroup=IDItalicX start="\(\w\)\@<!_\(\S\)\@="  end="\(\S\)\@<=_\(\w\)\@!" contains=IDBold

syntax match IDEndBlock "^\^ *$"

syntax match IDBlock "^\s*\(>\s*\)\{-}\([>:*+-]\|\d\+\.\) " contains=NONE

syntax keyword IDRFC2119 MUST REQUIRED SHALL SHOULD RECOMMENDED MAY OPTIONAL NOT

syntax match IDHTMLEnt "&\(\w\+\|#\d\+\|#x[0-9A-Fa-f]\+\);"

syntax cluster IDSpanElements contains=IDItalic,IDBold,IDCode,IDEscape,IDPunct,IDHTMLEnt,IDRFC2119

" TODO: YAML?
syntax region IDMetaString start=/"/ end=/"/ contained contains=NONE
syntax match IDMetaComment /#.*$/ contained contains=NONE

syntax region IDMeta matchgroup=IDSection start="\%^---" end="^--- abstract$" keepend contains=IDMetaString,IDMetaComment

highlight default IDMeta ctermbg=236 guibg=#303030
"highlight default link IDMetaArray Operator
highlight default link IDMetaString String
highlight default link IDMetaComment Comment
highlight default link IDRFC2119 Type
highlight default link IDHTMLEnt Character
highlight default link IDItalic Italic
highlight default link IDBold Bold
highlight default link IDCode Code
highlight default link IDPunct Special
highlight default link IDBlock Operator
highlight default link IDEndBlock Operator
highlight default link IDEOL Operator
"highlight default link IDEOLSpace Operator
highlight default link IDRef Include
highlight default link IDLink Include
highlight default link IDImage Include
"highlight default link IDLinkUrl xxx
highlight default link IDLinkRef Include
"highlight default link IDLinkDef xxx
highlight default link IDLinkHref Underlined
highlight default link IDLinkTitle String
highlight default link IDLinkTitleString String
highlight default link IDLinkOp Operator
highlight default link IDEscape Special
highlight default link IDIALDelim Function
"highlight default link IDIAL xxx
highlight default link IDIALString String
"highlight default link IDHTML xxx
highlight default link IDHTMLTag Tag
highlight default link IDHeader Statement
highlight default link IDHeaderAnchor Identifier
highlight default link IDSection Constant
"highlight default link IDNomarkdown plain
highlight default link IDComment Comment
highlight default link IDFigureFence Operator
highlight default link IDFigure Code
highlight default link IDHTMLComment Comment

let b:current_syntax = "ID"

