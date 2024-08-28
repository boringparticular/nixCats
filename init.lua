-- NOTE: NIXCATS USERS:
-- NOTE: there are also notes added as a tutorial of how to use the nixCats lazy wrapper.
-- you can search for the following string in order to find them:
-- NOTE: nixCats:

-- like this one:
-- NOTE: nixCats: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup({
    non_nix_value = true,
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = nixCats('have_nerd_font')

vim.opt.fileformat = 'unix'

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cmdheight = 2

vim.opt.mouse = 'a'

vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.history = 1000
vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = {
    trail = '·',
    nbsp = '␣',
    space = '⋅',
    tab = '•••',
    eol = '↴',
}

vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5

vim.opt.foldenable = true
vim.opt.foldcolumn = 'auto'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldlevel = 3
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.fillchars = {
    eob = ' ',
    fold = ' ',
    foldopen = '',
    foldsep = ' ',
    foldclose = '',
}
vim.opt.statuscolumn = '%=%{v:relnum?v:relnum:v:lnum} %s%C '
vim.opt.conceallevel = 2

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Move to next search result and center line' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Move to previous search result and center line' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll half page down and center line' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll half page up and center line' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- NOTE: nixCats: this is where we define some arguments for the lazy wrapper.
local pluginList = nil
local nixLazyPath = nil
if require('nixCatsUtils').isNixCats then
    local allPlugins = require('nixCats').pawsible.allPlugins
    -- it is called pluginList because we only need to pass in the names
    -- this list literally just tells lazy.nvim not to download the plugins in the list.
    pluginList = require('nixCatsUtils.lazyCat').mergePluginTables(allPlugins.start, allPlugins.opt)

    -- it wasnt detecting that these were already added
    -- because the names are slightly different from the url.
    -- when that happens, add them to the list, then also specify the new name in the lazySpec
    pluginList[ [[Comment.nvim]] ] = ''
    pluginList[ [[LuaSnip]] ] = ''
    -- alternatively you can do it all in the plugins spec instead of modifying this list.
    -- just set the name and then add `dev = require('nixCatsUtils').lazyAdd(false, true)` to the spec

    -- HINT: to view the names of all plugins downloaded via nix, use the `:NixCats pawsible` command.

    -- we also want to pass in lazy.nvim's path
    -- so that the wrapper can add it to the runtime path
    -- as the normal lazy installation instructions dictate
    nixLazyPath = allPlugins.start[ [[lazy.nvim]] ]
end
-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
    if require('nixCatsUtils').isNixCats and type(require('nixCats').settings.unwrappedCfgPath) == 'string' then
        return require('nixCats').settings.unwrappedCfgPath .. '/lazy-lock.json'
    else
        return vim.fn.stdpath('config') .. '/lazy-lock.json'
    end
end
local lazyOptions = {
    lockfile = getlockfilepath(),
    ui = {
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
}

-- NOTE: Here is where you install your plugins.
-- NOTE: nixCats: this the lazy wrapper.
require('nixCatsUtils.lazyCat').setup(pluginList, nixLazyPath, {
    'mattn/emmet-vim',
    'tpope/vim-sleuth',
    'direnv/direnv.vim',
    'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
    -- NOTE: nixCats: nix downloads it with a different file name.
    -- tell lazy about that.
    { 'numToStr/Comment.nvim', name = 'comment.nvim', opts = {} },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    {
        'stevearc/oil.nvim',
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            use_default_keymaps = true,
            lsp_file_method = {
                autosave_changes = true,
            },
            buf_options = {
                buflisted = false,
                bufhidden = 'hide',
            },
            view_options = {
                show_hidden = true,
            },
        },
        keys = { { '-', '<cmd>Oil<CR>', desc = 'Open parent directory' } },
        cmd = 'Oil',
        -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup()

            -- Document existing key chains
            require('which-key').add({
                { '<leader>c', group = '[C]ode' },
                { '<leader>c_', hidden = true },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>d_', hidden = true },
                { '<leader>r', group = '[R]ename' },
                { '<leader>r_', hidden = true },
                { '<leader>s', group = '[S]earch' },
                { '<leader>s_', hidden = true },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>t_', hidden = true },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>w_', hidden = true },
                {
                    mode = { 'v' },
                    { '<leader>h', group = 'Git [H]unk' },
                    { '<leader>h_', hidden = true },
                },
            })
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            indent = {
                char = { '|', '¦', '┆', '┊' },
                tab_char = { '|', '¦', '┆', '┊' },
                highlight = {
                    'RainbowRed',
                    'RainbowYellow',
                    'RainbowBlue',
                    'RainbowOrange',
                    'RainbowGreen',
                    'RainbowViolet',
                    'RainbowCyan',
                },
            },
            scope = {
                enabled = true,
                char = '▎',
                show_start = true,
                show_end = true,
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                -- NOTE: nixCats: use lazyAdd to only run build steps if nix wasnt involved.
                -- because nix already did this.
                build = require('nixCatsUtils').lazyAdd('make'),

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                -- NOTE: nixCats: use lazyAdd to only add this if nix wasnt involved.
                -- because nix built it already, so who cares if we have make in the path.
                cond = require('nixCatsUtils').lazyAdd(function()
                    return vim.fn.executable('make') == 1
                end),
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = {
                        '^.git/',
                        '^.venv/',
                        '^.node_modules/',
                    },
                    mappings = {
                        i = { ['<c-enter>'] = 'to_fuzzy_refine' },
                    },
                },
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            })

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                })
            end, { desc = '[S]earch [/] in Open Files' })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                builtin.find_files({ cwd = vim.fn.stdpath('config') })
            end, { desc = '[S]earch [N]eovim files' })
        end,
    },

    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            {
                'williamboman/mason.nvim',
                -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
                -- because we will be using nix to download things instead.
                enabled = require('nixCatsUtils').lazyAdd(true, false),
                config = true,
            }, -- NOTE: Must be loaded before dependants
            {
                'williamboman/mason-lspconfig.nvim',
                -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
                -- because we will be using nix to download things instead.
                enabled = require('nixCatsUtils').lazyAdd(true, false),
            },
            {
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
                -- because we will be using nix to download things instead.
                enabled = require('nixCatsUtils').lazyAdd(true, false),
            },

            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            {
                'folke/lazydev.nvim',
                ft = 'lua',
                opts = {
                    library = {
                        -- adds type hints for nixCats global
                        { path = require('nixCats').nixCatsPath .. '/lua', words = { 'nixCats' } },
                    },
                },
            },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    map('<leader>cs', vim.lsp.buf.signature_help, '[C]ode [S]ignature Help')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
                            end,
                        })
                    end

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            -- NOTE: nixCats: there is help in nixCats for lsps at `:h nixCats.LSPs` and also `:h nixCats.luaUtils`
            local servers = {}
            servers.clangd = {}
            servers.gopls = {}
            servers.pyright = {}
            servers.html = {}
            servers.htmx = {}
            servers.templ = {}
            servers.svelte = {}
            servers.tailwindcss = {}
            -- servers.rust_analyzer = {},
            -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
            --
            -- Some languages (like typescript) have entire language plugins that can be useful:
            --    https://github.com/pmizio/typescript-tools.nvim
            --
            -- But for many setups, the LSP (`tsserver`) will work just fine
            servers.tsserver = {}
            --

            -- NOTE: nixCats: nixd is not available on mason.
            if require('nixCatsUtils').isNixCats then
                servers.nixd = {}
            else
                servers.rnix = {}
                servers.nil_ls = {}
            end
            servers.lua_ls = {
                -- cmd = {...},
                -- filetypes = { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        diagnostics = {
                            globals = { 'nixCats' },
                            disable = { 'missing-fields' },
                        },
                    },
                },
            }

            -- NOTE: nixCats: if nix, use lspconfig instead of mason
            -- You could MAKE it work, using lspsAndRuntimeDeps and sharedLibraries in nixCats
            -- but don't... its not worth it. Just add the lsp to lspsAndRuntimeDeps.
            if require('nixCatsUtils').isNixCats then
                for server_name, _ in pairs(servers) do
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                        cmd = (servers[server_name] or {}).cmd,
                        root_pattern = (servers[server_name] or {}).root_pattern,
                    })
                end
            else
                -- NOTE: nixCats: and if no nix, do it the normal way

                -- Ensure the servers and tools above are installed
                --  To check the current status of installed tools and/or manually install
                --  other tools, you can run
                --    :Mason
                --
                --  You can press `g?` for help in this menu.
                require('mason').setup()

                -- You can add other tools here that you want Mason to install
                -- for you, so that they are available from within Neovim.
                local ensure_installed = vim.tbl_keys(servers or {})
                vim.list_extend(ensure_installed, {
                    'stylua', -- Used to format Lua code
                })
                require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

                require('mason-lspconfig').setup({
                    handlers = {
                        function(server_name)
                            local server = servers[server_name] or {}
                            -- This handles overriding only values explicitly passed
                            -- by the server configuration above. Useful when disabling
                            -- certain features of an LSP (for example, turning off formatting for tsserver)
                            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                            require('lspconfig')[server_name].setup(server)
                        end,
                    },
                })
            end
        end,
    },
    {
        'rcarriga/nvim-notify',
        opts = {
            max_width = 80,
            render = 'wrapped-compact',
        },
        config = function()
            vim.keymap.set('n', '<leader>sn', 'require("telescope").extensions.notify.notify', { desc = '[S]earch [N]otifications' })
        end,
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        -- -@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
          { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
          { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
          { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
          { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
          { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
        },
    },
    {
        'nvchad/nvim-colorizer.lua',
        event = 'VimEnter',
        opts = {
            user_default_options = {
                AARRGGBB = true,
                RGB = true,
                RRGGBB = true,
                RRGGBBAA = true,
                css = true,
                css_fn = true,
                hsl_fn = true,
                mode = 'virtualtext',
                names = false,
                rgb_fn = true,
                tailwind = true,
                virtualtext = '■',
            },
        },
    },
    { -- Autoformat
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format({ async = true, lsp_fallback = true })
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                nix = { 'alejandra' },
                python = function(bufnr)
                    if require('conform').get_formatter_info('ruff_format', bufnr).available then
                        return { 'ruff_format' }
                    else
                        return { 'isort', 'black' }
                    end
                end,
                html = { 'prettierd', 'prettier', stop_after_first = true },
                css = { 'prettierd', 'prettier', 'stylelint', stop_after_first = true },
                javascript = { 'prettierd', 'prettier', stop_after_first = true },
                typescript = { 'prettierd', 'prettier', stop_after_first = true },
                svelte = { 'prettierd', 'prettier', stop_after_first = true },
                json = { 'prettierd', 'prettier', stop_after_first = true },
                markdown = { 'prettierd', 'prettier', stop_after_first = true },
                gohtmltmpl = { 'prettierd', 'prettier', stop_after_first = true },
                go = { 'gofumpt', 'gofmt', stop_after_first = true },
                templ = { 'templ' },
                rust = { 'rustfmt', lsp_format = 'fallback' },
                just = { 'just' },
                ['*'] = { 'injected' },
                ['_'] = { 'trim_whitespace' },
            },
        },
    },

    {
        'sourcegraph/sg.nvim',
        opts = {
            accept_tos = true,
            enable_cody = true,
            download_binaries = false,
            chat = {
                default_model = 'anthropic/claude-3-5-sonnet-20240620',
            },
        },
    },
    {
        'supermaven-inc/supermaven-nvim',
        opts = {
            disable_keymaps = true,
            disable_inline_completion = true,
        },
    },
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                -- NOTE: nixCats: nix downloads it with a different file name.
                -- tell lazy about that.
                name = 'luasnip',
                build = require('nixCatsUtils').lazyAdd((function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)()),
                dependencies = {
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
            },
            'onsails/lspkind.nvim',
            'saadparwaiz1/cmp_luasnip',

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp-document-symbol',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-nvim-lua',
            'ray-x/cmp-treesitter',
        },
        config = function()
            -- See `:help cmp`
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')
            luasnip.config.setup({})

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        menu = {
                            buffer = '[Buffer]',
                            cody = '[cody]',
                            luasnip = '[LuaSnip]',
                            nvim_lsp = '[LSP]',
                            nvim_lua = '[Lua]',
                            supermaven = '[Supermaven]',
                        },
                        mode = 'symbol_text',
                        preset = 'default',
                        symbol_map = { Copilot = '', Supermaven = '' },
                    }),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                experimental = { ghost_text = true },
                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ['<C-Space>'] = cmp.mapping.complete({}),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'cody' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { max_item_count = 5, name = 'luasnip' },
                    { name = 'nvim_lua' },
                    { max_item_count = 5, name = 'buffer' },
                    { name = 'treesitter' },
                    { max_item_count = 5, name = 'path' },
                    { name = 'supermaven' },
                },
                view = {
                    entries = {
                        follow_cursor = true,
                        name = 'custom',
                        selection_order = 'near_cursor',
                    },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
            -- Set configuration for specific filetype.
            --[[ cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'git' },
                }, {
                    { name = 'buffer' },
                }),
            })
            require('cmp_git').setup() ]]

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                }, {
                    { name = 'cmdline' },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
    },

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        init = function()
            vim.cmd.colorscheme('catppuccin')

            -- You can configure highlights by doing something like:
            vim.cmd.hi('Comment gui=none')
        end,
        opts = {
            flavour = 'mocha',
            term_colors = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                rainbow_delimiters = true,
                treesitter_context = true,
                indent_blankline = {
                    enabled = true,
                    scope_color = 'lavender',
                    colored_indent_levels = true,
                },
                flash = true,
                mini = {
                    enabled = true,
                    indentscope_color = 'lavender',
                },
                telescope = { enabled = true },
                treesitter = true,
                which_key = true,
            },
        },
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = true } },

    {
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            require('mini.cursorword').setup()
            require('mini.files').setup()
            require('mini.sessions').setup()
            require('mini.visits').setup()

            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin
            local statusline = require('mini.statusline')
            -- set use_icons to true if you have a Nerd Font
            statusline.setup({ use_icons = vim.g.have_nerd_font })

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = require('nixCatsUtils').lazyAdd(':TSUpdate'),
        opts = {
            -- NOTE: nixCats: use lazyAdd to only set these 2 options if nix wasnt involved.
            -- because nix already ensured they were installed.
            ensure_installed = require('nixCatsUtils').lazyAdd({ 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' }),
            auto_install = require('nixCatsUtils').lazyAdd(true, false),

            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
            refactor = {
                highlight_current_scope = { enable = true },
                highlight_definitions = { clear_on_cursor_move = true, enable = true },
                navigation = {
                    enable = false,
                    keymaps = {
                        goto_definition = 'gnd',
                        goto_next_usage = '<a-*>',
                        goto_previous_usage = '<a-#>',
                        list_definitions = 'gnD',
                        list_definitions_toc = 'gO',
                    },
                },
                smart_rename = { enable = false, keymaps = { smart_rename = 'grr' } },
            },
        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup(opts)

            -- There are additional nvim-treesitter modules that you can use to interact
            -- with nvim-treesitter. You should go explore a few and see what interests you:
            --
            --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
            --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
            --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-refactor',
            {
                'nvim-treesitter/nvim-treesitter-context',
                event = 'VeryLazy',
                config = function()
                    require('treesitter-context').setup({
                        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                        line_numbers = true,
                        multiline_threshold = 20, -- Maximum number of lines to show for a single context
                        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
                        -- Separator between context and content. Should be a single character string, like '-'.
                        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                        separator = nil,
                        zindex = 20, -- The Z-index of the context window
                        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
                    })
                end,
            },
        },
    },
    {
        'mbbill/undotree',
        keys = {
            {
                '<leader>tu',
                vim.cmd.UndotreeToggle,
                desc = '[T]oggle [U]ndoTree',
            },
        },
    },
    {
        'nvim-neorg/neorg',
        lazy = false,
        version = '*',
        config = true,
    },
    {
        'ray-x/go.nvim',
        dependencies = { -- optional packages
            'ray-x/guihua.lua',
            'neovim/nvim-lspconfig',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('go').setup()
        end,
        event = { 'CmdlineEnter' },
        ft = { 'go', 'gomod' },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local harpoon = require('harpoon')

            harpoon:setup()

            -- basic telescope configuration
            local conf = require('telescope.config').values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require('telescope.pickers')
                    .new({}, {
                        prompt_title = 'Harpoon',
                        finder = require('telescope.finders').new_table({
                            results = file_paths,
                        }),
                        previewer = conf.file_previewer({}),
                        sorter = conf.generic_sorter({}),
                    })
                    :find()
            end

            -- stylua: ignore
            vim.keymap.set('n', '<C-e>', function() toggle_telescope(harpoon:list()) end, { desc = 'Open harpoon window' })
            -- stylua: ignore
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = 'Harpoon [A]dd' })
        end,
    },

    -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- place them in the correct locations.

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
    --
    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    -- NOTE: nixCats: instead of uncommenting them, you can enable them
    -- from the categories set in your packageDefinitions in your flake or other template!
    -- This is because within them, we used nixCats to check if it should be loaded!
    require('kickstart.plugins.debug'),
    require('kickstart.plugins.indent_line'),
    require('kickstart.plugins.lint'),
    require('kickstart.plugins.autopairs'),
    require('kickstart.plugins.neo-tree'),
    require('kickstart.plugins.gitsigns'), -- adds gitsigns recommend keymaps

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
    { import = 'custom.plugins' },
}, lazyOptions)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
