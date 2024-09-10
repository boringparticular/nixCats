return {
    {
        'lukas-reineke/indent-blankline.nvim',
        enabled = require('nixCatsUtils').enableForCategory('extra'),
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
}
