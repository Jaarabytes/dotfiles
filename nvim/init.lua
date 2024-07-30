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
  use { "catppuccin/nvim", as = "catppuccin" }
end)

-- Theme Setup
vim.cmd('colorscheme catppuccin')


local packer = require('packer')

local function silent_packer_compile()
  packer.compile()
end

local function silent_packer_clean()
  packer.clean()
end

vim.defer_fn(function()
  silent_packer_compile()
  silent_packer_clean()
end, 100)
-- NERDTree Configuration
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap = true, silent = true})

-- LSP Configuration
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
local servers = {'tsserver', 'svelte', 'lua_ls', 'pyright', 'gopls'}

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
    theme = 'onedark'
  }
}

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = {"lua", "vim", "javascript", "typescript", "svelte", "go"},
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

-- Set up web-dev-icons
require'nvim-web-devicons'.setup {
 -- your personalization comes here...
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
}

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
