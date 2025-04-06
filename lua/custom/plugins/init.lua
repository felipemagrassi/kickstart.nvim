-- You can add your own plugins here or in other files in this directory!custom
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank to clipboard' })
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>mq', "<cmd>:%s/^/'/c | %s/$/',/c<cr>", { desc = 'Add quotes and commas' })
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<leader>x', '<cmd>:qa!<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').commands, { desc = '[S]earch [C]ommands' })

vim.keymap.set('n', '<leader>oc', '<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/custom/plugins/init.lua<CR>',
  { desc = 'Open Config' })
vim.keymap.set('n', '<leader>ot', '<cmd>e ~/todo.txt<CR>', { desc = 'Open Todo' })

vim.opt.spell = false
vim.opt.spelllang = 'pt_br,en_us'

vim.g.have_nerd_font = true

vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.cursorline = true
vim.opt.numberwidth = 4
vim.opt.ruler = true
vim.opt.scrolloff = 8
vim.opt.smartcase = true

require('which-key').add {
  { '<leader>o', group = '[O]pen' },
  { '<leader>d', group = '[C-t]est' },
  { '<leader>g', group = '[G]it' },
  { '<leader>m', group = '[M]agestic Scripts' },
}

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      'node_modules',
      '.git',
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    live_grep = {
      hidden = true,
    },
    colorscheme = {
      enable_preview = true,
    },
  },
}

local lint = require 'lint'
lint.linters_by_ft = {
  ruby = { 'ruby' },
  dockerfile = { 'hadolint' },
  typescript = { 'eslint_d' },
  eruby = { 'erblint' },
}

local conform = require 'conform'
conform.formatters_by_ft = {
  javascript = { 'prettierd', 'prettier' },
  javascriptreact = { 'prettierd', 'prettier' },
  typescript = { 'prettierd', 'prettier' },
  typescriptreact = { 'prettierd', 'prettier' },
  ruby = { 'rubocop' },
  eruby = { 'erb_lint' },
}
conform.format_on_save = function(bufnr)
  -- Disable "format_on_save lsp_fallback" for languages that don't
  -- have a well standardized coding style. You can add additional
  -- languages here or re-enable it for the disabled ones.
  local disable_filetypes = { c = true, cpp = true }
  return {
    timeout_ms = 5000,
    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
  }
end

return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>g', [[<cmd>Git<cr>]], { desc = 'Git' } },
    },
  },
  {
    'tpope/vim-rhubarb',
  },
  {
    'https://github.com/rafamadriz/friendly-snippets',
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { '<leader>e', ':Oil<cr>', {
        noremap = true,
        silent = true,
        desc = 'Oil',
      } },
    },
    config = function()
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
      }
    end,
  },
  {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'nvim-telescope/telescope-live-grep-args.nvim',
    -- This will not install any breaking changes.
    -- For major updates, this must be adjusted manually.
    version = '^1.0.0',
    config = function()
      require('telescope').load_extension 'live_grep_args'
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  { 'tpope/vim-dispatch' },
  { 'rebelot/kanagawa.nvim' },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)

      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      vim.keymap.set('n', '<C-1>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<C-2>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<C-3>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<C-4>', function()
        harpoon:list():select(4)
      end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end)
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
            .new({}, {
              prompt_title = 'Harpoon',
              finder = require('telescope.finders').new_table {
                results = file_paths,
              },
              previewer = conf.file_previewer {},
              sorter = conf.generic_sorter {},
            })
            :find()
      end

      vim.keymap.set('n', '<leader>se', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    event = 'VimEnter',
    config = function()
      require('catppuccin').setup {
        transparent_background = true,
        term_colors = true,
      }
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        -- ...
      }
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    keys = {
      { '<leader>mp', ':MarkdownPreview<cr>', {
        noremap = true,
        silent = true,
        desc = 'Markdown Preview',
      } },
    },
    ft = 'markdown',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/neotest-go',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'olimorris/neotest-rspec',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)
      require('neotest').setup {
        adapters = {
          require 'neotest-vitest' {
            filter_dir = function(name, rel_path, root)
              return name ~= 'node_modules'
            end,
          },
          require 'neotest-jest' {
            jestCommand = 'npm test --',
            jestConfigFile = 'custom.jest.config.ts',
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          },
          require 'neotest-go' {
            recursive_run = true,
            experimental = {
              test_table = true,
            },
            args = { '-v', '-count=1' },
          },
          require 'neotest-rspec' {
            rspec_cmd = function()
              return vim.tbl_flatten {
                'bundle',
                'exec',
                'rspec',
              }
            end,
          },
        },
      }

      vim.keymap.set('n', '<M-t>n', function()
        require('neotest').run.run()
      end, { desc = 'Test Nearest' })
      vim.keymap.set('n', '<M-t>f', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = 'Test File' })
      vim.keymap.set('n', '<M-t>p', function()
        require('neotest').output_panel.toggle()
        require('neotest').summary.toggle()
      end, { desc = 'Toggle Neotest Panel' })
    end,
  },
  {
    'vim-test/vim-test',
    config = function()
      vim.cmd [[ let g:test#strategy = 'neovim' ]]
      vim.cmd [[ let g:test#neovim#start_normal = 1 ]]
      vim.cmd [[ let g:test#neovim#term_position = "vert botright" ]]
      vim.cmd [[ let g:test#javascript#runner = 'jest' ]]
      vim.cmd [[ let g:test#preserve_screen = 1 ]]
      vim.cmd [[ let g:test#ruby#rspec#executable = 'bundle exec rspec' ]]
      vim.cmd [[ let g:test#ruby#rspec#options = '--format documentation --color' ]]
    end,
    keys = {
      { '<C-t>n', ':TestNearest<cr>', { desc = 'Test Nearest' } },
      { '<C-t>f', ':TestFile<cr>',    { desc = 'Test File' } },
      { '<C-t>s', ':TestSuite<cr>',   { desc = 'Test Suite' } },
      { '<C-t>l', ':TestLast<cr>',    { desc = 'Test Last' } },
      { '<C-t>v', ':TestVisit<cr>',   { desc = 'TestVist' } },
    },
  },
  { 'EdenEast/nightfox.nvim' },
  { 'xiyaowong/transparent.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  {
    'vhyrro/luarocks.nvim',
    priority = 1000,
    config = true,
    opts = {
      rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' },
    },
  },
  {
    'rest-nvim/rest.nvim',
    ft = 'http',
    dependencies = { 'luarocks.nvim' },
    config = function()
      require('rest-nvim').setup()
    end,
  },
  { 'fatih/vim-go', ft = 'go' },
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('cyberdream').setup {
        transparent = false,
        -- Options will go here
      }
    end,
  },
  {
    'xiyaowong/nvim-transparent',
    lazy = false,
    priority = 1000,
  },
  {
    'pappasam/papercolor-theme-slim',
    lazy = false,
    priority = 1000,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = 'claude',
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4o',  -- your desired model (or use gpt-4o, etc.)
        timeout = 30000,   -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick',         -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp',              -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua',              -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons',   -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua',        -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_transparent_background = 1
      vim.g.everforest_enable_italic = true
    end,
  },
}
