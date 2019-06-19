"
" Author: Daniil Velichko <daniil@squaredu.cc>
"
" -----------------------------------------------------------------------------
" Key bindings                                                            @keys
" -----------------------------------------------------------------------------
"
" Frequent operations are mapped to <space><key>
" More obscure operations are mapped to <leader><group><key>
"
" # Navigation
"
" <space>t - Toggle tabs sidebar
" <space>d - Toggle directory tree
" <space>D - Show current buffer in directory tree
"
" # Search
"
" <space>/ - Search in files
"
" <space>p - Go to file
" <space>b - Go to buffer
" <space>l - Go to line in current buffer
" <space>L - Go to line in all opened buffers
" <space>. - Go to alternate file
"
" <leader>/ - Cancel search highlight
"
" # Editing
"
" ga - Align text
"
" # Code
"
" gd - Go to definition
" gD - Go to declaration
" gp - Go to previous error
" gn - Go to next error
" gt - Go to type definition
" <space>a - List code actions
" <space>f - Format buffer
" <space>h - Show hover information
" <space>i - Show implementation
" <space>r - Show references
" <space>R - Rename symbol
"
" # Meta
"
" <leader>mc - Edit vim config
" <leader>mr - Reload vim config
"
" -----------------------------------------------------------------------------
" Plugins                                                                 @plug
" -----------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'drewtempelmeyer/palenight.vim'
Plug 'itchyny/lightline.vim'

Plug 'itchyny/vim-gitbranch'
Plug 'airblade/vim-gitgutter'

Plug 'kien/tabman.vim'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-omni.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'https://github.com/Alok/notational-fzf-vim'

Plug 'scrooloose/nerdtree'
Plug 'uptech/alt'
Plug 'dyng/ctrlsf.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'

Plug 'gcmt/wildfire.vim'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'vim-ruby/vim-ruby'

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

call plug#end()

" -----------------------------------------------------------------------------
" Meta                                                                    @meta
" -----------------------------------------------------------------------------

let mapleader = ","

set nobackup
set noswapfile

set hidden

syntax enable
filetype indent on

set wildmenu

set splitbelow
set splitright

nnoremap <leader>mc :vsp $MYVIMRC<cr>
nnoremap <leader>mr :source $MYVIMRC<cr>

set grepprg=rg\ --vimgrep

let g:nv_search_paths = ['~/Notes']
nnoremap <space>n :NV<cr>

" -----------------------------------------------------------------------------
" Appearance                                                        @appearance
" -----------------------------------------------------------------------------

set showtabline=0
set scrolloff=10
set mouse=a
set number
set cursorline
set showmatch
set nowrap
set signcolumn=yes

if (has("termguicolors"))
  set termguicolors
endif

set background=dark
colorscheme palenight

set noshowmode
let g:lightline = {
      \ 'colorscheme': 'palenight',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

let g:gitgutter_map_keys = 0

" -----------------------------------------------------------------------------
" Editing                                                              @editing
" -----------------------------------------------------------------------------

set autoread                                                                                                                                                                                    
au CursorHold * checktime  

set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Asyncomplete

let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 0
let g:asyncomplete_auto_popup = 0
set completeopt+=preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Tab completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

" Asyncomplete sources

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
\ 'name': 'omni',
\ 'whitelist': ['*'],
\ 'blacklist': ['c', 'cpp', 'html'],
\ 'completor': function('asyncomplete#sources#omni#completor')
\  }))

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx'],
        \ })
endif

if executable('solargraph')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
endif

" Prettier
let g:prettier#quickfix_enabled = 0
let g:prettier#exec_cmd_async = 1

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html,*.rb PrettierAsync

" -----------------------------------------------------------------------------
" Navigation                                                        @navigation
" -----------------------------------------------------------------------------

nnoremap j gj
nnoremap k gk

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

let g:tabman_toggle = '<space>t'
let g:tabman_side = 'right'
let g:tabman_number = 0

" -----------------------------------------------------------------------------
" Search                                                                @search
" -----------------------------------------------------------------------------

