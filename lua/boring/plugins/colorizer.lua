return {
    {
        'nvchad/nvim-colorizer.lua',
        enabled = require('nixCatsUtils').enableForCategory('extra'),
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
}
