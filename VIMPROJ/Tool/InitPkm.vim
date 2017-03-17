"函数
function UPFILE_pkm()
    call TarModifyFile()
endfunction

function! InitPkm()
    let g:chiylown_func_dict["UPFILE"]["pkm"]="UPFILE_pkm"
endfunction
