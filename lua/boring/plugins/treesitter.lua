return {
    {
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
        },
        config = function(_, opts)
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true

            if require('nixCatsUtils').enableForCategory('treesitter-optional') then
                opts = vim.tbl_deep_extend('force', opts, {
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
                    textobjects = {
                        setlect = {
                            enable = true,
                            lookahead = true,

                            keymaps = {
                                -- You can use the capture groups defined in textobjects.scm
                                ['af'] = '@function.outer',
                                ['if'] = '@function.inner',
                                ['ac'] = '@class.outer',
                                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                                -- nvim_buf_set_keymap) which plugins like which-key display
                                ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
                                -- You can also use captures from other query groups like `locals.scm`
                                ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
                            },
                            -- You can choose the select mode (default is charwise 'v')
                            --
                            -- Can also be a function which gets passed a table with the keys
                            -- * query_string: eg '@function.inner'
                            -- * method: eg 'v' or 'o'
                            -- and should return the mode ('v', 'V', or '<c-v>') or a table
                            -- mapping query_strings to modes.
                            selection_modes = {
                                ['@parameter.outer'] = 'v', -- charwise
                                ['@function.outer'] = 'V', -- linewise
                                ['@class.outer'] = '<c-v>', -- blockwise
                            },
                            -- If you set this to `true` (default is `false`) then any textobject is
                            -- extended to include preceding or succeeding whitespace. Succeeding
                            -- whitespace has priority in order to act similarly to eg the built-in
                            -- `ap`.
                            --
                            -- Can also be a function which gets passed a table with the keys
                            -- * query_string: eg '@function.inner'
                            -- * selection_mode: eg 'v'
                            -- and should return true or false
                            include_surrounding_whitespace = true,
                        },
                        move = {
                            enable = true,
                            set_jumps = true, -- whether to set jumps in the jumplist
                            goto_next_start = {
                                [']m'] = '@function.outer',
                                [']]'] = { query = '@class.outer', desc = 'Next class start' },
                                --
                                -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
                                [']o'] = '@loop.*',
                                -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                                --
                                -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                                -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                                [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
                                [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
                            },
                            goto_next_end = {
                                [']M'] = '@function.outer',
                                [']['] = '@class.outer',
                            },
                            goto_previous_start = {
                                ['[m'] = '@function.outer',
                                ['[['] = '@class.outer',
                            },
                            goto_previous_end = {
                                ['[M'] = '@function.outer',
                                ['[]'] = '@class.outer',
                            },
                            -- Below will go to either the start or the end, whichever is closer.
                            -- Use if you want more granular movements
                            -- Make it even more gradual by adding multiple queries and regex.
                            goto_next = {
                                [']d'] = '@conditional.outer',
                            },
                            goto_previous = {
                                ['[d'] = '@conditional.outer',
                            },
                        },
                        lsp_interop = {
                            enable = true,
                            border = 'none',
                            floating_preview_opts = {},
                            peek_definition_code = {
                                ['<leader>df'] = '@function.outer',
                                ['<leader>dF'] = '@class.outer',
                            },
                        },
                    },
                })
            end
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup(opts)
        end,
        dependencies = {
            { 'JoosepAlviste/nvim-ts-context-commentstring', enabled = require('nixCatsUtils').enableForCategory('treesitter-optional') },
            { 'nvim-treesitter/nvim-treesitter-textobjects', enabled = require('nixCatsUtils').enableForCategory('treesitter-optional') },
            { 'nvim-treesitter/nvim-treesitter-refactor', enabled = require('nixCatsUtils').enableForCategory('treesitter-optional') },
            {
                'nvim-treesitter/nvim-treesitter-context',
                enabled = require('nixCatsUtils').enableForCategory('treesitter-optional'),
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
}
