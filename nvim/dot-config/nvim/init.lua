-- """"""" Plug management """"""""{{{1

local install_path = vim.fn.stdpath('data')..'/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  paq_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/savq/paq-nvim.git', install_path})
  vim.cmd('packadd paq-nvim')
end

local paq = require "paq" {
    -- "savq/paq-nvim";            -- Paq manages itself
    -- " Get used to proper Vim movement
    'takac/vim-hardtime';

    -- " Add some additional text objects and attack them
    'wellle/targets.vim';

    -- " Reposition cursor in the last position up file reopening
    'farmergreg/vim-lastplace';

    -- " Git support
    'tpope/vim-fugitive'; -- "Only for FZF integration
    'idanarye/vim-merginal'; -- "Branch TUI based on fugitive
    'jreybert/vimagit'; -- "Easier stage/commit workflow
    'airblade/vim-gitgutter'; -- "Show changes live + 'hunk/change' text object
    'rhysd/git-messenger.vim'; -- "Git blame in bubbles

    --if vim.fn.has("Win32") then
    --    { 'Shougo/vimproc.vim', run='nmake'};
    --end

    -- " Vim Rooter - needed for all the git plugins to work correctly,
    -- " in a multi-repo environment
    'airblade/vim-rooter';

    -- " Puts all vim navigation keys on drugs! f,t,w,b,e etc..
    'easymotion/vim-easymotion';

    -- " Ultimate fuzzy search + Multi-entry selection UI.
    -- TODO: if fn.empty(fn.glob('/usr/bin/fzf')) > 0 then
        -- " Binary is installed through package manager.
        -- " Install just the latest plugin without installing FZF itself
    --    'junegunn/fzf';
    -- else
        {'junegunn/fzf', run=vim.fn["fzf#install()"]};
    --end
    'junegunn/fzf.vim';

    -- " Alternative file contents search
    'mileszs/ack.vim';

    -- " Autocompletion
    'neovim/nvim-lspconfig';
    'glepnir/lspsaga.nvim';
    {'hrsh7th/cmp-nvim-lsp', branch='main'};
    {'hrsh7th/cmp-buffer', branch='main'};
    {'hrsh7th/cmp-path', branch='main'};
    {'hrsh7th/cmp-cmdline', branch='main'};
    {'hrsh7th/nvim-cmp', branch='main'};
    {'quangnguyen30192/cmp-nvim-ultisnips', branch='main'};

    -- " File browsing
    -- "'kyazdani42/nvim-tree.lua' -- "Not as ripe as nerdtree, yet;
    -- TODO: Redo with lazy loading
	-- {'scrooloose/nerdtree', 'on':  [ 'NERDTreeToggle', 'NERDTreeFind' ] };
    -- {'Xuyuanp/nerdtree-git-plugin', 'on': [ 'NERDTreeToggle', 'NERDTreeFind' ] };
	{'scrooloose/nerdtree'};
    {'Xuyuanp/nerdtree-git-plugin'};
    -- " Ranger file manager integration
    {'kevinhwang91/rnvimr', run='make sync'};

    -- " Ctags support
    -- " Easytags replacement with support for Universal Ctags
    -- "'ludovicchabant/vim-gutentags';
    -- " 'skywind3000/gutentags_plus' -- "Extra for Cscope;
    -- "'majutsushi/tagbar' -- "A bar with list of all the tags in the buffer;
    'liuchengxu/vista.vim';
    -- "'xolox/vim-misc' -- "Required by easytags;
    -- "'xolox/vim-easytags';

    -- " A - for switching between source and header files
    'vim-scripts/a.vim';

    -- " UltiSnips
    'SirVer/ultisnips';
    'honza/vim-snippets';
    -- "'norcalli/snippets.nvim' "To be revisited;

    -- " Remove extraneous whitespace when edit mode is exited
    'thirtythreeforty/lessspace.vim';

    -- " Bracket completion
    -- "'Raimondi/delimitMate';
    'cohama/lexima.vim';

    -- " Tpope's plugins
    'tpope/vim-surround'; -- "surround vim
    'tpope/vim-repeat'; -- "Enable repeating supported plugin maps with .
    'tpope/vim-eunuch'; -- "Unix commands from Vim
    'tpope/vim-commentary'; -- "Comment blocks
    -- " It appears I don't need that since Startify does the same
    -- "'tpope/vim.opt.session' -- "Vim session management

    -- " Imporve % for if..else and such
    -- " Does Neovim need this? I think Neovim has it built in
    -- "'adelarsq/vim-matchit';

    -- " Some help with the keys
    --'liuchengxu/vim-which-key';
    'folke/which-key.nvim';

    -- " External App Integration
    -- " API documentation
    -- TODO: 'KabbAmine/zeavim.vim', { 'on': ['Zeavim', 'Zeavim!', 'ZeavimV', 'ZeavimV!'] };
    -- " The ultimate cheat sheet
    -- TODO: 'dbeniamine/cheat.sh-vim', { 'on' : ['Cheat'] };
    -- " Read GNU Info from vim
    -- "'alx741/vinfo';
    -- TODO: 'HiPhish/info.vim', {'on' : 'Info'};

    -- " Notes, to-do, etc
    'vimwiki/vimwiki';
    'vimwiki/utils';

    -- " Task Warrior integration
    'tools-life/taskwiki';
    'farseer90718/vim-taskwarrior';
    'powerman/vim-plugin-AnsiEsc';

    -- " Language specific plugins
    -- TODO: 'kovetskiy/sxhkd-vim', { 'for': 'sxhkd' };
    -- TODO: 'chrisbra/csv.vim', { 'for': 'csv' };
    -- TODO: 'vhdirk/vim-cmake', { 'for': 'cmake' };
    -- TODO: 'vim-pandoc/vim-pandoc', { 'for': 'markdown' };
    -- TODO: 'vim-pandoc/vim-pandoc-syntax', { 'for': 'markdown' };
    -- TODO: 'kergoth/vim-bitbake', { 'for': 'bitbake' };
    -- TODO: 'Matt-Deacalion/vim-systemd-syntax', { 'for': 'systemd' };
    -- TODO: 'cespare/vim-toml', { 'for': 'toml' };
    'tmux-plugins/vim-tmux';
    'tmux-plugins/vim-tmux-focus-events';
    'mfukar/robotframework-vim';

    -- " PlanUML support and preview
    -- TODO: 'aklt/plantuml-syntax', { 'for': 'plantuml' };
    -- TODO: 'scrooloose/vim-slumlord', { 'for': 'plantuml' };

    -- " Pop-up the built in terminal
	'Lenovsky/nuake';

    -- " Eye Candy
    'morhetz/gruvbox';
    'vim-airline/vim-airline';

    -- " Color colorcodes
    'norcalli/nvim-colorizer.lua';
    -- " Color brackets
    'junegunn/rainbow_parentheses.vim';

    -- " Start screen
    'mhinz/vim-startify';

    -- " Highlight same words as under cursor
    'RRethy/vim-illuminate';

    -- " Use pywal theme
    -- "'dylanaraps/wal.vim';

    -- " Load this one last
    'ryanoasis/vim-devicons';
    -- " Goes together with nvim-tree.lua
    -- "'kyazdani42/nvim-web-devicons' -- "for file icons;
}

