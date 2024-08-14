-- Init.lua

-- Basic Settings
vim.g.mapleader = " "  -- Set leader key to space
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.clipboard = "unnamedplus"
opt.conceallevel = 0  -- Show `` in markdown files

-- Plugin Setup
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

require("lazy").setup({
  -- Essential plugins
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "nvim-treesitter/nvim-treesitter",
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-lualine/lualine.nvim",
  "lewis6991/gitsigns.nvim",
  "windwp/nvim-autopairs",
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "folke/which-key.nvim",
    config = function() require("which-key").setup() end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- Add more plugins here
})

-- Theme Setup
vim.cmd('colorscheme catppuccin')

-- LSP Configuration
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
local servers = {'tsserver', 'svelte', 'lua_ls', 'pyright', 'gopls'}

local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
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
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
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

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = {"lua", "vim", "javascript", "typescript", "svelte", "go"},
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- Nvim-tree Configuration
require("nvim-tree").setup({
  filters = {
    dotfiles = false,  -- Show dotfiles
  },
})

-- Lualine Configuration
require('lualine').setup { options = { theme = 'catppuccin' } }

-- Autopairs setup
require('nvim-autopairs').setup{}

-- Gitsigns setup
require('gitsigns').setup()

-- Key Mappings
local keymap = vim.keymap.set
keymap('n', '<leader>w', ':w<CR>', {noremap = true})
keymap('n', '<leader>q', ':q<CR>', {noremap = true})
keymap('n', '<leader>h', ':nohl<CR>', {noremap = true})
keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {noremap = true})
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {noremap = true})
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {noremap = true})
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {noremap = true})
keymap('n', '<leader>gc', '<cmd>Telescope git_commits<cr>', {noremap = true})
keymap('n', '<leader>gb', '<cmd>Telescope git_branches<cr>', {noremap = true})
keymap('n', '<leader>gs', '<cmd>Telescope git_status<cr>', {noremap = true})
keymap('n', '<C-h>', '<C-w>h', {noremap = true})
keymap('n', '<C-j>', '<C-w>j', {noremap = true})
keymap('n', '<C-k>', '<C-w>k', {noremap = true})
keymap('n', '<C-l>', '<C-w>l', {noremap = true})
keymap('v', '<', '<gv', {noremap = true})
keymap('v', '>', '>gv', {noremap = true})
keymap('v', 'J', ":m '>+1<CR>gv=gv", {noremap = true})
keymap('v', 'K', ":m '<-2<CR>gv=gv", {noremap = true})

-- Auto Commands
vim.cmd([[
  augroup AutoSave
    autocmd!
    autocmd TextChanged,TextChangedI <buffer> silent write
  augroup END

  augroup HideGitIgnored
    autocmd!
    autocmd VimEnter,WinEnter * if &ft != 'help' | setlocal conceallevel=2 | endif
  augroup END
]])

-- Enable viewing .env files
vim.cmd([[
  autocmd BufRead,BufNewFile .env* set filetype=sh
]])
