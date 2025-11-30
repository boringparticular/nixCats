return {
    {
        'nvim-dap',
        for_cat = 'debug',
        -- stylua: ignore
        keys = {
            {'<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = '[D]ebug: Set [B]reakpoint Condition',},
            {'<leader>db', function() require('dap').toggle_breakpoint() end, desc = '[D]ebug: Toggle [B]reakpoint',},
            {'<leader>dc', function() require('dap').continue() end, desc = '[D]ebug: Run/[C]ontinue',},
            {'<leader>da', function() require('dap').continue({ before = get_args }) end, desc = '[D]ebug: Run with [A]rgs',},
            {'<leader>dC', function() require('dap').run_to_cursor() end, desc = '[D]ebug: Run to [C]ursor',},
            {'<leader>dg', function() require('dap').goto_() end, desc = '[D]ebug: [G]o to Line (No Execute)',},
            {'<leader>di', function() require('dap').step_into() end, desc = '[D]ebug: Step [I]nto',},
            {'<leader>dj', function() require('dap').down() end, desc = '[D]ebug: Down',},
            {'<leader>dk', function() require('dap').up() end, desc = '[D]ebug: Up',},
            {'<leader>dl', function() require('dap').run_last() end, desc = '[D]ebug: Run [L]ast',},
            {'<leader>do', function() require('dap').step_out() end, desc = '[D]ebug: Step [O]ut',},
            {'<leader>dO', function() require('dap').step_over() end, desc = '[D]ebug: Step [O]ver',},
            {'<leader>dP', function() require('dap').pause() end, desc = '[D]ebug: [P]ause',},
            {'<leader>dr', function() require('dap').repl.toggle() end, desc = '[D]ebug: Toggle [R]EPL',},
            {'<leader>ds', function() require('dap').session() end, desc = '[D]ebug: [S]ession',},
            {'<leader>dt', function() require('dap').terminate() end, desc = '[D]ebug [T]erminate',},
            {'<leader>dw', function() require('dap.ui.widgets').hover() end, desc = '[D]ebug: [W]idgets',},
            {'<leader>du', function() require('dapui').toggle({}) end, desc = '[D]ebug: Toggle [U]I',},
            {'<leader>de', function() require('dapui').eval() end, desc = '[D]ebug: [E]val', mode = { 'n', 'v' },},
        },
        -- stylua: ignore end
        load = (require('nixCatsUtils').isNixCats and function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd('nvim-dap-ui')
            vim.cmd.packadd('nvim-dap-virtual-text')
        end) or function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd('nvim-dap-ui')
            vim.cmd.packadd('nvim-dap-virtual-text')
            vim.cmd.packadd('mason-nvim-dap.nvim')
        end,
        after = function(_)
            local dap = require('dap')

            dap.adapters.gdb = {
                type = 'executable',
                command = 'gdb',
                args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
            }

            dap.adapters.codelldb = {
                type = 'server',
                port = '${port}',
                executable = {
                    command = vim.env.CODELLDB_PATH,
                    args = { '--port', '${port}' },
                },
            }

            dap.configurations.zig = {
                {
                    name = 'Launch',
                    type = 'codelldb',
                    request = 'launch',
                    program = '${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}',
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                },
            }

            local icons = require('boring.icons')

            vim.fn.sign_define('DapBreakpoint', { text = icons.dap.breakpoint, texthl = 'DapBreakpoint', linehl = '', numhl = '' })
            vim.fn.sign_define('DapBreakpointCondition', { text = icons.dap.breakpoint_condition, texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
            vim.fn.sign_define('DapLogPoint', { text = icons.dap.log_point, texthl = 'DapLogPoint', linehl = '', numhl = '' })
            vim.fn.sign_define('DapStopped', { text = icons.dap.stopped, texthl = 'DapStopped', linehl = '', numhl = '' })
            vim.fn.sign_define('DapBreakpointRejected', { text = icons.dap.breakpoint_rejected, texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })

            local dapui = require('dapui')

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup({
                icons = {
                    expanded = icons.dap.expanded,
                    collapsed = icons.dap.collapsed,
                    current_frame = icons.dap.current_frame,
                },
                controls = {
                    icons = {
                        pause = icons.dap.pause,
                        play = icons.dap.play,
                        step_into = icons.dap.step_into,
                        step_over = icons.dap.step_over,
                        step_out = icons.dap.step_out,
                        step_back = icons.dap.step_back,
                        run_last = icons.dap.run_last,
                        terminate = icons.dap.terminate,
                        disconnect = icons.dap.disconnect,
                    },
                },
            })

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close

            require('nvim-dap-virtual-text').setup({
                enabled = true, -- enable this plugin (the default)
                enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true, -- show stop reason when stopped for exceptions
                commented = false, -- prefix virtual text with comment string
                only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
                --- A callback that determines how a variable is displayed or whether it should be omitted
                --- variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
                --- buf number
                --- stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
                --- node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
                --- options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
                --- string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
                display_callback = function(variable, buf, stackframe, node, options)
                    if options.virt_text_pos == 'inline' then
                        return ' = ' .. variable.value
                    else
                        return variable.name .. ' = ' .. variable.value
                    end
                end,
                -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
                virt_text_pos = vim.fn.has('nvim-0.10') == 1 and 'inline' or 'eol',

                -- experimental features:
                all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
                -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
            })

            require('overseer').enable_dap()
        end,
    },
    {
        'nvim-dap-go',
        for_cat = 'debug',
        on_plugin = { 'nvim-dap' },
        after = function(_)
            require('dap-go').setup({
                delve = {
                    -- On Windows delve must be run attached or it crashes.
                    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
                    detached = vim.fn.has('win32') == 0,
                },
            })
        end,
    },
}
