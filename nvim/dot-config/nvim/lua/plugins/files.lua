-----------------------------------
--       File Types Support      --
-----------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- Autocommands for specific files
local autoreconf = augroup('autoreconf', { clear = true })
autocmd('BufWritePost', {group=autoreconf, pattern='*sxhkdrc', command='!pkill -USR1 -x sxhkd'})
autocmd('BufWritePost', {group=autoreconf, pattern='*init.vim', command='source ~/.config/nvim/init.vim'})
-- Not required with Lazy.nvim
-- autocmd('BufWritePost', {group=autoreconf, pattern='*init.lua', command=function(args) vim.cmd.source(args.file) end})
autocmd('BufWritePost', {group=autoreconf, pattern='*bspwmrc', command='!bspc wm -r'})
autocmd('BufWritePost', {group=autoreconf, pattern='*picom.conf', command='!pkill -x picom && picom -b'})
autocmd('BufWritePost', {group=autoreconf, pattern='*mpd.conf', command='!mpd'})--kill && mpd
autocmd('BufWritePost', {group=autoreconf, pattern='*termite/config', command='!killall -USR1 termite'})
autocmd('BufWritePost', {group=autoreconf, pattern='*qtile/config.py', command='!qtile-cmd -o cmd -f restart > /dev/null 2&>1'})

-- Help Neovim recognize Yocto files with different extensions
vim.filetype.add({
    extension = {
        bbappend = "bitbake",
        bbclass = "bitbake",
        bb = "bitbake",
    }
})

return {
    -- Language specific plugins
    { 'kovetskiy/sxhkd-vim',                            ft = 'sxhkd' },
    { 'chrisbra/csv.vim',                               ft = 'csv' },
    { 'vhdirk/vim-cmake',                               ft = 'cmake' },
    { 'kergoth/vim-bitbake',                            ft = 'bitbake' },
    { 'https://codeberg.org/Dokana/vim-systemd-syntax', branch = 'trunk', ft = 'systemd' },
    { 'cespare/vim-toml',                               ft = 'toml' },
    { 'tmux-plugins/vim-tmux',                          ft = 'tmux' },
    { 'mfukar/robotframework-vim',                      ft = 'robot' },
    { 'aklt/plantuml-syntax',                           ft = 'plantuml' },
    {
        'scrooloose/vim-slumlord',
        ft = 'plantuml',
        config = function()
            --  PlantUML path
            vim.g.plantuml_executable_script = 'java -jar $NFS/plantuml.jar'
        end
    }, -- Preview
    { 'vim-pandoc/vim-pandoc-syntax',                   ft = 'pandoc' },
    {
        'vim-pandoc/vim-pandoc',
        ft = 'pandoc',
        config = function()
            --  Pandoc configuration
            vim.g['pandoc#command#custom_open'] = 'zathura'
            vim.g['pandoc#command#prefer_pdf'] = 1
            vim.g['pandoc#command#autoexec_command'] = "Pandoc! pdf"
            vim.g['pandoc#completion#bib#mode'] = 'citeproc'
        end
    }, -- Utilities, not syntax

    -- When reading logfiles with Ansi Escape codes dumped in them,
    -- conceal the escape code and show the text with the proper color
    { 'powerman/vim-plugin-AnsiEsc', ft = 'log' },
    { 'MTDL9/vim-log-highlighting',  ft = 'log' },

}
