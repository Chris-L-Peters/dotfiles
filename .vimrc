call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'

call plug#end()

syntax on
colorscheme onedark
let g:airline_theme='onedark'
