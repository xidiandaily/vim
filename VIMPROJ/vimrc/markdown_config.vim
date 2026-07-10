"==============================================================================
" Description: global plugin for lawrencechi
" Author:      lawrencechi <codeforfuture <at> 126.com>
" Last Change: 2024.12.09
" License:     This file is placed in the public domain.
" Version:     1.0.0
"==============================================================================

" 定义保存每个缓冲区配置的全局字典
let g:markdown_buffer_configs = {}

" 保存当前配置的函数
function! SaveCurrentConfig()
  let buf = bufnr('%')
  if !has_key(g:markdown_buffer_configs, buf)
    let g:markdown_buffer_configs[buf] = {
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
  if has_key(g:markdown_buffer_configs, buf)
    let config = g:markdown_buffer_configs[buf]
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
    call remove(g:markdown_buffer_configs, buf)
  endif
endfunction

" 设置Markdown配置的函数
function! SetMarkdownConfig()
  call SaveCurrentConfig()
  "colorscheme acme
  colorscheme pencil
  "set guifont=Bitstream_Vera_Sans_Mono:h11:cANSI:qDRAFT,Microsoft_YaHei:h11 "记住空格用下划线代替哦
  set guifont=更纱终端书呆黑体-简:h12
  set nornu
  set colorcolumn=0
  set wrap
  set bg=light
  set nofoldenable
  :SoftPencil
  let g:vim_markdown_fenced_languages = ['csharp=cs']
  "let g:pencil#softDetectThreshold = 130
endfunction

"augroup FixEasyMotionReflowInGoyo
"  autocmd!
"  autocmd User EasyMotionPromptBegin call s:em_begin()
"  autocmd User EasyMotionPromptEnd   call s:em_end()
"augroup END
"
"function! s:em_begin() abort
"  " 保存当前窗口的设置（用 w: 变量避免互相污染）
"  let w:em_save_wrap = &l:wrap
"  let w:em_save_lbr  = &l:linebreak
"
"  echom "w:em_save_wrap" w:em_save_wrap
"  echom "w:em_save_lbr" w:em_save_lbr
"
"  " 提示阶段禁用软换行重排
"  setlocal nowrap
"  setlocal nolinebreak
"
"  redraw!
"endfunction
"
"function! s:em_end() abort
"  if exists('w:em_save_wrap')
"    echom "reset &l:wrap" w:em_save_wrap
"    let &l:wrap = w:em_save_wrap
"    unlet w:em_save_wrap
"  endif
"  if exists('w:em_save_lbr')
"    echom "reset &l:linebreak" w:em_save_lbr
"    let &l:linebreak = w:em_save_lbr
"    unlet w:em_save_lbr
"  endif
"
"  redraw!
"endfunction


" 自动应用配置
"autocmd BufEnter *.md call SetMarkdownConfig()
"autocmd BufLeave *.md call RestoreOriginalConfig()

" 窗口切换处理
" autocmd WinEnter * if &filetype ==# 'markdown' | call SetMarkdownConfig() | elseif exists('g:markdown_buffer_configs') | call RestoreOriginalConfig() | endif