if paq_bootstrap then
    paq.sync()
end
-- " }}}
-- """"""" General Vim Config """""""{{{1

vim.opt.termguicolors = true
-- " Colorscheme wal
vim.cmd('colorscheme gruvbox')
vim.g.gruvbox_contrast_dark = 'hard'

-- " Highlight embedded lua code
vim.g.vimsyn_embed = 'l'

-- " Set environment variable to be able to start vim in :terminal
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

-- " Sync clipboards with system
vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'

-- " Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- " Enable mouse, but in normal mode
vim.opt.mouse=n

-- " Open split the sane way
vim.opt.splitright=true
vim.opt.splitbelow=true

-- " Hide buffer when closed
vim.opt.hidden=true

-- " Vimdiff to open vertical splits
-- " I don't understand how can anyone work otherwise
vim.opt.diffopt = vim.opt.diffopt + 'vertical'

-- " Start scrolling three lines before the horizontal window border
vim.opt.scrolloff=3
vim.opt.sidescrolloff=10

-- " Show matching brackets
vim.opt.showmatch = true

-- " persist the undo tree for each file
vim.opt.undofile=true

-- " Highlight edge column
vim.opt.colorcolumn='100'
-- " Let plugins show effects after 500ms, not 4s
--vim.opt.updatetime=500
-- " Show whitespaces
vim.opt.listchars = {tab = '| ', space = '·', trail = '·', extends = '·', precedes = '·', nbsp = '·', eol = '¬'}

-- " Indentation options
vim.opt.tabstop=4
vim.opt.expandtab=true
vim.opt.softtabstop=4
vim.opt.shiftwidth=4

-- " Vim folds
vim.opt.foldmethod='marker'
vim.opt.foldlevel=1

-- " save the file when switch buffers, make it etc.
vim.opt.autowriteall = true

-- " Automatically check for changes
-- " I'm not sure Neovim needs that
-- "autocmd BufEnter * silent! checktime

-- " Ignore common files
-- " Important not to have code related directories, as it affects native LSP's
-- " root directory search pattern
vim.opt.wildignore = vim.opt.wildignore + '*.so,*.swp,*.zip,*.o,*.la'

-- " Case-insensitive search
vim.opt.wildignorecase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- " Enable per project .vimrc
vim.opt.exrc = true
vim.opt.secure = true

-- " Integrate RipGrep
if vim.fn.executable('rg') then
    vim.opt.grepprg="rg --with-filename --no-heading $* /dev/null"
end

-- " Tags magic {{{2

vim.opt.tags='./tags,**5/tags,tags;~'
-- "                          ^ in working dir, or parents
-- "                   ^ in any subfolder of working dir
-- "           ^ sibling of open file

--[[ NABACO


augroup highlight_yank
	autocmd!
	autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout='1000'})
augroup END

autocmd BufWritePost *sxhkdrc !pkill -USR1 -x sxhkd
autocmd BufWritePost *init.vim source ~/.config/nvim/init.vim
autocmd BufWritePost *init.lua source ~/.config/nvim/init.lua
autocmd BufWritePost *bspwmrc !bspc wm -r
autocmd BufWritePost *picom.conf !pkill -x picom && picom -b
autocmd BufWritePost *mpd.conf !mpd --kill && mpd
autocmd BufWritePost *termite/config !killall -USR1 termite
autocmd BufWritePost *qtile/config.py !qtile-cmd -o cmd -f restart > /dev/null 2&>1
-- " }}}

NABACO ]]
vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/bin/python3'

-- " AutoComplete Config {{{2
-- " Don't let autocomplete affect usual typing habits
vim.opt.completeopt=menuone,noinsert,noselect
-- "                 |        |          ^ Don't select anything in the menu
-- "                 |        |            without my interaction
-- "                 |        ^ Don't insert text without my interaction
-- "                 |          Strongly affects the typing experience
-- "                 ^ Open a menu even if there is only one
-- "                   completion candidate. Usefull for the
-- "                   extra about the completion candidate
-- " }}}
-- " }}}

-- """"""" Plugs Config """"""{{{1
-- " Autocompletion {{{2

local t=function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete()
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
					vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
				else
					fallback()
				end
			end,
			s = function(fallback)
				if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
					vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
				else
					fallback()
				end
			end
		}),
		["<S-Tab>"] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete()
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
					return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
				else
					fallback()
				end
			end,
			s = function(fallback)
				if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
					return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
				else
					fallback()
				end
			end
		}),
		['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
		['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
		['<C-n>'] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				else
					vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				else
					fallback()
				end
			end
		}),
		['<C-p>'] = cmp.mapping({
			c = function()
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				else
					vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
				end
			end,
			i = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				else
					fallback()
				end
			end
		}),
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
		['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
		['<CR>'] = cmp.mapping({
			i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
			c = function(fallback)
				if cmp.visible() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
				else
					fallback()
				end
			end
		}),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' }
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	completion = { autocomplete = false },
	sources = {
		-- { name = 'buffer' }
		{ name = 'buffer', opts = { keyword_pattern = [=[[^[:blank:]].*]=] } }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	completion = { autocomplete = false },
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})
-- "}}}

-- " HardTime in all buffers
vim.g.hardtime_default_on = 0
vim.g.hardtime_showmsg = 1
vim.g.hardtime_ignore_buffer_patterns = { "NERD.*" }
vim.g.hardtime_ignore_quickfix = 1
vim.g.hardtime_allow_different_key = 1

-- " Automatically close nvim when everything else except NERDTree is closed
vim.cmd('autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif')

-- "set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"
vim.g['airline#extensions#tabline#formatter'] = 'unique_tail'
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#whitespace#enabled'] = 0
vim.g.airline_powerline_fonts = 1

-- " Gutentag Config
-- " enable gtags module
vim.g.gutentags_modules = {'ctags', 'cscope'}
-- " config project root markers.
vim.g.gutentags_project_root = {'.repo'}

-- " Git Config
-- " Let GitGutter do its thing on large files
vim.g.gitgutter_max_signs=50000
-- " GitGutter colors
-- " vim.g.gitgutter_override_sign_column_highlight = 0
-- " highlight clear SignColumn
-- " highlight GitGutterAdd ctermfg=10
-- " highlight GitGutterChange ctermfg=11
-- " highlight GitGutterDelete ctermfg=9
-- " highlight GitGutterChangeDelete ctermfg=14

-- " Vimagit config
-- " Go straight into insert mode when committing
vim.cmd('autocmd User VimagitEnterCommit startinsert')

-- " Vim Rooter Config
vim.g.rooter_manual_only = 1 -- " Improves Vim startup time
vim.cmd('autocmd BufEnter * Rooter') -- " Still autochange the directory
vim.g.rooter_silent_chdir = 1
vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.rooter_resolve_links = 1
vim.g.rooter_patterns = {'compile_commands.json', '.git'}

-- " If your terminal's background is white (light theme), uncomment the following
-- " to make EasyMotion's cues much easier to read.
-- " hi link EasyMotionTarget String
-- " hi link EasyMotionShade Comment
-- " hi link EasyMotionTarget2First String
-- " hi link EasyMotionTarget2Second Statement

-- " Ack config
-- "vim.g.ackprg = 'ag --vimgrep'
vim.g.ackprg = 'rg --vimgrep --smart-case'
vim.g.ackhighlight = 1
-- " Auto close the Quickfix list after pressing '<enter>' on a list item
vim.g.ack_autoclose = 1
-- " Any empty ack search will search for the word the cursor is on
vim.g.ack_use_cword_for_empty_search = 1
-- " Don't jump to first match
--[[ TODO:
cnoreabbrev Ack Ack!
command! -nargs=1 Nack Ack! "<args>" $NOTES/**
command! -nargs=1 Note e $NOTES/Scratch/<args>.md
command! Scratch exe "e $NOTES/Scratch/".strftime("%F-%H%M%S").".md"
]]

-- " FZF Config
-- "let $FZF_DEFAULT_COMMAND = 'ag -g ""'
-- "let $FZF_DEFAULT_COMMAND = 'fd --type file'
-- "let $FZF_DEFAULT_COMMAND = 'rg --files -g ""'

-- " Show netrw in tree style (i to change)
vim.g.netrw_liststyle=3

-- " Nerd tree Config
vim.g.loaded_nerdtree_git_status = 1
vim.NERDTreeQuitOnOpen = 1
vim.NERDTreeMinimalUI = 1
vim.NERDTreeDirArrows = 1

-- " Make :UltiSnipsEdit to split the window.
vim.g.UltiSnipsEditSplit="horizontal"
-- "vim.g.UltiSnipsSnippetDirectories=["~/.config/nvim/UltiSnips"]
-- "vim.g.UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"

-- " Pandoc configuration
vim.g['pandoc#command#custom_open']='zathura'
vim.g['pandoc#command#prefer_pdf']=1
vim.g['pandoc#command#autoexec_command']="Pandoc! pdf"
vim.g['pandoc#completion#bib#mode']='citeproc'

-- " PlantUML path
vim.g.plantuml_executable_script='java -jar $NFS/plantuml.jar'

-- " Startify {{{2

vim.g.startify_session_autoload = 1
vim.g.startify_session_delete_buffers = 1
vim.g.startify_change_to_vcs_root = 0 -- " Rooter does that better
vim.g.startify_change_to_dir = 0 -- " Rooter does that
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_persistence = 1
vim.g.startify_enable_special = 0
vim.g.startify_relative_path = 1

vim.g.startify_lists = {
{ type= 'dir',       header= {'   Current Directory: '.. vim.fn.getcwd()}  },
{ type= 'files',     header= {'   Files'}             },
{ type= 'sessions',  header= {'   Sessions'}        },
{ type= 'bookmarks', header= {'   Bookmarks'}       },
}

vim.g.startify_bookmarks = {
{ i= '~/.config/nvim/init.vim'  },
{ b= '~/.bashrc'  },
{ u= '~/.bashrc.'..vim.env.USER  },
}

vim.g.nabaco = {
'     _   __            ____            ______        ',
'    / | / /  ____ _   / __ )  ____ _  / ____/  ____  ',
'   /  |/ /  / __ `/  / __  | / __ `/ / /      / __ \\ ',
'  / /|  /  / /_/ /  / /_/ / / /_/ / / /___   / /_/ / ',
' /_/ |_/   \\__,_/  /_____/  \\__,_/  \\____/   \\____/  ',
}

-- "vim.g.nabaco = [
-- "            \ '   ) ',
-- "            \ ' ( /(            (             ( ',
-- "            \ ' )\())     )   ( )\      )     )\ ',
-- "            \ '((_)\   ( /(   )((_)  ( /(   (((_)    ( ',
-- "            \ ' _((_)  )(_)) ((_)_   )(_))  )\___    )\ ',
-- "            \ '| \| | ((_)_   | _ ) ((_)_  ((/ __|  ((_) ',
-- "            \ '| .` | / _` |  | _ \ / _` |  | (__  / _ \ ',
-- "            \ '|_|\_| \__,_|  |___/ \__,_|   \___| \___/ ',
-- "            \]

-- "vim.g.nabaco = [
-- "\ '  __  __            ____              ____            __ ',
-- "\ ' /\ \/\ \          /\  _`\           /\  _`\         /\ \ ',
-- "\ ' \ \ `\\ \     __  \ \ \L\ \     __  \ \ \/\_\    ___\ \ \ ',
-- "\ '  \ \ , ` \  /`__`\ \ \  _ <`  /`__`\ \ \ \/_/_  / __`\ \ \ ',
-- "\ '   \ \ \`\ \/\ \L\.\_\ \ \L\ \/\ \L\.\_\ \ \L\ \/\ \L\ \ \_\ ',
-- "\ '    \ \_\ \_\ \__/.\_\\ \____/\ \__/.\_\\ \____/\ \____/\/\_\ ',
-- "\ '     \/_/\/_/\/__/\/_/ \/___/  \/__/\/_/ \/___/  \/___/  \/_/ ',
-- "\]


vim.g.startify_custom_header =  'startify#center(g:nabaco) + startify#center(startify#fortune#boxed())'

-- " }}}

-- " Colorizer && Rainbow {{{2

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

vim.g['rainbow#max_level']= 16
vim.g['rainbow#pairs']= {{'(', ')'}, {'[', ']'}, {'{', '}'}}
vim.cmd('autocmd FileType * RainbowParentheses')
-- " }}}
-- " }}}
-- """"""" Key Mappings """""" {{{1
local map = function(key)
  -- get the extra options
  local opts = {noremap = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end

-- " Make life easier with exiting modes back to normal
map{'i', 'jk', '<Esc>'}
map{'v', 'jk', '<Esc>'}

-- " Open netrw in CWD
-- "map{'n', '<Leader>n', ':Rexplore .<cr>'}
-- "map{'n', '<Leader>N', ':Sexplore .<cr>'}
-- "map('n', \|N :Vexplore .<cr>
-- "  Open netrw in the current file's dir
-- "map{'n', '<Leader>v', ':Explore<cr>'}
-- "map{'n', '<Leader>V', ':Sexplore<cr>'}
-- "map('n', \|V :Vexplore<cr>
map{'n', '<Leader>n', ':NERDTreeToggle<CR>'}
map{'n', '<Leader>v', ':NERDTreeFind<CR>'}

map{'n', '<leader>s', '<cmd>Startify<CR>'}

-- " Cscope and quickfix {{{2

-- "0 or s: Find this C symbol
-- "1 or g: Find this definition
-- "2 or d: Find functions called by this function
-- "3 or c: Find functions calling this function
-- "4 or t: Find this text string
-- "6 or e: Find this egrep pattern
-- "7 or f: Find this file
-- "8 or i: Find files #including this file
-- "9 or a: Find places where this symbol is assigned a value

-- " Jump to result
map{'n', '<Leader>cs', ':cs find s <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>cg', ':cs find g <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>cc', ':cs find c <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>ct', ':cs find t <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>ce', ':cs find e <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>cf', ':cs find f <C-R>=expand("<cfile>")<CR><CR>'}
map{'n', '<Leader>ci', ':cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>'}
map{'n', '<Leader>cd', ':cs find d <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>ca', ':cs find a <C-R>=expand("<cword>")<CR><CR>'}

-- " Open the result in a split
map{'n', '<Leader>Cs', ':scs find s <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>Cg', ':scs find g <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>Cc', ':scs find c <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>Ct', ':scs find t <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>Ce', ':scs find e <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>Cf', ':scs find f <C-R>=expand("<cfile>")<CR><CR>'}
map{'n', '<Leader>Ci', ':scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>'}
map{'n', '<Leader>Cd', ':scs find d <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>Ca', ':scs find a <C-R>=expand("<cword>")<CR><CR>'}

-- " Open the result in a vertical split
map{'n', '<Leader>CS', ':vert scs find s <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>CG', ':vert scs find g <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>CC', ':vert scs find c <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>CT', ':vert scs find t <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>CE', ':vert scs find e <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>CF', ':vert scs find f <C-R>=expand("<cfile>")<CR><CR>'}
map{'n', '<Leader>CI', ':vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>'}
map{'n', '<Leader>CD', ':vert scs find d <C-R>=expand("<cword>")<CR><CR>'}
map{'n', '<Leader>CA', ':vert scs find a <C-R>=expand("<cword>")<CR><CR>'}

-- " Quickfix bindings
map{'n', ']q', ':cnext<cr>'}
map{'n', ']Q', ':clast<cr>'}
map{'n', '[q', ':cprevious<cr>'}
map{'n', '[Q', ':cfirst<cr>'}
map{'n', '<Leader>q', ':ccl<cr>'}

-- " }}}

-- " Language Server{{{2
local lspconfig = require('lspconfig')

	-- Mappings.
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
local servers = { "jedi_language_server", "robotframework_ls" }
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach;
		capabilities = capabilities
	}
end

lspconfig.clangd.setup{
	-- cmd = { "clangd", "--background-index", "--cross-file-rename", "--limit-results=0", "-j=$(nproc)" };
	on_attach = on_attach;
	capabilities = capabilities;
	root_dir = function(fname)
		return lspconfig.util.root_pattern("compile_commands.json")(fname) or
		lspconfig.util.root_pattern("compile_flags.txt", ".clangd", ".git")(fname);
	end
}

-- " Quick Ack
map{'n', '/<Leader>', ':Ack!<Space>'}
-- " Notes
map{'n', '<Leader>wn', ':Nack<space>'}
map{'n', '<Leader>ww', ':FZF $NOTES<cr>'}

-- " Insert date/time
map{'i', '<leader>d', '<C-r>=strftime("%a %d.%m.%Y %H:%M")<cr>'}
map{'i', '<leader>D', '<C-r>=strftime("%d.%m.%y")<cr>'}

-- " UltiSnips Bindings
vim.g.UltiSnipsExpandTrigger="<Leader><Leader>"

vim.g.UltiSnipsListSnippets="<Leader>s"
vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"

map{'n', ',', '<Plug>(easymotion-prefix))'}

-- " Turn off search highlight
map{'n', '<Leader>/', ':noh<cr>'}

-- " Fuzzy-find lite
map{'n', '<Leader><space>', ':e ./**/'}
-- "map{'n', '<Leader><cr>', ':buffer'}

-- " FZF bindings
map{'n', '<Leader><cr>', '<CMD>Buffers<CR>'}
map{'n', '<Leader>f', '<CMD>FZF<CR>'}
map{'n', '<Leader>t', '<CMD>Tags<CR>'}
map{'n', '<Leader>T', '<CMD>BTags<CR>'}
map{'n', '<Leader>m', '<CMD>Commits<CR>'}
map{'n', '<Leader>M', '<CMD>BCommits<CR>'}

-- " Start a Git command
map{'n', '<Leader>gg', ':Git<Space>'}
map{'n', '<Leader>gs', ':Git status<CR>'}
map{'n', '<Leader>gv', ':Magit<CR>'}
-- "map{'n', '<Leader>gcm', ':Git commit<CR>'}
map{'n', '<Leader>gd', ':Git diff<CR>'}
map{'n', '<Leader>gc', ':Gdiffsplit<CR>'}
map{'n', '<Leader>gb', ':MerginalToggle<CR>'}

-- " Spellchecking Bindings
map{'i', '<m-f>', '<C-G>u<Esc>[s1z=`]a<C-G>u'}
map{'n', '<m-f>', '[s1z=<c-o>'}

-- " Toggle whitespaces
map{'n', '<F2>', ':set list! <CR>'}
-- " Toggle spell checking
map{'n', '<F3>', ':setlocal spell! spelllang=en<CR>'}
-- " real make
map{'', '<silent> <F5>', ':make<cr><cr><cr>'}
-- " GNUism, for building recursively
map{'', '<silent> <s-F5>', ':make -w<cr><cr><cr>'}
-- " Toggle the tags bar
map{'n', '<F8>', ':Vista<CR>'}

-- " Ctags in previw/split window
map{'n', '<C-w><C-]>', '<C-w>}'}
map{'n', '<C-w>}', '<C-w><C-]>'}

-- " Nuake Bindings
map{'n', '<Leader>`', ':Nuake<CR>'}
map{'i', '<Leader>`', '<C-\\><C-n>:Nuake<CR>'}
map{'t', '<Leader>`', '<C-\\><C-n>:Nuake<CR>'}

-- " Compile file (Markdown, LaTeX, etc)
-- " TODO: Auto-recognize build system
map{'n', '<silent> <F6>', ':!compiler %<cr>'}

--map{'i', '<silent><expr><tab>', 'pumvisible() ? "<c-n>" : "<tab>"'}
--map{'i', '<silent><expr><s-tab>', 'pumvisible() ? "<c-p>" : "<s-tab>"'}
-- " }}}
