" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Dec 17
"
" To use it, copy it to
"	       for Unix:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"	 for MS-Windows:  $VIM\_vimrc
"	      for Haiku:  ~/config/settings/vim/vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" Automatic Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug' " Let vim-plug manage itself

" Colorschemes
Plug 'blueshirts/darcula'

" Syntax
Plug 'tpope/vim-git', { 'for': 'git' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'aklt/plantuml-syntax'
Plug 'vim-scripts/applescript.vim'
Plug 'tikhomirov/vim-glsl'

" Tools
Plug 'qpkorr/vim-renamer'
Plug 'guns/xterm-color-table.vim'

" Auto complete
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
"Plug 'Rip-Rip/clang_complete'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
"Plug 'davidhalter/jedi-vim', { 'for': 'python' }
"Plug 'SirVer/ultisnips'
Plug 'rust-lang/rust.vim'

" Code linting
Plug 'vim-syntastic/syntastic'
Plug 'github/copilot.vim'

" Status line
"Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plug 'vim-airline/vim-airline'

" Minimap
"Plug 'severin-lemaignan/vim-minimap'

Plug 'pbrisbin/vim-mkdir'
call plug#end()

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  " set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undodir=$HOME/.vim/undo
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

no t l
"nnoremap <Tab> <Esc>
"vnoremap <Tab> <Esc>gV
"onoremap <Tab> <Esc>
"inoremap <Tab> <Esc>
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <S-Tab> <Tab>

"""""""""""""""""""""""" Begin coc.nvim config """""""""""""""""""""""""""""""""
inoremap <silent><expr> <TAB>
      \ coc#expandableOrJumpable() ? "\<C-j>" :
      \ "<Esc>"
"inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
let g:coc_snippet_next = '<Tab>'

set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> gn <Plug>(coc-diagnostic-next)

"noremap <silent> gd :call CocActionAsync('jumpDefinition')<CR>
"noremap <silent> gr :call CocActionAsync('jumpReferences')<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"nn <silent> gh :call CocActionAsync('doHover')<cr>
" Show documentation in preview window.
nnoremap <silent> gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <F2> <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
"nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"omap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
"""""""""""""""""""""""" End coc.nvim recommend config """""""""""""""""""""""""""""""""
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']
"""""""""""""""""""""""" End coc.nvim my config """"""""""""""""""""""""""""""""""""""""

set number
"set relativenumber
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set t_Co=256
set cursorline
set cc=101
set scrolloff=8
set foldmethod=syntax
" zo to fold, zc to cloce fold
set foldlevelstart=99
set ignorecase
set smartcase

set directory-=.
set directory^=$HOME/.vim/swap//

"set background=dark

"let g:molokai_original=1
"let g:rehash256 = 1
colorscheme darcula

"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
"colorscheme solarized

"hi Normal ctermbg=NONE
"hi LineNr ctermbg=NONE

" set filetype
if has("autocmd")
  au BufNewFile,BufReadPost *.rkt,*.rktl set filetype=scheme
  au BufNewFile,BufReadPost *.vs,*.fs set filetype=glsl
endif

let python_highlight_all = 1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_cpp_cpplint_args = '--verbose=3 --filter=-build/include_subdir,-whitespace/braces'
let g:syntastic_cpp_checkers = ['cpplint']
"let g:syntastic_cpp_checkers = ['cpplint', 'clang_tidy']
" clang_tidy is great, but slow. Enable only before commit
let g:syntastic_c_config_file = 'syntastic_c_config_file'
let g:syntastic_clang_tidy_config_file = 'syntastic_c_config_file'
let g:syntastic_c_clang_tidy_post_args = ""
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--max-line-length 100'
nnoremap lo :lopen<CR>
nnoremap lc :lclose<CR>
nnoremap ln :lnext<CR>
nnoremap lp :lprev<CR>

"let g:airline_powerline_fonts = 1
" use % to jump to pairing bracket

imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
