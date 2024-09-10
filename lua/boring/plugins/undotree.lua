return {
    {
        'mbbill/undotree',
        enabled = require('nixCatsUtils').enableForCategory('extra'),
        keys = {
            {
                '<leader>tu',
                vim.cmd.UndotreeToggle,
                desc = '[T]oggle [U]ndoTree',
            },
        },
    },
}
