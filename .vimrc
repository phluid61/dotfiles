if &term =~ 'rxvt-unicode'
    set t_Co=256
    if (&termencoding == "")
        set termencoding=utf-8
    endif
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_EI = "\<Esc>]12;grey80\x7"
    endif
endif
if has('syntax')
    syntax on
    if &t_Co == 256 || has("gui_running")
        colorscheme wombat256mod
    else
        colorscheme default
    endif
endif
if (&termencoding == "utf-8") || has("gui_running")
     set list listchars=tab:▸‥,trail:·,extends:…,precedes:…,nbsp:‗
else
     set list listchars=tab:>_,trail:.,extends:>,precedes:<,nbsp:_
endif
set guifont=Andale\ Mono\ 9
set nocompatible

"set noswapfile
set directory=$HOME/.vim/swap//,/tmp//
"set nobackup
set nowritebackup
set backupdir=$HOME/.vim/backup//,/tmp//
set undofile
set undodir=$HOME/.vim/undo,/tmp
set undolevels=1000
set undoreload=10000

set hidden
set wildmenu
set showcmd
set showmatch
set hlsearch
set backspace=indent,eol,start
set ruler
set laststatus=2
set mouse=a
set cmdheight=1
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set nowrap
map Y y$
noremap <C-L> :nohl<CR><C-L>
noremap <silent> <Space> :nohl<CR><C-L>

filetype on
filetype indent on
filetype plugin on

set cul

function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction
