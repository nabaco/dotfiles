-- Automatically bootstrap packer.
-- Define in path, and if not there, download it.
-- Based on the global PACKER_BOOTSTRAP variable, install all the plugins (through "require").
-- The plugins file is included conditionally, since packer compiles all the plugins data into
-- a file that is in the path and is included by default.
-- This done in hope of the most optimal lazy loading.
-- Packer itself is only required when doing plugins management.
-- The autocmd should handle that.

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print "Installing packer close and reopen Neovim..."
  require('plugins')
end

-- Automatically install plugins after updating the plugin file
-- Placing the autocmd here, since the plugins file is not always included

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])


require('impatient')
-- """"""" General Vim Config """""""{{{1

vim.opt.termguicolors = true
-- " Colorscheme wal
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = 'high'
vim.cmd[[colorscheme gruvbox-material]]

-- " Highlight embedded lua code
vim.g.vimsyn_embed = 'l'

-- In case no tags are available from the LSP Server,
-- or I turned of the LSP client, use regular tags (e.g. ctags)
vim.g.lsp_smag_fallback_tags = 1

-- " Set environment variable to be able to start vim in :terminal
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

-- " Sync clipboards with system
--vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'

-- " Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- " Enable mouse, but in normal mode
vim.opt.mouse='n'

-- " Open split the sane way
vim.opt.splitright=true
vim.opt.splitbelow=true

-- " Hide buffer when closed
vim.opt.hidden=true
-- " Close nvim/tab if NvimTree is the last one open
vim.o.confirm = true
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
  end
})

require("nvim-tree").setup { actions = {open_file = {quit_on_open = true}} }

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
vim.opt.cursorline = true
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
vim.opt.inccommand = "split"

-- " Enable per project .vimrc
vim.opt.exrc = true
vim.opt.secure = true

-- " Don't load default filetypes.vim on startup
vim.g.did_load_filetypes = 1

-- " Integrate RipGrep
if vim.fn.executable('rg') then
    vim.opt.grepprg="rg --with-filename --no-heading $* /dev/null"
end

-- " Tags magic {{{2

vim.opt.tags='./tags,**5/tags,tags;~'
-- "                          ^ in working dir, or parents
-- "                   ^ in any subfolder of working dir
-- "           ^ sibling of open file

vim.cmd[[
    augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout='1000'})
    augroup END
]]

vim.cmd[[
    augroup autoreconf
        autocmd!
        autocmd BufWritePost *sxhkdrc !pkill -USR1 -x sxhkd
        autocmd BufWritePost *init.vim source ~/.config/nvim/init.vim
        autocmd BufWritePost *init.lua source <afile>
        autocmd BufWritePost *bspwmrc !bspc wm -r
        autocmd BufWritePost *picom.conf !pkill -x picom && picom -b
        autocmd BufWritePost *mpd.conf !mpd --kill && mpd
        autocmd BufWritePost *termite/config !killall -USR1 termite
        autocmd BufWritePost *qtile/config.py !qtile-cmd -o cmd -f restart > /dev/null 2&>1
    augroup END
]]

vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/bin/python3'

-- " AutoComplete Config {{{2
-- " Don't let autocomplete affect usual typing habits
vim.opt.completeopt='menuone,noinsert,noselect'
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

-- Setup nvim-cmp.

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    window = {
        --[[
        border = opts.border or 'rounded',
        winhighlight = opts.winhighlight or 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
        zindex = opts.zindex or 1001,
        col_offset = opts.col_offset or 0,
        side_padding = opts.side_padding or 1
        --]]
        completion = cmp.config.window.bordered({zindex = 100, max_width = 50}),
        documentation = cmp.config.window.bordered({zindex = 120}),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<S-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            -- c = function(fallback)
            --     if cmp.visible() then
            --         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            --     else
            --         fallback()
            --     end
            -- end
        }),
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
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        --{ name = 'luasnip' }
        { name = 'ultisnips' }
    }, {
        { name = 'buffer' },
    })
})

-- " UltiSnips Bindings
vim.g.UltiSnipsExpandTrigger="<Leader><Leader>"
vim.g.UltiSnipsListSnippets="<Leader>x"
vim.g.UltiSnipsJumpForwardTrigger='<Plug>(ultisnips_jump_forward)'
vim.g.UltiSnipsJumpBackwardTrigger='<Plug>(ultisnips_jump_backward)'
--vim.g.UltiSnipsRemoveSelectModeMappings = 0



-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = {
        { name = 'buffer' }
    }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- "}}}

vim.api.nvim_exec('autocmd VimEnter * call vista#RunForNearestMethodOrFunction()', false)
require'lualine'.setup{
    options = { theme = 'gruvbox-material' },
    sections = { lualine_c = {'filename', 'b:vista_nearest_method_or_function'} }
}

require'lspsaga'.init_lsp_saga()
--require'lspsaga'.setup()
require'nvim-autopairs'.setup{}

-- " HardTime in all buffers
vim.g.hardtime_default_on = 0
vim.g.hardtime_showmsg = 1
vim.g.hardtime_ignore_buffer_patterns = { "NvimTree.*", "help" }
vim.g.hardtime_ignore_quickfix = 1
vim.g.hardtime_allow_different_key = 1

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
vim.g.rooter_patterns = {'compile_commands.json', '.git', 'Cargo.toml'}

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
    { i= '~/.config/nvim/init.lua'  },
    { p= '~/.config/nvim/lua/plugins.lua'  },
    { b= '~/.bashrc'  },
    { u= '~/.bashrc.'..vim.env.USER  },
}

-- Lua is more picky about escaping backslashes
-- Preferable method is to first put the text
-- and after the shape is fine, escape them
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

if not vim.g.mapx then
    mapx = require'mapx'.setup{ global = true, whichkey = true }
    -- When sourcing this file a second time, Neovim throws an error on the line above.
    -- Seems like mapx tries to map again all of its commands and finds a conflict (with itself).
    -- This is a workaround to run above line only once in a running Neovim instance.
    vim.g.mapx = 1
end

require("which-key").setup{}
-- " Make life easier with exiting modes back to normal
inoremap('jk', '<Esc>', "Exit insert mode")
vnoremap('jk', '<Esc>', "Exit visual mode")
-- inoremap('<Esc>', '<Nop>')
-- vnoremap('<Esc>', '<Nop>')

nnoremap('<Leader>n', ':NvimTreeToggle<CR>', "File explorer")
nnoremap('<Leader>v', ':NvimTreeFindFile<CR>', "Current file in file explorer")

nnoremap('<leader>s', '<cmd>Startify<CR>', "Home screen")

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
nnoremap('<Leader>cs', ':cs find s <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>cg', ':cs find g <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>cc', ':cs find c <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>ct', ':cs find t <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>ce', ':cs find e <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>cf', ':cs find f <C-R>=expand("<cfile>")<CR><CR>')
nnoremap('<Leader>ci', ':cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>')
nnoremap('<Leader>cd', ':cs find d <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>ca', ':cs find a <C-R>=expand("<cword>")<CR><CR>')

-- " Open the result in a split
nnoremap('<Leader>Cs', ':scs find s <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>Cg', ':scs find g <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>Cc', ':scs find c <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>Ct', ':scs find t <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>Ce', ':scs find e <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>Cf', ':scs find f <C-R>=expand("<cfile>")<CR><CR>')
nnoremap('<Leader>Ci', ':scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>')
nnoremap('<Leader>Cd', ':scs find d <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>Ca', ':scs find a <C-R>=expand("<cword>")<CR><CR>')

-- " Open the result in a vertical split
nnoremap('<Leader>CS', ':vert scs find s <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>CG', ':vert scs find g <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>CC', ':vert scs find c <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>CT', ':vert scs find t <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>CE', ':vert scs find e <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>CF', ':vert scs find f <C-R>=expand("<cfile>")<CR><CR>')
nnoremap('<Leader>CI', ':vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>')
nnoremap('<Leader>CD', ':vert scs find d <C-R>=expand("<cword>")<CR><CR>')
nnoremap('<Leader>CA', ':vert scs find a <C-R>=expand("<cword>")<CR><CR>')

-- " Quickfix bindings
nnoremap(']q', ':cnext<cr>')
nnoremap(']Q', ':clast<cr>')
nnoremap('[q', ':cprevious<cr>')
nnoremap('[Q', ':cfirst<cr>')
nnoremap('<Leader>q', ':ccl<cr>')

-- " }}}

-- " Language Server{{{2
local luadev = require("neodev").setup({})
--     lsp_config = {
--         on_attach = on_attach; capabilities = capabilities;
--         settings = {
--             Lua = {
--                 workspace = {
--                     library = {
--                         ['/usr/share/awesome/lib'] = true
--                     }
--                 };
--             }
--         }
--     }
-- })

require("nvim-semantic-tokens").setup {
  preset = "default",
  highlighters = { require 'nvim-semantic-tokens.table-highlighter' },
  -- preset = "theHamsta",
  -- highlighters is a list of modules following the interface of nvim-semantic-tokens.table-highlighter or
  -- function with the signature: highlight_token(ctx, token, highlight) where
  --        ctx (as defined in :h lsp-handler)
  --        token  (as defined in :h vim.lsp.semantic_tokens.on_full())
  --        highlight (a helper function that you can call (also multiple times) with the determined highlight group(s) as the only parameter)
  --highlighters = { require 'nvim-semantic-tokens.table-highlighter'}
}

