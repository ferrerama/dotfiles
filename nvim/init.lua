vim.opt.termguicolors = true
local set = vim.opt

return require('packer').startup(function(use)
-- PLUGINS
use 'wbthomason/packer.nvim'
use 'nvim-tree/nvim-tree.lua'
use 'nvim-lualine/lualine.nvim'
use 'kyazdani42/nvim-web-devicons'
use 'ryanoasis/vim-devicons'
use 'airblade/vim-gitgutter'
use 'antoinemadec/FixCursorHold.nvim'
use 'lukas-reineke/indent-blankline.nvim'
use 'nvim-lua/plenary.nvim'
use 'jiangmiao/auto-pairs'
use 'neovim/nvim-lspconfig'
use({"glepnir/lspsaga.nvim", branch = "main", config = function() require('lspsaga').setup({}) end,})
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
use 'hrsh7th/nvim-cmp'
use 'L3MON4D3/LuaSnip'
use 'saadparwaiz1/cmp_luasnip'
use 'p00f/clangd_extensions.nvim'  
use 'williamboman/mason.nvim'
use 'nvim-treesitter/nvim-treesitter'
use 'numToStr/Comment.nvim'
use {'nvim-telescope/telescope.nvim', tag = '0.1.4', -- or, branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} } }
use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
use 'debugloop/telescope-undo.nvim'
use 'norcalli/nvim-colorizer.lua'
use 'windwp/nvim-ts-autotag'
use 'rafamadriz/friendly-snippets'
use 'voldikss/vim-floaterm'
use 'shaunsingh/nord.nvim'
use 'xiyaowong/transparent.nvim'
use 'cdelledonne/vim-cmake'
use ({ "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, })
use 'mfussenegger/nvim-dap'
use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
use {"jay-babu/mason-nvim-dap.nvim", requires = {"williamboman/mason.nvim", "mfussenegger/nvim-dap" }}

-- Sirve para compilar c++ sin utilizar CMakeGenerate
vim.api.nvim_create_autocmd("FileType", { pattern = "cpp", 
    command = "map <f5> <ESC>:!g++ %<CR><CR><ESC>:FloatermNew<CR>./a.out<CR>"})

vim.api.nvim_create_autocmd("FileType", { pattern = "cpp", 
    command = "map <f6> <ESC>:FloatermNew<CR>g++ -std=c++17 -o test main.cpp && ./test<CR>"})

--Config DAP
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode-14', -- adjust as needed, must be absolute path
  name = 'lldb'
}

local dap = require('dap')
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

-- Sirve para lograr debugger grafico, notar que sin el dapui.setup() generara error.
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Sin esta linea no funcionara Dapui
dapui.setup()

-- jay-babu config, sirve para brindar mas opciones a dap
require ('mason-nvim-dap').setup({
    ensure_installed = {'stylua', 'jq'},
    opts = {
    handlers = {}, -- sets up dap in the predefined manner
  }
})

-- Color scheme nord
vim.g.nord_contrast = false
vim.g.nord_borders = false
vim.g.nord_disable_background = true
vim.g.nord_cursorline_transparent = true
vim.g.nord_enable_sidebar_background = false
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = false
vim.g.nord_bold = false
-- Load the colorscheme
require('nord').set()

--KEYMAPS..
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Define the Leader with space
vim.g.mapleader = ' '

-- compile json
vim.g.cmake_link_compile_commands = 1

-- For indent two spaces
vim.opt.sw=2

-- for show number and show in red error(alert) gitgutter
vim.opt.number = true

map ('n','<C-j>','<C-w>j')
map ('n','<C-h>','<C-w>h')
map ('n','<C-k>','<C-w>k')
map ('n','<C-x>','<C-w>l')

-- copy to system clipboard via <Ctrl-c> in visual mode.
map ('v','<C-c>','+y')

-- select all
map ('n','<C-a>','ggVG')

--close window
map ('n','<C-q>',':q<CR>')

--saveFiles
map ('n','<C-s>',':wa<CR>')
map ('i','<c-s><Esc>',':wa<CR>a')
map ('n','<C-w>h','<C-w>>')
map ('n','<C-w>j','<C-w>-')
map ('n','<C-w>k','<C-w>+')
map ('n','<C-w>l','<C-w><')

--KEYMAPS_PLUGS
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

-- CMake
keymap('', '<leader>mg', ':CMakeGenerate<cr>', {})
keymap('', '<leader>mb', ':CMakeBuild<cr>', {})
keymap('', '<leader>mt', ':CMakeTest<cr>', {})
keymap('', '<leader>mc', ':CMakeClean<cr>', {})
keymap('', '<leader>mq', ':CMakeClose<cr>', {})

-- DAP KeyMaps
keymap('', '<leader>db', ':DapToggleBreakpoint<cr>', {})
keymap('', '<leader>dr', ':DapContinue<cr>', {})
keymap('', '<leader>dt', ':DapTerminate<cr>', {})

-- floaterm
vim.cmd[[let g:floaterm_keymap_toggle = '<Leader>f']]
vim.cmd[[let g:floaterm_wintype = 'split']]
vim.cmd[[let g:floaterm_height = 0.3]]
keymap('', '<C-t>', ':FloatermNew fff<cr>', {})
map ('n','<leader>vv', ':vert :term<CR>')
set.splitright = true  --esto es para que la terminal vertical este en la izquierda

--AUTOTAG
require 'nvim-treesitter.configs'.setup {
    autotag = {
        enable = true,
    }
}

--COLORIZER
require 'colorizer'.setup()

-- COMMENT
require('Comment').setup {
    padding = true,
    sticky = true,
    ignore = '^$',
    toggler = {
        line = 'gcc',
        block = 'gbc',
    },
    opleader = {
        line = 'gc',
        block = 'gb',
    },
    extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
    },
    mappings = {
        basic = true,
        extra = false,
        extended = false,
    },
    pre_hook = nil,
    post_hook = nil,
}

