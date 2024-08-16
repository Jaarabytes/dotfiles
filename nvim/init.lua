-- Basic Settings
vim.g.mapleader = "\\"  -- Set leader key to \
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
vim.opt.conceallevel = 0  -- Show `` in markdown files

-- Plugin Setup (using lazy.nvim)
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
  -- LSP
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  'windwp/nvim-autopairs',
  -- Utilities
  "nvim-treesitter/nvim-treesitter",
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
  -- UI
  "nvim-lualine/lualine.nvim",
  "lewis6991/gitsigns.nvim",
  { "catppuccin/nvim", name = "catppuccin" },
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
})

-- Theme Setup
vim.cmd('colorscheme catppuccin')

-- LSP Configuration
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'svelte', 'lua_ls', 'pyright', 'gopls'}
})

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

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

local capabilities = cmp_nvim_lsp.default_capabilities()

local servers = {'tsserver', 'svelte', 'lua_ls', 'pyright', 'gopls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
}

-- Nvim-tree Configuration
require("nvim-tree").setup()

-- Lualine Configuration
require('lualine').setup { options = { theme = 'catppuccin' } }

-- Gitsigns setup
require('gitsigns').setup()

-- Autopairs Configuration
require('nvim-autopairs').setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},  -- don't add pairs in lua string treesitter nodes
    javascript = {'template_string'},  -- don't add pairs in javascript template_string treesitter nodes
  },
})

-- If you want to automatically add `(` after selecting a function or method
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)


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

-- Auto Commands
vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" and vim.bo.modified then
      local fname = vim.fn.expand('%')
      if fname ~= '' and not vim.o.readonly then
        vim.cmd('silent update')
      end
    end
  end
})
