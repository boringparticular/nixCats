return {
    {
        'kotlin_language_server',
        for_cat = 'kotlin',
        enabled = nixCats('lsp'),
        lsp = {},
    },
}
