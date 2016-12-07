set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

set directory=~/.vim/swp  " directory to save swp files

" color scheme
colorscheme iceberg
syntax on

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
set clipboard=unnamed,autoselect
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function! XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
  cnoremap <special> <Esc>[200~ <nop>
  cnoremap <special> <Esc>[201~ <nop>
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


""""" Dein
let s:dein_dir = expand('~/.vim/dein')  " directory to install plugins
" install dein.vim
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" config start
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " plugin lists(TOML files)
  let g:rc_dir    = expand('~/dotfiles/deinrc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " load TOML files
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" install not installed plugins
if dein#check_install()
  call dein#install()
endif


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
