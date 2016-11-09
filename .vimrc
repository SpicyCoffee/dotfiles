set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

set directory=~/.vim/swp  " directory to save swp files

set expandtab  " convert tab to spaces
set tabstop=2  " tab width
set softtabstop=2 " spaces cursor moves at once
set autoindent
set smartindent  " auto indent according to syntax
set shiftwidth=2 " indent width for smart indent

set incsearch
set ignorecase  " treat equally uppercase and lowercase for search
set smartcase   " don't ignorecase when uppercase is in the search pattern
set hlsearch    " hilight search result

set scrolloff=8      " ensure upper and lower 8 row
set sidescrolloff=16 " ensure display when side scroll
set whichwrap=b,s,h,l,<,>,[,],~  " cursor moves to next line start from line end
set number   " display column number
set cursorline  " hilight cursor line

" move only 1 line when the line spreads over 2 lines
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

set backspace=indent,eol,start  " activate backspace key

set showmatch  " blink corresponding bracket
source $VIMRUNTIME/macros/matchit.vim  " expand vim's '%'

set wildmenu 	   " command completion
set history=5000 " the number of command histories

autocmd BufWritePre * :%s/\s\+$//ge   " delete blanks at line end when saving

" activate mouse operation
if has('mouse')
  set mouse=a
  if has('mouse_sgr')
    set ttymouse=sgr
  elseif v:version > 703 || v:version is 703 && has('patch632')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif

" arrange paste from clipboard
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" key mapping
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" for US keyboard
nnoremap ; :
noremap! ¥ \
noremap! \ ¥


" minor change for colorscheme
autocmd VimEnter,Colorscheme * hi Visual ctermfg=0 guifg=Black ctermbg=11 guibg=Yellow
autocmd VimEnter,Colorscheme * hi VisualNos ctermfg=0 guifg=Black ctermbg=11 guibg=Yellow
autocmd VimEnter,Colorscheme * hi Search ctermfg=0 guifg=Black ctermbg=11 guibg=Yellow


""""" NeoBundle
if has('vim_starting')  " operations for first time start-up
  " add neobundle path to runtimepath
  set runtimepath+=~/.vim/bundle/neobundle.vim/

  " git clone NeoBundle
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install NeoBundle..."
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))
  " Manage NeoBundle itself
  NeoBundleFetch 'Shougo/neobundle.vim'

  " Plugins--------------------------------------------------
  NeoBundle 'tomtom/tcomment_vim'  " toggle comments

  " color scheme hybrid
  NeoBundle 'w0ng/vim-hybrid'
  if neobundle#is_installed('hybrid')
    set background=dark
    colorscheme hybrid
  endif
  syntax enable

  " snippet(require lua)
  if has('lua')
    NeoBundle 'Shougo/neocomplete.vim'
    NeoBundle "Shougo/neosnippet"
    NeoBundle 'Shougo/neosnippet-snippets'
  endif

  if neobundle#is_installed('neocomplete.vim')
    let g:neocomplete#enable_at_startup = 1  " activate neocomplete with start-up
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#min_keyword_length = 3
    let g:neocomplete#enable_auto_delimiter = 1  " complete delimiter
    let g:neocomplete#auto_completion_start_length = 1  " display popup from 1 length
    " close popup by BackSpace key
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

    " decide word by Carriage Return key
    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    " choice words by TAB key
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
  endif

  " support for html
  let g:user_emmet_leader_key='<C-T>'
  NeoBundle 'mattn/emmet-vim'

  " enhance status line information
  NeoBundle 'itchyny/lightline.vim'
  set laststatus=2  " always display status line
  set showmode
  set showcmd
  set ruler   " display cursor position

  " hilight blanks at line end
  NeoBundle 'bronson/vim-trailing-whitespace'

  " display file tree
  NeoBundle 'scrooloose/nerdtree'
  nnoremap <silent><C-e> :NERDTreeToggle<CR>

  " check syntax
  NeoBundle 'scrooloose/syntastic'
  " cyntastic config
  let g:syntastic_enable_signs = 1  " display '>>' error line
  let g:syntastic_always_populate_loc_list = 1  " stop conflict with other plugins
  let g:syntastic_auto_loc_list = 0  " hide error list
  let g:syntastic_check_on_open = 1  " check syntax when a file is opend
  let g:syntastic_check_on_wq = 1    " check syntax when ':wq'
  let g:syntastic_mode_map = { 'mode': 'passive' }

  " operation about surrounding symbol
  NeoBundle 'tpope/vim-surround'

  " commands for Rails
  NeoBundle 'tpope/vim-rails'

  " additional syntax hilights
  NeoBundle 'hail2u/vim-css3-syntax'
  "----------------------------------------------------------
  call neobundle#end()

filetype plugin indent on
NeoBundleCheck


""""" Tab function config
" http://qiita.com/wadako111/items/755e753677dd72d8036d
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2  " always display tabline

" The prefix key.
nnoremap [Tag] <Nop>
nmap     t [Tag]

" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" tc create newtab
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx cloase tab
map <silent> [Tag]x :tabclose<CR>
" tn move to next tab
map <silent> [Tag]n :tabnext<CR>
" tp move to previous tab
map <silent> [Tag]p :tabprevious<CR>
