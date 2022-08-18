"º¯Êý
function UPFILE_python()
    call TarModifyFile()
endfunction

function CSTAG_python()
    echohl WarningMsg | echo "Python not support generate cstag!" | echohl None
endfunction

function ASTYLE_python()
    if(g:iswindows==1)
        let s:lgamexml=getenv('VIMPROJ').'\\myctags-optlib\\lgamexml.ctags'
        if filereadable(s:lgamexml)
            silent! execute "!ctags.exe -R --languages=-json --languages=-JavaScript --languages=-CSS --languages=-Markdown --languages=-SQL --options=".s:lgamexml." --c++-kinds=+p --fields=+iaS --extras=+q ."
        else
            silent! execute "!ctags.exe -R --c++-kinds=+p --fields=+iaS --extras=+q ."
        endif
    else
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
endfunction

function! InitPython()
    let g:chiylown_func_dict["UPFILE"]["python"]="UPFILE_python"
    let g:chiylown_func_dict["CSTAG"]["python"]="CSTAG_python"
    let g:chiylown_func_dict["ASTYLE"]["python"]="ASTYLE_python"
endfunction

