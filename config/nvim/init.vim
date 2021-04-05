""""""" Plug management """"""""{{{1
" Install vim-plug if it is not present
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
    quitall
endif

call plug#begin(stdpath("data").'/bundle')

" let VimPlug manage VimPlug, required
Plug 'junegunn/vim-plug'

" Get used to proper Vim movement
Plug 'takac/vim-hardtime'

" Add some additional text objects and attack them
Plug 'wellle/targets.vim'

" Reposition cursor in the last position up file reopening
Plug 'farmergreg/vim-lastplace'

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
if !executable('fzf')
    Plug 'junegunn/fzf', { 'dir': '~/.local/bin/fzf', 'do': { -> fzf#install() } }
endif
Plug 'junegunn/fzf.vim'

" Alternative file contents search
Plug 'mileszs/ack.vim'

" Autocompletion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" File browsing
"Plug 'kyazdani42/nvim-tree.lua' " Not as ripe as nerdtree, yet
Plug 'scrooloose/nerdtree', { 'on':  [ 'NERDTreeToggle', 'NERDTreeFind' ] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': [ 'NERDTreeToggle', 'NERDTreeFind' ] }
" Ranger file manager integration
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

" Ctags support
" Easytags replacement with support for Universal Ctags
"Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus' " Extra for Cscope
"Plug 'majutsushi/tagbar' " A bar with list of all the tags in the buffer
Plug 'liuchengxu/vista.vim'
"Plug 'xolox/vim-misc' " Required by easytags
"Plug 'xolox/vim-easytags'

" A - for switching between source and header files
Plug 'vim-scripts/a.vim'

" UltiSnips
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'norcalli/snippets.nvim' "To be revisited

" Remove extraneous whitespace when edit mode is exited
Plug 'thirtythreeforty/lessspace.vim'

" Bracket completion
"Plug 'Raimondi/delimitMate'
Plug 'cohama/lexima.vim'

" Tpope's plugins
Plug 'tpope/vim-surround' " surround vim
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps with .
Plug 'tpope/vim-eunuch' " Unix commands from Vim
Plug 'tpope/vim-commentary' " Comment blocks
" It appears I don't need that since Startify does the same
"Plug 'tpope/vim-obsession' " Vim session management

" Imporve % for if..else and such
" Does Neovim need this? I think Neovim has it built in
"Plug 'adelarsq/vim-matchit'

" Some help with the keys
Plug 'liuchengxu/vim-which-key'

" External App Integration
" API documentation
Plug 'KabbAmine/zeavim.vim', { 'on': ['Zeavim', 'Zeavim!', 'ZeavimV', 'ZeavimV!'] }
" The ultimate cheat sheet
Plug 'dbeniamine/cheat.sh-vim', { 'on' : ['Cheat'] }
" Read GNU Info from vim
"Plug 'alx741/vinfo'
Plug 'HiPhish/info.vim', {'on' : 'Info'}

" Notes, to-do, etc
Plug 'vimwiki/vimwiki'
Plug 'vimwiki/utils'

" Language specific plugins
Plug 'kovetskiy/sxhkd-vim', { 'for': 'sxhkd' }
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
Plug 'vhdirk/vim-cmake', { 'for': 'cmake' }
Plug 'vim-pandoc/vim-pandoc', { 'for': 'markdown' }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': 'markdown' }
Plug 'kergoth/vim-bitbake', { 'for': 'bitbake' }
Plug 'Matt-Deacalion/vim-systemd-syntax', { 'for': 'systemd' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'

" PlanUML support and preview
Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
Plug 'scrooloose/vim-slumlord', { 'for': 'plantuml' }

" Pop-up the built in terminal
if has("nvim")
	Plug 'Lenovsky/nuake', { 'on': 'Nuake' }
endif

" Eye Candy
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

" Color colorcodes
Plug 'norcalli/nvim-colorizer.lua'
" Color brackets
Plug 'junegunn/rainbow_parentheses.vim'

" Start screen
Plug 'mhinz/vim-startify'

" Highlight same words as under cursor
Plug 'RRethy/vim-illuminate'

" Use pywal theme
"Plug 'dylanaraps/wal.vim'

" Load this one last
Plug 'ryanoasis/vim-devicons'
" Goes together with nvim-tree.lua
"Plug 'kyazdani42/nvim-web-devicons' " for file icons
call plug#end()
" }}}
""""""" General Vim Config """""""{{{1

set termguicolors
" Colorscheme wal
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'

" Highlight embedded lua code
let g:vimsyn_embed = 'l'

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
set listchars=tab:\|\ ,space:·,trail:·,extends:·,precedes:·,nbsp:·,eol:¬

" Indentation options
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4

" Vim folds
set foldmethod=marker
set foldlevel=1

" save the file when switch buffers, make it etc.
set autowriteall

" Automatically check for changes
" I'm not sure Neovim needs that
"autocmd BufEnter * silent! checktime

" Ignore common files
" Important not to have code related directories, as it affects native LSP's
" root directory search pattern
set wildignore+=*.so,*.swp,*.zip,*.o,*.la

" Case-insensitive search
set wildignorecase
set ignorecase
set smartcase

" Enable per project .vimrc
set exrc
set secure

" Integrate RipGrep
if executable('rg')
    set grepprg="rg --with-filename --no-heading $* /dev/null"
endif

" Tags magic {{{2

set tags=./tags,**5/tags,tags;~
"                          ^ in working dir, or parents
"                   ^ in any subfolder of working dir
"           ^ sibling of open file

if has("cscope")
	" Cscope config
	set cscopetag
    " Search first ctags and then cscope
    set cscopetagorder=1
	set cscopequickfix=a-,c-,d-,e-,i-,s-,t-

	" add any database in current directory
	if filereadable("GTAGS")
        " Gtags interface
        set csprg=gtags-cscope
		silent cs add GTAGS
	elseif filereadable("cscope.out")
	    silent cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    silent cs add $CSCOPE_DB
    elseif $GTAGSLIBPATH != ""
        " Gtags interface
        set csprg=gtags-cscope
         for lib in split($GTAGSLIBPATH, ":")
             exe "silent cs add ".lib."/GTAGS ".$GTAGSROOT." -a"
         endfor
	elseif $GTAGSDBPATH != ""
        " Gtags interface
        set csprg=gtags-cscope
	    silent cs add $GTAGSDBPATH/GTAGS
	endif
endif
" }}}

" Autocommands {{{2
augroup highlight_yank
	autocmd!
	autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout='1000'})
augroup END

autocmd BufWritePost *sxhkdrc !pkill -USR1 -x sxhkd
autocmd BufWritePost *init.vim source ~/.config/nvim/init.vim
autocmd BufWritePost *bspwmrc !bspc wm -r
autocmd BufWritePost *picom.conf !pkill -x picom && picom -b
autocmd BufWritePost *mpd.conf !mpd --kill && mpd
autocmd BufWritePost *termite/config !killall -USR1 termite
autocmd BufWritePost *qtile/config.py !qtile-cmd -o cmd -f restart > /dev/null 2&>1
" }}}

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" AutoComplete Config {{{2
" Don't let autocomplete affect usual typing habits
set completeopt=menuone,noinsert ",noselect
"                 |        |          ^ Don't select anything in the menu
"                 |        |            without my interaction
"                 |        ^ Don't insert text without my interaction
"                 |          Strongly affects the typing experience
"                 ^ Open a menu even if there is only one
"                   completion candidate. Usefull for the
"                   extra about the completion candidate
let g:completion_enable_snippet = 'UltiSnips'
" Snippets vim looks good, but is not ripe yet
"let g:completion_enable_snippet = 'snippets.nvim'
" }}}
" }}}

""""""" Plugs Config """"""{{{1

" Autocompletion {{{2
autocmd BufEnter * lua require'completion'.on_attach()
" possible value: "length", "alphabet", "none"
let g:completion_sorting = "length"
let g:completion_matching_strategy_list = ['fuzzy', 'exact', 'substring', 'all']
let g:completion_matching_smart_case = 1
"}}}

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
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1

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
autocmd BufEnter * Rooter " Still autochange the directory
let g:rooter_silent_chdir = 1
let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_resolve_links = 1
let g:rooter_patterns = ['compile_commands.json', '.git']

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

" Pandoc configuration
let g:pandoc#command#custom_open='zathura'
let g:pandoc#command#prefer_pdf=1
let g:pandoc#command#autoexec_command="Pandoc! pdf"
let g:pandoc#completion#bib#mode='citeproc'

" PlantUML path
let g:plantuml_executable_script='java -jar $NFS/plantuml.jar'

" Startify {{{2

let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 0 " Rooter does that better
let g:startify_change_to_dir = 0 " Rooter does that
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_enable_special = 0
let g:startify_relative_path = 1

let g:startify_lists = [
          \ { 'type': 'dir',       'header': ['   Current Directory: '. getcwd()]  },
          \ { 'type': 'files',     'header': ['   Files']             },
          \ { 'type': 'sessions',  'header': ['   Sessions']        },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']       },
          \ ]

let g:startify_bookmarks = [
            \ { 'i': '~/.config/nvim/init.vim'  },
            \ { 'b': '~/.bashrc'  },
            \ { 'u': '~/.bashrc.'.$USER  },
            \ ]

let g:nabaco = [
\ '     _   __            ____            ______        ',
\ '    / | / /  ____ _   / __ )  ____ _  / ____/  ____  ',
\ '   /  |/ /  / __ `/  / __  | / __ `/ / /      / __ \ ',
\ '  / /|  /  / /_/ /  / /_/ / / /_/ / / /___   / /_/ / ',
\ ' /_/ |_/   \__,_/  /_____/  \__,_/  \____/   \____/  ',
\ ]

"let g:nabaco = [
"            \ '   ) ',
"            \ ' ( /(            (             ( ',
"            \ ' )\())     )   ( )\      )     )\ ',
"            \ '((_)\   ( /(   )((_)  ( /(   (((_)    ( ',
"            \ ' _((_)  )(_)) ((_)_   )(_))  )\___    )\ ',
"            \ '| \| | ((_)_   | _ ) ((_)_  ((/ __|  ((_) ',
"            \ '| .` | / _` |  | _ \ / _` |  | (__  / _ \ ',
"            \ '|_|\_| \__,_|  |___/ \__,_|   \___| \___/ ',
"            \]

"let g:nabaco = [
"\ '  __  __            ____              ____            __ ',
"\ ' /\ \/\ \          /\  _`\           /\  _`\         /\ \ ',
"\ ' \ \ `\\ \     __  \ \ \L\ \     __  \ \ \/\_\    ___\ \ \ ',
"\ '  \ \ , ` \  /`__`\ \ \  _ <`  /`__`\ \ \ \/_/_  / __`\ \ \ ',
"\ '   \ \ \`\ \/\ \L\.\_\ \ \L\ \/\ \L\.\_\ \ \L\ \/\ \L\ \ \_\ ',
"\ '    \ \_\ \_\ \__/.\_\\ \____/\ \__/.\_\\ \____/\ \____/\/\_\ ',
"\ '     \/_/\/_/\/__/\/_/ \/___/  \/__/\/_/ \/___/  \/___/  \/_/ ',
"\]


let g:startify_custom_header =  'startify#center(g:nabaco) + startify#center(startify#fortune#boxed())'

" }}}

" Colorizer && Rainbow {{{2

lua << EOF
require'colorizer'.setup(
  {'*';},
  {
    RGB      = true;         -- #RGB hex codes
	  RRGGBB   = true;         -- #RRGGBB hex codes
	  names    = true;         -- "Name" codes like Blue
	  RRGGBBAA = true;         -- #RRGGBBAA hex codes
	  rgb_fn   = true;         -- CSS rgb() and rgba() functions
	  hsl_fn   = true;         -- CSS hsl() and hsla() functions
	  css      = true;         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
	  css_fn   = true;         -- Enable all CSS *functions*: rgb_fn, hsl_fn
  })
EOF

let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

autocmd FileType * RainbowParentheses
" }}}
" }}}

""""""" Key Mappings """""" {{{1
call which_key#register('\\', "g:which_key_map")
let g:which_key_map =  {}

nnoremap <silent> <leader> :<c-u>WhichKey '\\'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '\\'<CR>

" Make life easier with exiting modes back to normal
inoremap jk <Esc>
vnoremap jk <Esc>

" Open netrw in CWD
"nnoremap <Leader>n :Rexplore .<cr>
"nnoremap <Leader>N :Sexplore .<cr>
"nnoremap \|N :Vexplore .<cr>
"  Open netrw in the current file's dir
"nnoremap <Leader>v :Explore<cr>
"nnoremap <Leader>V :Sexplore<cr>
"nnoremap \|V :Vexplore<cr>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>v :NERDTreeFind<CR>
let g:which_key_map.n = ['NERDTreeToggle', 'File Tree']
let g:which_key_map.v = ['NERDTreeFind', 'Find File']

nnoremap <leader>s <cmd>Startify<CR>
let g:which_key_map.s = ['Startify', 'Startify']

" Cscope and quickfix {{{2

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
let g:which_key_map.c = { 'name': '+cscope' }
let g:which_key_map.c.s = ['cs find g', 'symbol']

" Jump to result
nnoremap <Leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>ce :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <Leader>ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <Leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>ca :cs find a <C-R>=expand("<cword>")<CR><CR>

" Open the result in a split
nnoremap <Leader>Cs :scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>Cg :scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>Cc :scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>Ct :scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>Ce :scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>Cf :scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <Leader>Ci :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <Leader>Cd :scs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>Ca :scs find a <C-R>=expand("<cword>")<CR><CR>

" Open the result in a vertical split
nnoremap <Leader>CS :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>CG :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>CC :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>CT :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>CE :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>CF :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <Leader>CI :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <Leader>CD :vert scs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>CA :vert scs find a <C-R>=expand("<cword>")<CR><CR>

" Quickfix bindings
nnoremap ]q :cnext<cr>
nnoremap ]Q :clast<cr>
nnoremap [q :cprevious<cr>
nnoremap [Q :cfirst<cr>
nnoremap <Leader>q :ccl<cr>

" }}}

" Language Server{{{2
lua << EOF
    local lspconfig = require('lspconfig')

    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Mappings.
        local opts = { noremap=true, silent=true }
        buf_set_keymap('n', '<leader>lD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', '<leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<leader>lh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
        buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<leader>ds', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<leader>dq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

        -- Vista config
        vim.api.nvim_set_var('vista_default_executive', 'nvim_lsp')
        buf_set_keymap('n', '<leader>t', '<cmd>Vista finder<CR>', opts)

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.resolved_capabilities.document_range_formatting then
            buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
            vim.api.nvim_exec([[
                hi LspReferenceRead cterm=bold ctermbg=red guibg=Orange
                hi LspReferenceText cterm=bold ctermbg=red guibg=Orange
                hi LspReferenceWrite cterm=bold ctermbg=red guibg=Orange
                augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]], false)
        end
    end

    -- Use a loop to conveniently both setup defined servers
    -- and map buffer local keybindings when the language server attaches
    local servers = { "jedi_language_server" }
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup { on_attach = on_attach }
    end

    lspconfig.clangd.setup{
        -- cmd = { "clangd", "--background-index", "--cross-file-rename", "--limit-results=0", "-j=$(nproc)" };
        on_attach = on_attach;
        root_dir = function(fname)
            return lspconfig.util.root_pattern("compile_commands.json")(fname) or
            lspconfig.util.root_pattern("compile_flags.txt", ".clangd", ".git")(fname);
        end
        }

EOF

let g:which_key_map.l = {
            \ 'name': '+LSP',
            \ 'D': ['lua vim.lsp.buf.declaration()'    , 'Declaration']   ,
            \ 'd': ['lua vim.lsp.buf.definition()'     , 'Definition']    ,
            \ 'h': ['lua vim.lsp.buf.hover()'          , 'Hover']         ,
            \ 'i': ['lua vim.lsp.buf.implementation()' , 'Implementation'],
            \ 's': ['lua vim.lsp.buf.signature_help()' , 'Sig-Help']      ,
            \ 't': ['lua vim.lsp.buf.type_definition()', 'Type-Def']      ,
            \ 'R': ['lua vim.lsp.buf.rename()'         , 'Rename']        ,
            \ 'r': ['lua vim.lsp.buf.references()'     , 'Refs']          ,
            \ 'f': ['lua vim.lsp.buf.formatting()'     , 'Format']        ,
            \}

let g:which_key_map.d = {
            \ 'name': '+Diagnostics',
            \ 's': ['lua vim.lsp.diagnostic.show_line_diagnostics()', 'Show-Daigs'],
            \ 'q': ['lua vim.lsp.diagnostic.set_loclist()', 'Diags2LocList'],
            \}

let g:which_key_map.w = {
            \ 'name': '+Workspace',
            \ 'a': ['lua vim.lsp.buf.add_workspace_folder()', 'Add-Folder'],
            \ 'r': ['lua vim.lsp.buf.remove_workspace_folder()', 'Remove-Folder'],
            \ 'l': ['lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))', 'List-Folders'],
            \}
"}}}

" Quick Ack
nnoremap /<Leader> :Ack!<Space>
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

" Turn off search highlight
nnoremap <Leader>/ :noh<cr>

" Fuzzy-find lite
nnoremap <Leader><space> :e ./**/
"nnoremap <Leader><cr> :buffer

" FZF bindings
nnoremap <Leader><cr> <CMD>Buffers<CR>
nnoremap <Leader>f <CMD>FZF<CR>
nnoremap <Leader>t <CMD>Tags<CR>
nnoremap <Leader>T <CMD>BTags<CR>
nnoremap <Leader>m <CMD>Commits<CR>
nnoremap <Leader>M <CMD>BCommits<CR>

" Start a Git command
nnoremap <Leader>gg :Git<Space>
nnoremap <Leader>gs :Git status<CR>
nnoremap <Leader>gv :Magit<CR>
"nnoremap <Leader>gcm :Git commit<CR>
nnoremap <Leader>gd :Git diff<CR>
nnoremap <Leader>gc :Gdiffsplit<CR>
nnoremap <Leader>gb :MerginalToggle<CR>

" Spellchecking Bindings
imap <m-f> <C-G>u<Esc>[s1z=`]a<C-G>u
nnoremap <m-f> [s1z=<c-o>

" Toggle whitespaces
nnoremap <F2> :set list! <CR>
" Toggle spell checking
nnoremap <F3> :setlocal spell! spelllang=en<CR>
" real make
noremap <silent> <F5> :make<cr><cr><cr>
" GNUism, for building recursively
noremap <silent> <s-F5> :make -w<cr><cr><cr>
" Toggle the tags bar
nnoremap <F8> :Vista<CR>

" Ctags in previw/split window
nnoremap <C-w><C-]> <C-w>}
nnoremap <C-w>} <C-w><C-]>

" Nuake Bindings
nnoremap <Leader>` :Nuake<CR>
inoremap <Leader>` <C-\><C-n>:Nuake<CR>
tnoremap <Leader>` <C-\><C-n>:Nuake<CR>

" Compile file (Markdown, LaTeX, etc)
" TODO: Auto-recognize build system
nnoremap <silent> <F6> :!compiler %<cr>

inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" }}}
