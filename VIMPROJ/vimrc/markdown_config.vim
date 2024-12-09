"==============================================================================
" Description: global plugin for lawrencechi
" Author:      lawrencechi <codeforfuture <at> 126.com>
" Last Change: 2024.12.09
" License:     This file is placed in the public domain.
" Version:     1.0.0
"==============================================================================

" 定义保存每个缓冲区配置的全局字典
let g:buffer_configs = {}

" 保存当前配置的函数
function! SaveCurrentConfig()
  let buf = bufnr('%')
  if !has_key(g:buffer_configs, buf)
    let g:buffer_configs[buf] = {
          \ 'colorscheme': substitute(execute('colorscheme'), '\n', '', 'g'),
          \ 'guifont': &guifont,
          \ 'rnu': &rnu,
          \ 'colorcolumn': &colorcolumn,
          \ 'wrap': substitute(execute('set wrap?'), '\n', '', 'g'),
          \ }
  endif
endfunction

" 恢复配置的函数
function! RestoreOriginalConfig()
  let buf = bufnr('%')
  if has_key(g:buffer_configs, buf)
    let config = g:buffer_configs[buf]
    if config['colorscheme'] != ""
      execute 'colorscheme ' . config['colorscheme']
    endif
    let &guifont = config['guifont']
    if config['rnu'] == 1
      set rnu
    else
      set nornu
    endif
    if config['colorcolumn'] != 0
      execute 'set colorcolumn=' . config['colorcolumn']
    endif

    if config['wrap'] != 0
      execute 'set ' . config['wrap']
    endif

    " 移除已恢复的配置，防止泄露内存
    call remove(g:buffer_configs, buf)
  endif
endfunction

" 设置Markdown配置的函数
function! SetMarkdownConfig()
  call SaveCurrentConfig()
  colorscheme acme
  set guifont=Bitstream_Vera_Sans_Mono:h12:cANSI:qDRAFT
  set nornu
  set colorcolumn=0
  set wrap
endfunction

" 自动应用配置
autocmd BufEnter *.md call SetMarkdownConfig()
autocmd BufLeave *.md call RestoreOriginalConfig()

" 窗口切换处理
autocmd WinEnter * if &filetype ==# 'markdown' | call SetMarkdownConfig() | elseif exists('g:buffer_configs') | call RestoreOriginalConfig() | endif
