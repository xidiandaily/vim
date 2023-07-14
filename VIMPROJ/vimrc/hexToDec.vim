"==============================================================================
" Description: global plugin for lawrencechi
" Author:      lawrencechi <codeforfuture <at> 126.com>
" Last Change: 2023.07.13
" License:     This file is placed in the public domain.
" Version:     1.0.0
"==============================================================================

function! GetSelectedText() abort
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    if len(lines) == 0
        return ''
    elseif len(lines) == 1
        return lines[0][col1 - 1 : col2 - 1]
    else
        let lines[0] = lines[0][col1 - 1 :]
        let lines[-1] = lines[-1][: col2 - 2]
    endif
    return join(lines, "\n")
endfunction

" 将十六进制数字转成10进制数字
function! SelectHexToDec()
    let sel = GetSelectedText()

    let hex_pattern = '\v0x[0-9a-fA-F]+'
    let hex_string = matchstr(sel, hex_pattern)
    if empty(hex_string)
        echom "select text:". sel." No hex string found"
    endif
    let dec_value = str2nr(hex_string, 16)
    echom "select text:". hex_string." Decimal value: " .dec_value
endfunction

if has('gui_running')
  if &mousemodel =~? 'popup'
    anoremenu <silent> PopUp.L&aw.hexToDec
	  \ :call SelectHexToDec()<CR>
  endif
endif

