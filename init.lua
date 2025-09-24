-- init.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy
require("lazy").setup({
 
  -- telescope ( morden fuzzy)
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  
  --theme 
  "nyoom-engineering/oxocarbon.nvim",
  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    },
  },
 
  -- FZF
  { "junegunn/fzf", build = "./install --bin" },
  { "junegunn/fzf.vim" },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completion
      "L3MON4D3/LuaSnip",     -- Snippet engine
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
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
          { name = "nvim_lsp" },
        }),
      })
    end,
  },
  
  -- LSP + Mason
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",       -- Python
          "clangd",        -- C/C++
          "gopls",         -- Go
          "rust_analyzer", -- Rust
          "vtsls",         -- JavaScript / TypeScript
        },
      })
    end,
  },

  {
    "theHamsta/nvim_rocks",
    event = "VeryLazy",
    build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
    config = function()
      ---- Add here the packages you want to make sure that they are installed
      --local nvim_rocks = require "nvim_rocks"
      --nvim_rocks.ensure_installed "uuid
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = { "pyright", "clangd", "gopls", "rust_analyzer", "vtsls" }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({ capabilities = capabilities })
      end
    end,
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- General settings
vim.o.number = true              -- show line numbers
vim.o.relativenumber = false     -- absolute numbers
vim.o.clipboard = "unnamedplus"  -- use system clipboard (yy, dd, p, etc.)
vim.o.termguicolors = true       -- enable true color

--theme
vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme "oxocarbon"

-- FZF mappings
vim.keymap.set("n", "<leader>f", ":Files<CR>", { silent = true })
vim.keymap.set("n", "<leader>g", ":Rg<CR>", { silent = true })
