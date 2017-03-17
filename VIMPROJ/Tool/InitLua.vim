function! UPFILE_lua()
    call TarModifyFile()
endfunction

function! InitLua()
    :set tags+=$VIMPROJ/vimlib/lua-5.1.5/tags,
    let g:chiylown_func_dict["UPFILE"]["lua"]="UPFILE_lua"
endfunction
