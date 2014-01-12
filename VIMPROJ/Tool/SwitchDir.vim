function! SwitchDir(filename)
    echo a:filename
    if !isdirectory(a:filename)
        if exists("*mkdir")
            call mkdir(a:filename,"p",0755)
        endif
    endif
    execute ":cd ".a:filename
    let vim_proj=$VIMPROJ
    let cygwin_proj=$CYGWINPATH
    let cmd="! ".cygwin_proj."/mintty.exe  ".vim_proj."/Tool/get_dirlist.sh ~vimcurpath.tmp"
    silent! execute cmd
    let addpath=system("cat ~vimcurpath.tmp")
    execute addpath
endfunction


