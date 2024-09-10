return {
    {
        'epwalsh/obsidian.nvim',
        enabled = require('nixCatsUtils').enableForCategory('notes'),
        version = '*', -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = 'markdown',
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            'nvim-lua/plenary.nvim',

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = 'personal',
                    path = '~/Nextcloud/obsidian',
                },
            },

            -- see below for full list of options 👇
        },
    },
    {
        'iamcco/markdown-preview.nvim',
        enabled = require('nixCatsUtils').enableForCategory('notes'),
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        enabled = require('nixCatsUtils').enableForCategory('notes'),
        name = 'render-markdown',
        config = function()
            require('render-markdown').setup({})
        end,
        ft = 'markdown',
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    },
    {
        'nvim-neorg/neorg',
        enabled = require('nixCatsUtils').enableForCategory('notes'),
        lazy = true,
        ft = 'neorg',
        version = '*',
        config = true,
        --[[ opts = {
            load = {
                ['core.defaults'] = {},
                ['core.concealer'] = {},
                -- ['core.completion'] = {
                --     engine = 'nvim-cmp',
                --     name = '[Neorg]',
                -- },
                ['core.dirman'] = {
                    config = {
                        workspaces = {
                            notes = '~/Nextcloud/notes',
                        },
                        default_workspace = 'notes',
                    },
                },
            },
        }, ]]
    },
}
