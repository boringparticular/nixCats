return {
    { 'neotest-elixir', for_cat = 'elixir', dep_of = 'neotest' },
    { 'neotest-golang', for_cat = 'go', dep_of = 'neotest' },
    {
        'neotest',
        for_cat = 'testing',
        -- stylua: ignore
        keys = {
            {'<leader>Tt', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Neo[t]est: Run File',},
            {'<leader>TT', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Neo[t]est: Run All [T]est Files',},
            {'<leader>Tr', function() require('neotest').run.run() end, desc = 'Neo[t]est: [R]un Nearest',},
            {'<leader>Tl', function() require('neotest').run.run_last() end, desc = 'Neo[t]est: Run [L]ast',},
            {'<leader>Ts', function() require('neotest').summary.toggle() end, desc = 'Neo[t]est: Toggle Summary',},
            {'<leader>To', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Neo[t]est: Show [O]utput',},
            {'<leader>TO', function() require('neotest').output_panel.toggle() end, desc = 'Neo[t]est: Toggle [O]utput Panel',},
            {'<leader>TS', function() require('neotest').run.stop() end, desc = 'Neo[t]est: [S]top',},
            {'<leader>Tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Neo[t]est: Toggle [W]atch',},
        },
        -- stylua: ignore end
        after = function(_)
            require('neotest').setup({
                status = { virtual_text = true },
                output = { open_on_run = true },
                quickfix = {
                    open = function()
                        require('trouble').open({ mode = 'quickfix', focus = false })
                    end,
                },
                adapters = {
                    -- TODO: only if the language is enabled
                    require('neotest-elixir'),
                    require('neotest-golang'),
                },
            })
        end,
    },
}
