"函数

function CTags_pgamesvr_xml()
    let s:pgamexml=getenv('VIMPROJ').'\\myctags-optlib\\pgamexml.ctags'
    let s:pgamexmlfilelist=getenv('VIMPROJ').'\\myctags-optlib\\filelist.pgamexml'
    let l:mycmd="!ctags.exe -L ".s:pgamexmlfilelist." -f pgamexml.tags --options=".s:pgamexml." --languages=+pgamexml --c++-kinds=+p --fields=+iaS --extras=+q"
    echom l:mycmd
    silent! execute l:mycmd
    silent execute ':!'.getenv('VIMPROJ').'/mytag_helper/mytag_helper.exe -r -t '.getcwd().'/pgamexml.tags'
endfunction

function CTags_pgamesvr_lua()
    let s:pgamelua=getenv('VIMPROJ').'\\myctags-optlib\\pgamelua.ctags'
    let l:mycmd="!ctags.exe -R -f pgamelua.tags --options=".s:pgamelua." --languages=+pgamelua"
    echom l:mycmd
    silent! execute l:mycmd
    silent execute ':!'.getenv('VIMPROJ').'/mytag_helper/mytag_helper.exe -r -t '.getcwd().'/pgamelua.tags'
endfunction

function CSTAG_pgamesvr()
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

    if filereadable("tags")
        "清理旧项目的tags，防止有冲突
        call delete('tags')
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
        if(g:iswindows==1)
            let choice=3

            if !filereadable('pgamesvrc.tags') && !filereadable('pgamelua.tags')
                let choice = 1
            else
                let choice=confirm("choice tags file type?","&ALL\n&C\n&Lua\n&Xml",3)
            endif

            if choice == 1 || choice == 2
                silent! execute "!ctags.exe -f pgamesvrc.tags -R --languages=C,+C++,+CMake,+Automake,+Autoconf --c++-kinds=+p --fields=+iaS --extras=+q ."
                silent execute ':!'.getenv('VIMPROJ').'/mytag_helper/mytag_helper.exe -r -t '.getcwd().'/pgamesvrc.tags'
            endif

            if choice == 1 || choice == 3
                call CTags_pgamesvr_lua()
            endif

            if choice == 1 || choice == 4
                call CTags_pgamesvr_xml()
            endif

            call ctrlp#mycmd#PGameCtrlPTag()
            set tags+=pgamelua.ctrlptags,pgamexml.ctrlptags,pgamesvrc.ctrlptags
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

function ASTYLE_pgamesvr()
    let g:astyle_file=expand("%")
    silent execute "!astyle -A1M40Sjk1n --mode=c ".getcwd()."/".g:astyle_file
endfunction

function! InitPGameSvr()
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
        :set tags+=pgamelua.ctrlptags,pgamexml.ctrlptags,pgamesvrc.ctrlptags
    else
        :set tags+=$VIMPROJ/vimlib/cppstl/tags,$VIMPROJ/vimlib/linux/tags.linux,$VIMPROJ/vimlib/zeromq-3.2.5/tags.linux
    endif
    
    :set path+=$VIMPROJ/vimlib/cppstl/cpp_src,$VIMPROJ/vimlib/linux/include,$VIMPROJ/vimlib/linux/include/sys/,$VIMPROJ/vimlib/zeromq-3.2.5/include
    :set path+=bin/luascript
    let g:chiylown_func_dict["CSTAG"]["pgamesvr"]="CSTAG_pgamesvr"
    let g:chiylown_func_dict["ASTYLE"]["pgamesvr"]="ASTYLE_pgamesvr"
endfunction

