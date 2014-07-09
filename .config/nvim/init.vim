""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')
  Plug 'scrooloose/syntastic'
  Plug 'tpope/vim-fugitive'
  Plug 'mv/mv-vim-nginx', { 'for': 'nginx' }
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'airblade/vim-gitgutter'
  Plug 'Raimondi/delimitMate'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'flazz/vim-colorschemes'
  Plug 'itchyny/lightline.vim'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'wting/rust.vim'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'majutsushi/tagbar'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'rking/ag.vim'
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'
  Plug 'jaxbot/syntastic-react'
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'hashivim/vim-terraform'
  Plug 'tell-k/vim-autoflake'
  Plug 'hzchirs/vim-material'
  Plug 'terryma/vim-smooth-scroll'
  Plug 'ambv/black'
  Plug 'kaicataldo/material.vim'
  Plug 'Chiel92/vim-autoformat'
  Plug 'sbdchd/neoformat'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  Plug 'sebdah/vim-delve'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" settings
set noshowmode
syntax enable
set encoding=utf-8
set expandtab
set laststatus=2
set statusline=%f "tail of the filename
set noautoindent
set number
set ruler
set scrolloff=10
set shiftwidth=2
set tabstop=2
set backspace=indent,eol,start
set autoread
set foldtext='\ '
set textwidth=88
set cursorline
set ttimeoutlen=0

" colors
colorscheme Tomorrow-Night-Eighties
set background=dark

" key bindings
let mapleader = ";"
inoremap jk <Esc>
vnoremap . :normal .<CR>
noremap <Leader>re :e!<CR>
noremap <Leader>ww :w!<CR>
noremap <Leader>wq :w<CR>: q<CR>
noremap <Leader>qq :q!<CR>
noremap <Leader>qa :qa<CR>
noremap <Leader>bn :bNext<CR>
noremap <Leader>bd :bdelete<CR>
noremap <Leader>f  :FZF<CR>
noremap <Leader>fa :Ag <cword><CR>
noremap <Leader>t  :NERDTreeToggle<CR>
noremap <Leader>e 88\|
noremap <Leader>rf :%s/\<<C-r><C-w>\>/
noremap <Leader>en :lnext<CR>
noremap <Leader>ep :lprev<CR>
nnoremap gf <C-^>
noremap ya "Ayy

tnoremap <c-q> <c-g><esc>

noremap <C-f> <plug>(fzf-complete-line)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language Specific
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ---------- python ----------

let g:autoflake_remove_unused_variables=1
let g:autoflake_remove_all_unused_imports=1
let g:autoflake_disable_show_diff=1
autocmd BufWritePre *.py execute ':Black'


" ---------- golang ----------

au FileType go nmap <Leader>gfs <Plug>(go-fill-struct)
au FileType go nmap <Leader>r <Plug>(go-rename)
let g:go_bin_path = $HOME . "/.go/bin"
let g:go_autodetect_gopath = 1

let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
"let g:go_metalinter_autosave = 1
let g:go_fmt_fail_silently = 0
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 0

" ---------- javascript ----------

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:jsx_ext_required = 0 " Allow JSX in normal JS files
au Filetype *.js *.jsx setl ts=2 sw=2 et

" ---------- json ----------

au BufRead,BufNewFile *.json set filetype=json


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ---------- nerd tree ----------

let NERDTreeIgnore = [ '\.pyc$', '__pycache__' ]

" ---------- easymotion ----------

map <Leader> <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-s)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
map <Leader>h <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>l <Plug>(easymotion-linebackward)
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_use_smartsign_us = 1

" ---------- smooth-scroll ----------

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 12, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 12, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 12, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 12, 4)<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" strip whitespace on save
autocmd BufWritePre <buffer> StripWhitespace


" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_javascript_checkers = ['eslint']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" choose zsh if we have it
if !empty(glob("/bin/zsh"))
    set shell=/bin/zsh
endif

if (has("nvim"))
  " for Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif

augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source ~/.config/nvim/init.vim
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CoC (mostly defaults)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" if hidden is not set, TextEdit might fail.
set hidden

" some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" better display for messages
set cmdheight=2

" you will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" use tab for trigger completion with characters ahead and navigate.
" use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
