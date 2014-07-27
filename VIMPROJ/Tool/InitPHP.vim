"函数
function UPFILE_php()
    let vim_proj=$VIMPROJ."/Tool"
    let cygwin_proj=$CYGWINPATH."/mintty.exe"
    let filelist_cmd= "! ".cygwin_proj." ".vim_proj."/SSHFileup_phpfilelist.sh"." ".g:SSHSendDir
    execute filelist_cmd

    if (-1!=getftime("uploadfile.txt"))
        let str_choice=""
        for ff in readfile("uploadfile.txt")
            let str_choice=str_choice."\n".ff
        endfor

        if (str_choice=="")
            let str_choice="file not found"
        endif

        let choice=confirm(str_choice,"&Yes\n&Cancel",1)
        if (choice==1)
            let cmd= "! ".cygwin_proj." ".vim_proj."/SSHFileup_php_upload.sh"." ".g:SSHSendDir." ".g:SSHUSER." ".g:SSHPORT." ".g:SSHRemoteDir." ".choice
            execute cmd
        endif
    endif
endfunction

function CSTAG_php()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --PHP-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.php,*.js >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

"function ASTYLE_cpp()
"    let g:astyle_file=expand("%")
"    silent execute "!astyle -A1M40Sjk1n --mode=c ".getcwd()."/".g:astyle_file
"endfunction

function! InitPHP()
    " OmniCppComplete
    let OmniCpp_NamespaceSearch = 1
    let OmniCpp_GlobalScopeSearch = 1
    let OmniCpp_ShowAccess = 1
    let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
    let OmniCpp_MayCompleteDot = 1 " autocomplete after .
    let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
    let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
    let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
    " automatically open and close the popup menu / preview window
    "au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    "set completeopt=menuone,menu,longest,preview
    "预览窗口不会自动关闭 by LawrenceChi
    set completeopt=menuone,menu,longest,preview
    :set tags+=$VIMPROJ/vimlib/tags,$VIMPROJ/vimlib/linux/tags,$VIMPROJ/vimlib/unix_network_programming/tags
    :set path+=$VIMPROJ/vimlib/cpp_src,$VIMPROJ/vimlib/linux/include,$VIMPROJ/vimlib/linux/include/sys/,$VIMPROJ/vimlib/unix_network_programming/
    let g:chiylown_func_dict["UPFILE"]["php"]="UPFILE_php"
    let g:chiylown_func_dict["CSTAG"]["php"]="CSTAG_php"
    "let g:chiylown_func_dict["ASTYLE"]["cpp"]="ASTYLE_cpp"
endfunction