nnoremap <space>/ :CtrlSF<space>

"
" # Buffer search
"

set incsearch
set hlsearch
nnoremap <leader>/ :nohlsearch<cr>

"
" # Alt
"

function! AltCommand(path, vim_command)
	let l:alternate = system("find . -path ./_site -prune -or -path ./target -prune -or -path ./.DS_Store -prune -or -path ./build -prune -or -path ./Carthage -prune -or -path tags -prune -or -path ./tmp -prune -or -path ./log -prune -or -path ./.git -prune -or -path ./dist -prune -or -path ./node_modules -prune -or -type f -print | alt -f - " . a:path)
	if empty(l:alternate)
		echo "No alternate file for " . a:path . " exists!"
	else
		exec a:vim_command . " " . l:alternate
	endif
endfunction
nnoremap <space>. :w<cr>:call AltCommand(expand('%'), ':e')<cr>


"
" # NERDTree
"

nnoremap <space>d :NERDTreeToggle<cr>
nnoremap <space>D :NERDTreeFind<cr>

let NERDTreeMinimalUI=1
let NERDTreeQuitOnOpen=1
let NERDTreeDirArrows=1
let NERDTreeAutoDeleteBuffer=1

"
" # FZF
"

" Keybinds
nnoremap <space>p :Files<cr>
nnoremap <space>b :Buffers<cr>
nnoremap <space>l :BLines<cr>
nnoremap <space>L :Lines<cr>

" Actions
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default command
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow'

" Use ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview(),
  \   <bang>0)

" Use file previews
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Default fzf layout
let g:fzf_layout = { 'window': '20split enew' }

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


" -----------------------------------------------------------------------------
" Language specifics                                                      @lang
" -----------------------------------------------------------------------------

"
" Filetype config
"

augroup language_config
  au!
  autocmd FileType javascript setlocal expandtab
  autocmd FileType javascript setlocal tabstop=2
  autocmd FileType javascript setlocal shiftwidth=2
  autocmd FileType javascript setlocal softtabstop=2

  autocmd FileType typescript setlocal expandtab
  autocmd FileType typescript setlocal tabstop=2
  autocmd FileType typescript setlocal shiftwidth=2
  autocmd FileType typescript setlocal softtabstop=2

  autocmd FileType typescript.tsx setlocal expandtab
  autocmd FileType typescript.tsx setlocal tabstop=2
  autocmd FileType typescript.tsx setlocal shiftwidth=2
  autocmd FileType typescript.tsx setlocal softtabstop=2

  autocmd FileType ruby setlocal expandtab
  autocmd FileType ruby setlocal tabstop=2
  autocmd FileType ruby setlocal shiftwidth=2
  autocmd FileType ruby setlocal softtabstop=2

  autocmd FileType markdown setlocal expandtab
  autocmd FileType markdown setlocal tabstop=2
  autocmd FileType markdown setlocal shiftwidth=2
  autocmd FileType markdown setlocal softtabstop=2
augroup END

"
" Lsp
"

let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 0

let g:lsp_signs_error = {'text': '!!'}
let g:lsp_signs_warning = {'text': '??'}
let g:lsp_signs_hint = {'text': '..'}
let g:lsp_signs_information = {'text': '..'}

let s:severity_sign_names_mapping = {
    \ 1: 'LspError',
    \ 2: 'LspWarning',
    \ 3: 'LspInformation',
    \ 4: 'LspHint',
    \ }

if !hlexists('LspErrorText')
    highlight link LspErrorText Error
endif

nnoremap gd :LspDefinition<cr>
nnoremap gD :LspDeclaration<cr>
nnoremap gp :LspPreviousError<cr>
nnoremap gn :LspNextError<cr>
nnoremap gt :LspTypeDefinition<cr>

nnoremap <space>a :LspCodeAction<cr>
nnoremap <space>f :LspDocumentFormat<cr>
nnoremap <space>h :LspHover<cr>
nnoremap <space>i :LspImplementation<cr>
nnoremap <space>r :LspReferences<cr>
nnoremap <space>R :LspRename<cr>
