"
"  init.vim
"

" LOADING PLUGINS

call plug#begin()

" language server support
Plug 'neovim/nvim-lspconfig'

" autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" snippets
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Github Copilot
Plug 'github/copilot.vim'

" Navigation between files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Better git support
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" distraction free writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" wiki support
Plug 'vimwiki/vimwiki'

" python formatting
Plug 'python/black'

" LS support for vale in markdown
"Plug 'jose-elias-alvarez/null-ls.nvim'

call plug#end()


" EDITOR SETTINGS

" Use tabstop of 4 by default
set ts=4 sts=4 sw=4 et

" Keep buffers with unsaved changes around in the backgroun
set hidden

" Make search replace all occurrences by default
set gdefault

" Use comma for custom commands
let mapleader = ","

" Close buffer on ,b
nnoremap <leader>b :bd<cr>
" Close window only on ,B (keep buffer open)
nnoremap <leader>B :close<cr>

" Stop highlighting a search on ,_
nnoremap <leader><space> :noh<cr>

set nojoinspaces        " Prevent adding an extra space on join-after-punctuation
set showmatch           " Show matching brackets
set linebreak           " Wrap lines at word boundaries
set cursorline          " Underline the line the cursor is on

" Split windows more easily
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Strip trailing whitespace on save
autocmd BufWritePre Makefile\@<! :%s/\s\+$//e

" Navigate quickly up and down the quickfix list
nnoremap <C-m> :cn<cr>
nnoremap <C-n> :cb<cr>

set clipboard=unnamed

" Navigate up and down by visual lines, not by newlines
nnoremap j gj
nnoremap k gk

" Use <leader>u to open URLs
function! HandleURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;)]*')
  echo s:uri
  if s:uri != ""
    silent exec "!open '".s:uri."'"
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>u :call HandleURL()<cr>

set background=dark

" recommended: https://github.com/hrsh7th/nvim-cmp/
set completeopt=menu,menuone,noselect

"
" faster viewport scrolling
"
nnoremap <c-e> 5<c-e>
nnoremap <c-y> 5<c-y>

"
" LANGUAGE SERVERS
"
lua << EOF
require'lspconfig'.pyright.setup{}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" language server for vale
"lua << EOF
"require("null-ls").setup({
"    sources = {
"        require("null-ls").builtins.diagnostics.vale,
"    },
"})
"EOF

"
" CUSTOMIZE PLUGINS
"

lua << EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities
  }
EOF


" Goyo
nnoremap <leader>g :Goyo 45<cr>
let g:goyo_margin_top=1
let g:goyo_margin_bottom=1

" Limelight
let g:limelight_conceal_ctermfg='darkgrey'
nnoremap <leader>l :Limelight!!<cr>

" ,t to open any file
nnoremap <leader>t :Files<cr>
" ,f to switch to a file that's already open
nnoremap <leader>f :Buffers<cr>

" never include these filetypes in the list
set wildignore+=*.o,*.6,.git,.hg,.svn,*.a,*.so,*.out,*.bbl,*.swp,*.toc,_obj,_test,*-env,*.pyc,*.pyo,*.png,*.jpg,blueprint,*.os,*.gif,*.tar,*.tar.gz,*.tar.bz2,build,dist,*.egg-info,bin,*.class,*.jar,env,lib,__pycache__,tags,elm-stuff,node_modules,plugged,*.mp4,vendor,*.feather,*.ipynb

"
"  Copilot
"
"  Disable copilot by default, to avoid leaking sensitive data.
"
let g:copilot_filetypes = {
    \ '*': v:false,
    \ 'python': v:true,
    \ 'vim': v:true,
    \ 'yaml': v:true,
    \ 'typescript': v:true,
    \ 'javascript': v:true,
    \ 'html': v:true,
    \ 'css': v:true,
    \ }


"
" OVERRIDE WITH LOCAL SETTINGS
"

" Allow customisations for the local machine
let localrc =  expand("~/.config/nvim/init-local.vim")
if filereadable(localrc)
    exe "source " . localrc
endif

"
" RESOURCES
"
" http://nerditya.com/code/guide-to-neovim/
"
