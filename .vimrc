" Plugins
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
" Automatically install vim-plug if it is not present
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/a.vim'

call plug#end()

" Windows and Appearance
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
" Colours
colorscheme onedark
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
set nu rnu
set so=2
set cursorline
set ruler
set splitright
set splitbelow
set novisualbell
set noerrorbells

" Search
set hlsearch
set incsearch

" Tabs, Spaces and Indentation
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
set smartindent
set autoindent
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" File Specific Configuration
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
syntax on
filetype plugin indent on

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" C++
autocmd FileType cpp setlocal matchpairs+=<:>
" Haskell
autocmd FileType haskell set tabstop=2 shiftwidth=2 formatprg=stylish-haskell
" HTML/ XML/ XSD
autocmd FileType html,xml,xsd setlocal tabstop=2 shiftwidth=2

" General Configuration
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
noremap <Leader>p "0p
vnoremap <Leader>p "0p
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "<C-y>" : "\<C-g>u\<CR>"
autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))

" Movement
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l
map <C-h> <C-W>h

" netrw
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_keepdir=0

" NERDCommenter
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
map <C-_> <plug>NERDCommenterToggle

" A.vim
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
let g:alternateExtensions_hpp = "ipp,cpp"
let g:alternateExtensions_ipp = "cpp,hpp"
map S :A<CR>

" fzf
"||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
nnoremap <C-p> :Files<Cr>