local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
	-- Mappings.
	local opts = { silent=true, buffer=bufnr }
	nnoremap('<leader>lD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	--nnoremap('<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    nnoremap('<c-[>', '<cmd>Lspsaga preview_definition<CR>', opts)
    nnoremap("<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>")
    nnoremap("<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>")
	nnoremap('<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	nnoremap('<leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	nnoremap('<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	nnoremap('<leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
	nnoremap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	nnoremap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	nnoremap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	nnoremap('<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	-- nnoremap('<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	nnoremap('<leader>lR', '<cmd>Lspsaga rename<CR>', opts)
	nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	--nnoremap('<leader>ds', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	nnoremap('<leader>ds', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
	-- nnoremap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	-- nnoremap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	nnoremap('[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
	nnoremap(']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
	nnoremap('<leader>dq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
	nnoremap('<leader>la', '<cmd>Lspsaga code_action<CR>', opts)
	vnoremap('<leader>la', '<cmd>Lspsaga range_code_action<CR>', opts)
	cmdbang("LspDiag", function() vim.diagnostic.setloclist() end, {nargs = 0})

	-- Vista config
	vim.g.vista_default_executive='nvim_lsp'
	nnoremap('<leader>t', '<cmd>Vista finder<CR>', opts)

    local caps = client.server_capabilities
	-- Set some keybinds conditional on server capabilities
	if caps.document_formatting then
		nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	elseif caps.document_range_formatting then
		nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end

	-- Set autocommands conditional on server_capabilities
	if caps.document_highlight then
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

    -- Semantic tokens setup
    if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
        local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
        vim.api.nvim_create_autocmd({"TextChanged", "InsertLeave"}, {
        -- vim.api.nvim_create_autocmd({"InsertLeave","CursorHold","TextChanged"}, {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.semantic_tokens_full()
            end,
        })
        -- fire it first time on load as well
      vim.lsp.buf.semantic_tokens_full()
    end
    require "lsp_signature".on_attach({ hi_parameter = "IncSearch"})
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "jedi_language_server", "robotframework_ls", "bashls"}--, "rust_analyzer" }
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach;
        capabilities = capabilities
    }
end

lspconfig.rust_analyzer.setup{
    on_attach = on_attach;
    capabilities = capabilities;
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = {
                command = "clippy";
            }
        }
    }

}

lspconfig.clangd.setup{
    -- cmd = { "clangd", "--background-index", "--cross-file-rename", "--limit-results=0", "-j=$(nproc)" };
    on_attach = on_attach;
    capabilities = capabilities;
    root_dir = function(fname)
        return lspconfig.util.root_pattern("compile_commands.json")(fname) or
        lspconfig.util.root_pattern("compile_flags.txt", ".clangd", ".git")(fname);
    end
}

lspconfig.sumneko_lua.setup({})

-- " }}}

require'nvim-treesitter.configs'.setup {
  -- One of "all", or a list of languages
  ensure_installed = { "c", "lua", "help", "markdown", "markdown_inline", "python", "nix", "rust", "bash", "yaml" },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    }
}

mapx.nname("<leader>l", "LSP")
nnoremap('<Leader>wn', ':Nack<space>')
nnoremap('<Leader>ww', ':FZF $NOTES<cr>')

-- " Insert date/time
inoremap('<leader>d', '<C-r>=strftime("%a %d.%m.%Y %H:%M")<cr>')
inoremap('<leader>D', '<C-r>=strftime("%d.%m.%y")<cr>')


map(',', '<Plug>(easymotion-prefix)')

-- " Turn off search highlight
nnoremap('<Leader>/', ':noh<cr>')

-- " FZF bindings
nnoremap('<Leader><cr>', '<CMD>Buffers<CR>')
nnoremap('<Leader>f', '<CMD>FZF<CR>')
nnoremap('<Leader>t', '<CMD>Tags<CR>')
nnoremap('<Leader>T', '<CMD>BTags<CR>')
nnoremap('<Leader>m', '<CMD>Commits<CR>')
nnoremap('<Leader>M', '<CMD>BCommits<CR>')

-- " Start a Git command
nnoremap('<Leader>gg', ':Git<Space>')
nnoremap('<Leader>gs', ':Git status<CR>')
nnoremap('<Leader>gv', ':Magit<CR>')
-- "nnoremap('<Leader>gcm', ':Git commit<CR>')
nnoremap('<Leader>gd', ':Git diff<CR>')
nnoremap('<Leader>gc', ':Gdiffsplit<CR>')
nnoremap('<Leader>gb', ':MerginalToggle<CR>')

-- " Spellchecking Bindings
inoremap('<m-f>', '<C-G>u<Esc>[s1z=`]a<C-G>u')
nnoremap('<m-f>', '[s1z=<c-o>')

-- " Toggle whitespaces
nnoremap('<F2>', ':set list! <CR>')
-- " Toggle spell checking
nnoremap('<F3>', ':setlocal spell! spelllang=en<CR>')
-- " real make
nnoremap('<silent> <F5>', ':make<cr><cr><cr>')
-- " GNUism, for building recursively
nnoremap('<silent> <s-F5>', ':make -w<cr><cr><cr>')
-- " Toggle the tags bar
nnoremap('<F8>', ':Vista<CR>')

-- " Ctags in previw/split window
nnoremap('<C-w><C-]>', '<C-w>}')
nnoremap('<C-w>}', '<C-w><C-]>')

-- " Nuake Bindings
nnoremap('<Leader>`', ':Nuake<CR>')
inoremap('<Leader>`', '<C-\\><C-n>:Nuake<CR>')
tnoremap('<Leader>`', '<C-\\><C-n>:Nuake<CR>')

-- " Compile file (Markdown, LaTeX, etc)
-- " TODO: Auto-recognize build system
nnoremap('<silent> <F6>', ':!compiler %<cr>')

--inoremap('<silent><expr><tab>', 'pumvisible() ? "<c-n>" : "<tab>"')
--inoremap('<silent><expr><s-tab>', 'pumvisible() ? "<c-p>" : "<s-tab>"')
-- " }}}
