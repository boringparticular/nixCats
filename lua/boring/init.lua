-- NOTE: nixCats: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup({
    non_nix_value = true,
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = nixCats('have_nerd_font')

require('boring.options')
require('boring.keymaps')
