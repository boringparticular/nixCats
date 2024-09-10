return {
    {
        'rcarriga/nvim-notify',
        enabled = require('nixCatsUtils').enableForCategory('extra'),
        opts = {
            max_width = 80,
            render = 'wrapped-compact',
        },
        config = function()
            vim.keymap.set('n', '<leader>sn', 'require("telescope").extensions.notify.notify', { desc = '[S]earch [N]otifications' })
        end,
    },
}
