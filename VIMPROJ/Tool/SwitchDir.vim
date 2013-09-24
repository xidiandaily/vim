function! SwitchDir(filename)
    echo a:filename
    if !isdirectory(a:filename)
        if exists("*mkdir")
            call mkdir(a:filename,"p",0755)
        endif
    endif
    execute ":cd ".a:filename
    silent! execute "! C:/cygwin/bin/mintty.exe D:/Vim/VIMPROJ/Tool/get_dirlist.sh ~vimcurpath.tmp"
    let addpath=system("cat ~vimcurpath.tmp")
    execute addpath
endfunction


