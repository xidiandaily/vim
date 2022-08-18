"函数
function UPFILE_cpp()
    call TarModifyFile()
endfunction

function CSTAG_cpp()
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
        "silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        if(g:iswindows==1)
            let s:lgamexml=getenv('VIMPROJ').'\\myctags-optlib\\lgamexml.ctags'
            if filereadable(s:lgamexml)
                execute "!ctags.exe -R --languages=-json --languages=-JavaScript --languages=-CSS --languages=-Markdown --languages=-SQL --options=".s:lgamexml." --c++-kinds=+p --fields=+iaS --extras=+q ."
            else
                silent! execute "!ctags.exe -R --languages=-json --languages=-JavaScript --languages=-CSS --languages=-Markdown --languages=-SQL --c++-kinds=+p --fields=+iaS --extras=+q ."
            endif
        else
            silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        endif
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            let fileter=" -name '*.c' "
            let fileter.="-o -name '*.cpp' "
            let fileter.="-o -name '*.h' "
            let fileter.="-o -name '*.hpp' "
            let fileter.="-o -name '*.java' "
            let fileter.="-o -name '*.cs' "
            let fileter.="-o -name '*.hxx' "
            let fileter.="-o -name '*.cxx' "
            let fileter.="-o -name '*.cc' "
            silent! execute "!find . ".fileter." > cscope.files"
        else
            let fileter="*.c,"
            let fileter.="*.cpp,"
            let fileter.="*.h,"
            let fileter.="*.hpp,"
            let fileter.="*.java,"
            let fileter.="*.cs,"
            let fileter.="*.hxx,"
            let fileter.="*.cxx,"
            let fileter.="*.cc,"
            silent! execute "!dir /s/b ".fileter." | findstr /v \"cpp~\" >> cscope.files"
        endif
        silent! execute "!cscope -b"
        silent! execute "normal :"
        if filereadable("cscope.out")
            silent! execute "cs add cscope.out"
        endif
    endif
endfunction

function ASTYLE_cpp()
    let g:astyle_file=expand("%")
    silent execute "!astyle -A1M40Sjk1n --mode=c ".getcwd()."/".g:astyle_file
endfunction

function! InitCPP()
    " OmniCppComplete
    let g:OmniCpp_NamespaceSearch = 1 " 1 = search namespaces in the current buffer
    let g:OmniCpp_GlobalScopeSearch = 1 "enabled Global scope search toggle
    let g:OmniCpp_ShowAccess = 1  "enable to show the access information ('+', '#', '-') in the popup menu.
    let g:OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
    let g:OmniCpp_MayCompleteDot = 0 " autocomplete after .
    let g:OmniCpp_MayCompleteArrow = 0 " autocomplete after ->
    let g:OmniCpp_MayCompleteScope = 1 " autocomplete after ::
    let g:OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
    " automatically open and close the popup menu / preview window
    "au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    "set completeopt=menuone,menu,longest,preview
    "预览窗口不会自动关闭 by LawrenceChi
    set completeopt=menuone,menu,longest,preview
    if(g:iswindows==1)
        :set tags+=$VIMPROJ/vimlib/cppstl/tags,$VIMPROJ/vimlib/linux/tags,$VIMPROJ/vimlib/zeromq-3.2.5/tags
    else
        :set tags+=$VIMPROJ/vimlib/cppstl/tags,$VIMPROJ/vimlib/linux/tags.linux,$VIMPROJ/vimlib/zeromq-3.2.5/tags.linux
    endif
    
    :set path+=$VIMPROJ/vimlib/cppstl/cpp_src,$VIMPROJ/vimlib/linux/include,$VIMPROJ/vimlib/linux/include/sys/,$VIMPROJ/vimlib/zeromq-3.2.5/include
    let g:chiylown_func_dict["UPFILE"]["cpp"]="UPFILE_cpp"
    let g:chiylown_func_dict["CSTAG"]["cpp"]="CSTAG_cpp"
    let g:chiylown_func_dict["ASTYLE"]["cpp"]="ASTYLE_cpp"
endfunction

