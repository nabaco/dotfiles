" Plugin setup {{{
call plug#begin(stdpath('data').'../nvim-data/bundle')

Plug 'scrooloose/nerdtree', { 'on':  [ 'NERDTreeToggle', 'NERDTreeFind' ] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

" Language specific plugins
Plug 'kovetskiy/sxhkd-vim'

" Load this one last
"Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}

" General editor configuration {{{
set number
set relativenumber

if has("cscope")
	set cscopetag
	set cscopequickfix=s-,c-,d-,i-,t-,e-,a-

	" add any database in current directory
	if filereadable("cscope.out")
	    silent cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    silent cs add $CSCOPE_DB
	endif
endif

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

"0 or s: Find this C symbol
"1 or g: Find this definition
"2 or d: Find functions called by this function
"3 or c: Find functions calling this function
"4 or t: Find this text string
"6 or e: Find this egrep pattern
"7 or f: Find this file
"8 or i: Find files #including this file
"9 or a: Find places where this symbol is assigned a value

" Print help
nmap <Leader>ch :echon "s: Find this C symbol\ng: Find this definition\nd: Find functions called by this function\nc: Find functions calling this function\nt: Find this text string\ne: Find this egrep pattern\nf: Find this file\ni: Find files #including this file\na: Find places where this symbol is assigned a value"<cr>

" Jump to result
nmap <Leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>ce :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <Leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>ca :cs find a <C-R>=expand("<cword>")<CR><CR>

" Open the result in a split
nmap <Leader>Cs :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>Cg :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>Cc :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>Ct :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>Ce :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>Cf :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>Ci :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <Leader>Cd :scs find d <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>Ca :scs find a <C-R>=expand("<cword>")<CR><CR>

" Open the result in a vertical split
nmap <Leader>CS :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>CG :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>CC :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>CT :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>CE :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>CF :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>CI :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <Leader>CD :vert scs find d <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>CA :vert scs find a <C-R>=expand("<cword>")<CR><CR>

nmap ]q :cnext<cr>
nmap [q :cprevious<cr>
nmap <Leader>q :ccl<cr>

nmap <Leader>/ :noh<cr>
nmap <C-p> :e ./**/
nmap <Leader><cr> :buffer 
" }}}
