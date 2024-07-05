-- Init.lua

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

-- Plugin Setup (using packer instead of vim-plug for Lua compatibility)
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'preservim/nerdtree'
  use 'plasticboy/vim-markdown'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'evanleck/vim-svelte'
  use 'pangloss/vim-javascript'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'jiangmiao/auto-pairs'
  use 'nvim-tree/nvim-web-devicons'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'navarasu/onedark.nvim'  -- Similar to Tokyo Night
end)

-- Theme Setup
vim.cmd('colorscheme onedark')

-- NERDTree Configuration
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap = true, silent = true})

-- LSP Configuration
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
local servers = {'tsserver', 'svelte', 'lua_ls', 'pyright'}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }
end

-- Autocompletion Setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Telescope Configuration
local telescope = require('telescope')
telescope.setup()
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {noremap = true})

-- Lualine Configuration
require('lualine').setup {
  options = {
    theme = 'nightfox'
  }
}

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = {"lua", "vim", "javascript", "typescript", "svelte"},
  highlight = {
    enable = true,
  },
}

-- Null-ls Configuration (for linting and formatting)
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint,
  },
})

-- Key Mappings
vim.g.mapleader = "\\"
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>h', ':nohl<CR>', {noremap = true})

-- Auto Commands
vim.cmd([[
  augroup AutoSave
    autocmd!
    autocmd TextChanged,TextChangedI <buffer> silent write
  augroup END
]])
