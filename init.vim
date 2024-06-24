" ~/.config/nvim/init.vim or ~/.vimrc

" General settings
set number                     " Show line numbers
set relativenumber             " Show relative line numbers
set expandtab                  " Use spaces instead of tabs
set tabstop=4                  " Number of spaces tabs count for
set shiftwidth=4               " Size of an indent
set smartindent                " Insert indents automatically
set hidden                     " Enable background buffers
set nobackup                   " Don't save backup files
set nowritebackup              " Don't save backup files while editing
set cmdheight=2                " More space for displaying messages
set updatetime=300             " Faster completion
set timeoutlen=500             " By default timeoutlen is 1000 ms
set clipboard=unnamedplus      " Copy paste between vim and everything else
set ignorecase                 " Ignore case when searching
set smartcase                  " Don't ignore case with capitals
set incsearch                  " Incremental search
set scrolloff=8                " Start scrolling when we're 8 lines away from margins

" Specify where plugins should be installed
call plug#begin('~/.local/share/nvim/plugged')

" List your plugins here
Plug 'preservim/nerdtree'
Plug 'plasticboy/vim-markdown'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'  " dependency for telescope
Plug 'nvim-lualine/lualine.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'evanleck/vim-svelte'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-surround'     " Surround text objects easily
Plug 'tpope/vim-commentary'   " Comment stuff out
Plug 'jiangmiao/auto-pairs'   " Insert or delete brackets, parens, quotes in pair
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Better syntax highlighting
Plug 'folke/tokyonight.nvim'  " A clean, dark Neovim theme

" End of plugin list
call plug#end()

" Color scheme
colorscheme tokyonight

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
let NERDTreeShowHidden=1

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quickly edit/reload the vimrc file
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Remove search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Toggle relative line numbers
nnoremap <leader>rn :set relativenumber!<CR>

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Remap ESC to jj
inoremap jj <ESC>

" Move lines up and down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep search terms centered
nnoremap n nzzzv
nnoremap N Nzzzv

" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Auto commands
augroup autosourcing
    autocmd!
    autocmd BufWritePost $MYVIMRC source %
augroup END

" Setup Lua Line
lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
EOF

" Setup Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOF
