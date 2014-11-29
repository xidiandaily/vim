"函数
function UPFILE_pkm()
    let choice=confirm("Build&Upload file?", "&CurentFile\n&Cancel",1)
    if (choice==1)
        let filename=expand("%:t")
        let curdir=getcwd()
        let cygwin_proj=$CYGWINPATH."/mintty.exe"
        let cmd= "! ".cygwin_proj." ".curdir."/build_onefile.sh ".filename
        execute cmd
    endif
endfunction

function! InitPkm()
    let g:chiylown_func_dict["UPFILE"]["pkm"]="UPFILE_pkm"
endfunction
