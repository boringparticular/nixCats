return {
    {
        'supermaven-inc/supermaven-nvim',
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        event = 'InsertEnter',
        opts = {
            disable_keymaps = true,
            disable_inline_completion = true,
        },
    },
    {
        'sourcegraph/sg.nvim',
        enabled = require('nixCatsUtils').enableForCategory('ai'),
        event = 'InsertEnter',
        keys = {
            { 'n', '<leader>cc', '<cmd>CodyToggle<CR>', desc = '[C]ody [C]hat' },
        },
        opts = {
            accept_tos = true,
            enable_cody = true,
            download_binaries = false,
            chat = {
                default_model = 'anthropic/claude-3-5-sonnet-20240620',
            },
        },
        config = function(_, opts)
            require('sg').setup(opts)
            vim.keymap.set('n', '<leader>cc', '<cmd>CodyToggle<CR>', { desc = '[C]ody [C]hat' })
        end,
    },
}
