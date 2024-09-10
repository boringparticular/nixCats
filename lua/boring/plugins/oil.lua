return {
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
}
