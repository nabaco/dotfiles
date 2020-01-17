" Plugin setup {{{
call plug#begin(stdpath('data').'/bundle')

Plug 'scrooloose/nerdtree', { 'on':  [ 'NERDTreeToggle', 'NERDTreeFind' ] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

" Language specific plugins
Plug 'kovetskiy/sxhkd-vim'

" Load this one last
Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}

" General editor configuration {{{
set number
set relativenumber
set mouse=a

autocmd BufWritePost *sxhkdrc !pkill -USR1 -x sxhkd
autocmd BufWritePost *init.vim source ~/.config/nvim/init.vim
autocmd BufWritePost *bspwmrc !bspc wm -r
autocmd BufWritePost *picom.conf !pkill -x picom && picom -b
autocmd BufWritePost *mpd.conf !mpd --kill && mpd

" Automatically close nvim when everything else except NERDTree is closed
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" }}}
" Key bindings {{{
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>v :NERDTreeFind<CR>
" }}}
