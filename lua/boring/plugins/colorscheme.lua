return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        init = function()
            vim.cmd.colorscheme('catppuccin')
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
}
