"º¯Êý
function UPFILE_python()
    call TarModifyFile()
endfunction

function CSTAG_python()
    echohl WarningMsg | echo "Python not support generate cstag!" | echohl None
endfunction

function ASTYLE_python()
    echohl WarningMsg | echo "Python not support asytle!" | echohl None
endfunction

function! InitPython()
    let g:chiylown_func_dict["UPFILE"]["python"]="UPFILE_python"
    let g:chiylown_func_dict["CSTAG"]["python"]="CSTAG_python"
    let g:chiylown_func_dict["ASTYLE"]["python"]="ASTYLE_python"
endfunction

