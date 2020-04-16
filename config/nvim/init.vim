" Plugin setup {{{
call plug#begin(stdpath("data").'/bundle')

" File browser
Plug 'scrooloose/nerdtree', { 'on':  [ 'NERDTreeToggle', 'NERDTreeFind' ] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': [ 'NERDTreeToggle', 'NERDTreeFind' ] }

" Git support
Plug 'lambdalisue/gina.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'

" API documentation
Plug 'KabbAmine/zeavim.vim'

" Read GNU Info from vim
Plug 'alx741/vinfo'

" Language specific plugins
Plug 'kovetskiy/sxhkd-vim'
Plug 'chrisbra/csv.vim'
Plug 'vhdirk/vim-cmake'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax' 

" Autocompletion
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer'}

" Ultimate fuzzy search + Multi-entry selection UI.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

if has("nvim")
	Plug 'Lenovsky/nuake'
endif

" Use pywal theme
"Plug 'dylanaraps/wal.vim'

" Load this one last
"Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}
" General editor configuration {{{

" Line numbering
set number
set relativenumber

" Enable mouse, but in normal mode
set mouse=n

" Open split the sane way
set splitright
set splitbelow

" Hide buffer when closed
set hidden

set termguicolors
"colorscheme wal
colorscheme pablo

" Vimdiff to open vertical splits
" I don't understand how can anyone work otherwise
set diffopt+=vertical

" Start scrolling three lines before the horizontal window border
set scrolloff=3
set sidescrolloff=10

" Show matching brackets
set showmatch

" persist the undo tree for each file
set undofile

" Indentation options
set tabstop=4
set expandtab 
set softtabstop=4
set shiftwidth=4

" Taken from the NeoVim wiki
" All of those are set by defult in NeoVim
if has("vim")
	set syntax=ON
	filetype plugin indent on
	set autoindent
	set autoread
	set background=dark
	set backspace=indent,eol,start

	" protect against crash-during-write
	set writebackup
	" but do not persist backup after successful write
	set nobackup
	" use rename-and-write-new method whenever safe
	set backupcopy=auto
	" patch required to honor double slash at end
	if has("patch-8.1.0251")
		" consolidate the writebackups -- not a big
		" deal either way, since they usually get deleted
		set backupdir^=.,~/.local/share/nvim/backup//
	else
		set backupdir^=.,~/.local/share/nvim/backup
	endif

	set belloff=all
	set compatible=off
	set complete=.,w,b,u,t
	set cscopeverbose

	" Protect changes between writes. Default values of
	" updatecount (200 keystrokes) and updatetime
	" (4 seconds) are fine
	set swapfile
	set directory^=~/.local/share/nvim/swap//

	set display=lastline,msgsep
	set encoding=UTF-8
	set fileencoding=UTF-8
	set fillchars=vert:│,fold:·,sep:│
	set formatoptions=tcqj
	set nofsync
	set history=10000
	set hlsearch
	set incsearch
	set langnoremap
	set nolangremap
	set laststatus=2
	set nrformats=bin,hex
	set ruler
	set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
	set shortmess=filnxtToOF
	set showcmd
	set sidescroll=1
	set smarttab
	set nostartofline
	set tabpagemax=50
	set ttimeoutlen=50
	set ttyfast
	set undodir^=~/.local/share/nvim/undo//
	if has("Win32")
		set viminfo="!,'100,<50,s10,h,rA:,rB:"
	else
		set viminfo="!,'100,<50,s10,h"
	endif
	set wildmenu
	set wildoptions=pum,tagfile
endif

" Show whitespaces
set listchars=tab:»·,trail:·,extends:·,precedes:·,nbsp:·,eol:¶

set tags=./tags,**5/tags,tags;~
"                          ^ in working dir, or parents
"                   ^ in any subfolder of working dir
"           ^ sibling of open file

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
autocmd BufWritePost *termite/config !killall -USR1 termite

" Automatically close nvim when everything else except NERDTree is closed
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Show netrw in tree style (i to change)
"let g:netrw_liststyle=3

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

let g:ycm_clangd_binary_path = '/usr/bin/clangd-9'

if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.pandoc = ['@']

let g:ycm_filetype_blacklist = {}

" Use deoplete.
"let g:deoplete#enable_at_startup = 1

" This is new style
"call deoplete#custom#var('omni', 'input_patterns', {
"  \ 'pandoc': '@'
"  \})

"let g:LanguageClient_serverCommands = {
"    \ 'cpp': ['/usr/bin/cmake', '-E', 'server', '--debug'],
"    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"    \ 'python': ['/usr/local/bin/pyls'],
"    \ }

" Pandoc configuration
let g:pandoc#command#custom_open='zathura'
let g:pandoc#command#prefer_pdf=1
let g:pandoc#command#autoexec_command="Pandoc! pdf"
let g:pandoc#completion#bib#mode='citeproc'
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
nmap <Leader>ch :echon "s: Find this C symbol\ng: Find this definition\nd: Find functions called by this function (Cscope only)\nc: Find functions calling this function\nt: Find this text string\ne: Find this egrep pattern\nf: Find this file\ni: Find files #including this file\na: Find places where this symbol is assigned a value\n\n\<Leader\>cx - Jump to result\n\<Leader\>Cx - Open result in a split\n\<Leader\>CX - Open result a vertical split"<cr>

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

" Quickfix bindings
nmap ]q :cnext<cr>
nmap ]Q :clast<cr>
nmap [q :cprevious<cr>
nmap [Q :cfirst<cr>
nmap <Leader>q :ccl<cr>

" Turn off search highlight
nmap <Leader>/ :noh<cr>

" Fuzzy-find lite
nmap <Leader><space> :e ./**/
"nmap <Leader><cr> :buffer 

" FZF bindings
nmap <Leader><cr> <CMD>Buffers<CR>
nmap <Leader>f <CMD>FZF<CR>
nmap <Leader>t <CMD>Tags<CR>
nmap <Leader>T <CMD>BTags<CR>
nmap <Leader>m <CMD>Commits<CR>
nmap <Leader>M <CMD>BCommits<CR>

" Git workflow
nmap <Leader>gg :Gina 
nmap <Leader>gs <CMD>Gina status -s --opener=vsplit<CR>
nmap <Leader>gc <CMD>Gina commit<CR>

" Open netrw in CWD
"nmap <Leader>n :Explore .<cr>
"nmap <Leader>N :Sexplore .<cr>
"nmap \|N :Vexplore .<cr>
" Open netrw in the current file's dir
"nmap <Leader>v :Explore<cr>
"nmap <Leader>V :Sexplore<cr>
"nmap \|V :Vexplore<cr>

" Spellchecking Bindings
imap <m-f> <C-G>u<Esc>[s1z=`]a<C-G>u
nmap <m-f> [s1z=<c-o>

" Toggle whitespaces
nmap <F2> :set list! <CR>

" Toggle spell checking
nmap <F3> :setlocal spell! spelllang=en<CR>

" real make
map <silent> <F5> :make<cr><cr><cr>
" GNUism, for building recursively
map <silent> <s-F5> :make -w<cr><cr><cr>

map <Leader>` :Nuake<cr>
tmap <Leader>` <c-\><c-n>:Nuake<cr>

" Compile file (Markdown, LaTeX, etc)
" TODO: Auto-recognize build system
nmap <silent> <F6> :!compiler %<cr>
" }}}
