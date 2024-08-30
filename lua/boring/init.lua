require('nixCatsUtils').setup({
    non_nix_value = true,
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = nixCats('have_nerd_font')

require('boring.options')
require('boring.keymaps')