--INDENTLINE
require("ibl").setup {
}

-- LUALINE
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { {
            'filename',
            file_status = true,
            path = 1
        } },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = { 'diagnostics' },
        lualine_b = {},
        lualine_c = { {
            'filename',
            file_status = true,
            path = 1
        } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
   }

-- LUASNIP
vim.keymap.set({ "i", "s" }, "<C-Tab>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })
-- snippets
local ls = require("luasnip")
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local date = function() return { os.date('%Y-%m-%d') } end
ls.add_snippets(nil, {
    all = {
        snip({
            trig = "date",
            namr = "Date",
            dscr = "Date in the form of YYYY-MM-DD",
        }, {
            func(date, {}),
        }),
        snip({
            trig = "meta",
            namr = "Metadata",
            dscr = "Yaml metadata format for markdown"
        },
            {
                text({ "---",
                    "title: " }), insert(1, "note_title"), text({ "",
                    "author: " }), insert(2, "author"), text({ "",
                    "date: " }), func(date, {}), text({ "",
                    "categories: [" }), insert(3, ""), text({ "]",
                    "lastmod: " }), func(date, {}), text({ "",
                    "tags: [" }), insert(4), text({ "]",
                    "comments: true",
                    "---", "" }),
                insert(0)
            }),
    },
})

require("luasnip.loaders.from_vscode").lazy_load()

-- NVIMTREE
require("nvim-tree").setup {
    auto_reload_on_write = true,
    disable_netrw = false,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    sort_by = "name",
    root_dirs = {},
    prefer_startup_root = false,
    sync_root_with_cwd = false,
    reload_on_bufenter = false,
    respect_buf_cwd = false,
    on_attach = "disable",
    select_prompts = false,
    view = {
        adaptive_size = false,
        centralize_selection = false,
        width = 30,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
                relative = "editor",
                border = "rounded",
                width = 30,
                height = 30,
                row = 1,
                col = 1,
            },
        },
    },
    renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "none",
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        symlink_destination = true,
    },
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = false,
        debounce_delay = 15,
        update_root = false,
        ignore_list = {},
    },
    --ignore_ft_on_setup = {},
    system_open = {
        cmd = "",
        args = {},
    },
    diagnostics = {
        enable = true,
        show_on_dirs = false,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    filters = {
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = {},
        exclude = {},
    },
    filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {},
    },
    git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 400,
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },
        expand_all = {
            max_folder_discovery = 300,
            exclude = {},
        },
        file_popup = {
            open_win_config = {
                col = 1,
                row = 1,
                relative = "cursor",
                border = "shadow",
                style = "minimal",
            },
        },
        open_file = {
            quit_on_open = true,
            resize_window = true,
            window_picker = {
                enable = true,
                picker = "default",
                chars = "abcdefghijklmnopqrstuvwxyz1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        },
        remove_file = {
            close_window = true,
        },
    },
    trash = {
        cmd = "gio trash",
        require_confirm = true,
    },
    live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
    },
    tab = {
        sync = {
            open = false,
            close = false,
            ignore = {},
        },
    },
    notify = {
        threshold = vim.log.levels.INFO,
    },
    log = {
        enable = false,
        truncate = false,
        types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
        },
    },
}
vim.keymap.set("n", "<Leader>t", ":NvimTreeToggle<CR>", {})

-- TELESCOPE
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
            }
        }
    },
    pickers = {
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
require('telescope').load_extension('fzf')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fg', builtin.git_commits, {})

-- TREESITTER
require 'nvim-treesitter.configs'.setup {
    ensure_installed = {},
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
}

-- LSP Configs
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require("mason").setup()
local lspconfig = require("lspconfig")
local function on_attach(client, bufnr)
    vim.keymap.set("n", "<C-f>", vim.lsp.buf.format, { buffer = 0 })
    vim.cmd [[
    highlight! DiagnosticLineNrError guibg=#3b161e guifg=#b01e1e gui=bold
    highlight! DiagnosticLineNrWarn guibg=#3b2f1e guifg=#a16b1d gui=bold
    highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#1cbaba gui=bold
    highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#195dd1 gui=bold

    sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
    sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
    sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
    sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
    ]]
end

lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.marksman.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.bashls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.cssls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.vimls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lua_ls = {
  Lua = {
    workspace = { checkThirdParty = false },
    telemetry = { enable = false },
  },
},
lspconfig.tsserver.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.html.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.jedi_language_server.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.pylsp.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.jdtls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
lspconfig.cmake.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
require("clangd_extensions").setup {
    server = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    extensions = {
        autoSetHints = false,
        inlay_hints = {
            only_current_line = false,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = true,
            right_align_padding = 0,
            highlight = "Comment",
            priority = 0,
        },
        ast = {
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },
            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },
            highlights = {
                detail = "Comment",
            },
            memory_usage = {
                border = "none",
            },
            symbol_info = {
                border = "none",
            },
        },
    }
}

-- nvim-cmp
vim.opt.completeopt = {
    "menu",
    "menuone",
    "noselect"
}
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- AQUI FINALIZA SAGA
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>df', '<Cmd>Lspsaga diagnostic_jump_next<cr>', opts)
vim.keymap.set('n', '<leader>dp', '<Cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<cr>', opts)
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<cr>', opts)
vim.keymap.set('n', '<leader>rn', '<Cmd>Lspsaga rename<cr>', opts)
vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
vim.keymap.set("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)

-- Use fontawesome icons as signs
local cmd = vim.cmd
local api = vim.api
end)
