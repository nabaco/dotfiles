"{{{"""""" Plug management """"""""
call plug#begin(stdpath("data").'/bundle')

" let VimPlug manage VimPlug, required
Plug 'junegunn/vim-plug'

" Get used to proper Vim movement
Plug 'takac/vim-hardtime'

" Add some additional text objects and attack them
Plug 'wellle/targets.vim'

" File browsing
Plug 'scrooloose/nerdtree', { 'on':  [ 'NERDTreeToggle', 'NERDTreeFind' ] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': [ 'NERDTreeToggle', 'NERDTreeFind' ] }
"Plug 'tpope/vim-vinegar'

" Git support
Plug 'tpope/vim-fugitive' " Only for FZF integration
Plug 'idanarye/vim-merginal' " Branch TUI based on fugitive
Plug 'jreybert/vimagit' " Easier stage/commit workflow
Plug 'airblade/vim-gitgutter' " Show changes live + 'hunk/change' text object
Plug 'rhysd/git-messenger.vim' " Git blame in bubbles

if has("Win32")
	Plug 'Shougo/vimproc.vim', {'do' : 'nmake'}
endif

" Vim Rooter - needed for all the git plugins to work correctly,
" in a multi-repo environment
Plug 'airblade/vim-rooter'

" Puts all vim navigation keys on drugs! f,t,w,b,e etc..
Plug 'easymotion/vim-easymotion'

" Ultimate fuzzy search + Multi-entry selection UI.
Plug 'junegunn/fzf', { 'dir': '~/.local/bin/fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Alternative file contents search
Plug 'mileszs/ack.vim'

" Autocompletion
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer'}

" Ctags support
" Easytags replacement with support for Universal Ctags
"Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus' " Extra for Cscope
Plug 'majutsushi/tagbar' " A bar with list of all the tags in the buffer
"Plug 'xolox/vim-misc' " Required by easytags
"Plug 'xolox/vim-easytags'

" A - for switching between source and header files
Plug 'vim-scripts/a.vim'

" UltiSnips
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Remove extraneous whitespace when edit mode is exited
Plug 'thirtythreeforty/lessspace.vim'

" Bracket completion
Plug 'Raimondi/delimitMate'

" Tpope's plugins
Plug 'tpope/vim-surround' " surround vim
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps with .
Plug 'tpope/vim-eunuch' " Unix commands from Vim
Plug 'tpope/vim-commentary' " Comment blocks
Plug 'tpope/vim-obsession' " Vim session management

" Imporve % for if..else and such
" Does Neovim need this? I think Neovim has it built in
"Plug 'adelarsq/vim-matchit'

" External App Integration
" API documentation
Plug 'KabbAmine/zeavim.vim'
" The ultimate cheat sheet
Plug 'dbeniamine/cheat.sh-vim'
" Read GNU Info from vim
Plug 'alx741/vinfo'
"Plug 'HiPhish/info.vim'

" Notes, to-do, etc
"Plug 'vimwiki/vimwiki'
"Plug 'vimwiki/utils'

" Language specific plugins
Plug 'kovetskiy/sxhkd-vim'
Plug 'chrisbra/csv.vim'
Plug 'vhdirk/vim-cmake'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'kergoth/vim-bitbake'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'

" PlanUML support and preview
Plug 'aklt/plantuml-syntax'
Plug 'scrooloose/vim-slumlord'

" Pop-up the built in terminal
if has("nvim")
	Plug 'Lenovsky/nuake'
endif

" Eye Candy
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

" Start screen
Plug 'mhinz/vim-startify'

" Highlight same words as under cursor
Plug 'RRethy/vim-illuminate'

" Use pywal theme
"Plug 'dylanaraps/wal.vim'

" Load this one last
"Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}
"{{{"""""" General Vim Config """""""

set termguicolors
" Colorscheme wal
colorscheme gruvbox

" Search highlight colors
" Should be applied after colorscheme
hi Search ctermbg=Yellow
hi Search ctermfg=Red

" Set environment variable to be able to start vim in :terminal
if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

" Sync clipboards with system
set clipboard+=unnamedplus

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

" Highlight edge column
set colorcolumn=100
" Let plugins show effects after 500ms, not 4s
set updatetime=500
" Show whitespaces
set listchars=tab:»·,space:·,trail:·,extends:·,precedes:·,nbsp:·,eol:¬

" Indentation options
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4

" Vim folds
set foldmethod=marker
set foldlevel=0

" save the file when switch buffers, make it etc.
set autowriteall

" Automatically check for changes
" I'm not sure Neovim needs that
"autocmd BufEnter * silent! checktime

" Taken from the NeoVim wiki
" All of those are set by defult in NeoVim
if !has("nvim")
	set syntax=ON
    set bg=dark
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

" ignore common files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o,*/source-pc/*,*/raspberrypi/*,*/.git/*

" Case-insensitive search
set wildignorecase
set ignorecase
set smartcase

" Enable per project .vimrc
set exrc
set secure

set tags=./tags,**5/tags,tags;~
"                          ^ in working dir, or parents
"                   ^ in any subfolder of working dir
"           ^ sibling of open file

if has("cscope")
	" Cscope config
	set cscopetag
	set cscopequickfix=a-,c-,d-,e-,i-,s-,t-

	" Gtags interface
	set csprg=gtags-cscope

	" add any database in current directory
	if filereadable("GTAGS")
		silent cs add GTAGS
	elseif filereadable("cscope.out")
	    silent cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    silent cs add $CSCOPE_DB
	endif
endif

augroup highlight_yank
	autocmd!
	autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END

autocmd BufWritePost *sxhkdrc !pkill -USR1 -x sxhkd
autocmd BufWritePost *init.vim source ~/.config/nvim/init.vim
autocmd BufWritePost *bspwmrc !bspc wm -r
autocmd BufWritePost *picom.conf !pkill -x picom && picom -b
autocmd BufWritePost *mpd.conf !mpd --kill && mpd
autocmd BufWritePost *termite/config !killall -USR1 termite

" Show netrw in tree style (i to change)
"let g:netrw_liststyle=3

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" AutoComplete Config
" Don't let autocomplete affect usual typing habits
"set completeopt+=menuone,preview,noinsert

" }}}
" {{{"""""" Plugs Config """"""

" HardTime in all buffers
let g:hardtime_default_on = 0
let g:hardtime_showmsg = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
let g:hardtime_ignore_quickfix = 1
let g:hardtime_allow_different_key = 1

" Automatically close nvim when everything else except NERDTree is closed
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1

" Gutentag Config
" enable gtags module
let g:gutentags_modules = ['ctags', 'cscope']
" config project root markers.
let g:gutentags_project_root = ['.repo']

" Git Config
" Let GitGutter do its thing on large files
let g:gitgutter_max_signs=50000
" GitGutter colors
" let g:gitgutter_override_sign_column_highlight = 0
" highlight clear SignColumn
" highlight GitGutterAdd ctermfg=10
" highlight GitGutterChange ctermfg=11
" highlight GitGutterDelete ctermfg=9
" highlight GitGutterChangeDelete ctermfg=14

" Vimagit config
" Go straight into insert mode when committing
autocmd User VimagitEnterCommit startinsert

" Vim Rooter Config
let g:rooter_manual_only = 1 " Improves Vim startup time
autocmd BufEnter * call FindRootDirectory() " Still autochange the directory
let g:rooter_silent_chdir = 1
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_resolve_links = 1

" If your terminal's background is white (light theme), uncomment the following
" to make EasyMotion's cues much easier to read.
" hi link EasyMotionTarget String
" hi link EasyMotionShade Comment
" hi link EasyMotionTarget2First String
" hi link EasyMotionTarget2Second Statement

" Ack config
"let g:ackprg = 'ag --vimgrep'
let g:ackprg = 'rg --vimgrep --smart-case'
let g:ackhighlight = 1
" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1
" Any empty ack search will search for the word the cursor is on
let g:ack_use_cword_for_empty_search = 1
" Don't jump to first match
cnoreabbrev Ack Ack!
command! -nargs=1 Nack Ack! "<args>" $NOTES/**
command! -nargs=1 Note e $NOTES/Scratch/<args>.md
command! Scratch exe "e $NOTES/Scratch/".strftime("%F-%H%M%S").".md"

" FZF Config
"let $FZF_DEFAULT_COMMAND = 'ag -g ""'
"let $FZF_DEFAULT_COMMAND = 'fd --type file'
"let $FZF_DEFAULT_COMMAND = 'rg --files -g ""'

" Show netrw in tree style (i to change)
let g:netrw_liststyle=3

" Nerd tree Config
let g:loaded_nerdtree_git_status = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Make :UltiSnipsEdit to split the window.
let g:UltiSnipsEditSplit="horizontal"
"let g:UltiSnipsSnippetDirectories=["~/.config/nvim/UltiSnips"]
"let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"

" YouCompleteMe configuration
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
" YouCompleteMe Pandoc integration
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.pandoc = ['@']
let g:ycm_filetype_blacklist = {}
let g:ycm_clangd_binary_path = '/usr/bin/clangd-9'

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

" PlantUML path

function s:gtags_search(line)

	let l:line = split(a:line)[1]
	let l:file = split(a:line)[2]
	execute 'edit +'.l:line l:file

endfunction

function s:gtags_preview(line)

	echo line
	let l:line = split(a:line)[1]
	let l:file = split(a:line)[2]
	return l:file.':'.l:line

endfunction

" }}}
" {{{ """""" Key Mappings """"""

nnoremap <silent> <Leader>t :call fzf#run(fzf#wrap({'source':'global -x .', 'sink':function('<sid>gtags_search'),
			\ 'options': ['-m', '-d', '\t', '--with-nth', '1,2', '-n', '1', '--prompt', 'Tags> ']}))<CR>

" Make life easier with exiting modes back to normal
imap jk <Esc>
vmap jk <Esc>

" " " Open netrw in CWD
" nmap <Leader>n :Rexplore .<cr>
" nmap <Leader>N :Sexplore .<cr>
" nmap \|N :Vexplore .<cr>
" " " Open netrw in the current file's dir
" nmap <Leader>v :Explore<cr>
" nmap <Leader>V :Sexplore<cr>
" nmap \|V :Vexplore<cr>

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

" Quick Ack
nnoremap // :Ack!<Space>
" Notes
nnoremap <Leader>wn :Nack<space>
nnoremap <Leader>ww :FZF $NOTES<cr>

" Insert date/time
inoremap <leader>d <C-r>=strftime('%a %d.%m.%Y %H:%M')<cr>
inoremap <leader>D <C-r>=strftime('%d.%m.%y')<cr>

" UltiSnips Bindings
let g:UltiSnipsExpandTrigger="<Leader><Leader>"

let g:UltiSnipsListSnippets="<Leader>s"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

map , <Plug>(easymotion-prefix)
" Toggle whitespaces
nmap <F6> :set list! <CR>
" Toggle the tags bar
nmap <F8> :TagbarToggle<CR>
" Toggle spell checking
nmap <F3> :setlocal spell! spelllang=en<CR>

" Turn off search highlight
nmap <Leader>/ :noh<cr>

nmap <Leader>yy :YcmCompleter GoTo<CR>
nmap <Leader>yc :YcmCompleter GoToReferences<CR>

nmap <Leader>yy :YcmCompleter GoTo<CR>
nmap <Leader>yc :YcmCompleter GoToReferences<CR>

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

" Start a Git command
nmap <Leader>gg :Git<Space>
nmap <Leader>gs :Git status<CR>
nmap <Leader>gv :Magit<CR>
"nmap <Leader>gcm :Git commit<CR>
nmap <Leader>gd :Git diff<CR>
nmap <Leader>gc :Gdiffsplit<CR>
nmap <Leader>gb :MerginalToggle<CR>

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

" Ctags in previw/split window
nnoremap <C-w><C-]> <C-w>}
nnoremap <C-w>} <C-w><C-]>

" Nuake Bindings
nnoremap <Leader>` :Nuake<CR>
inoremap <Leader>` <C-\><C-n>:Nuake<CR>
tnoremap <Leader>` <C-\><C-n>:Nuake<CR>

" Compile file (Markdown, LaTeX, etc)
" TODO: Auto-recognize build system
nmap <silent> <F6> :!compiler %<cr>
" }}}
