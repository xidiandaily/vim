function! UPFILE_lua()
    call TarModifyFile()
endfunction

function CSTAG_lua()
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
            let choice=2
            let s:lgamexml=getenv('VIMPROJ').'\\myctags-optlib\\lgamexml.ctags'
            silent! execute "!ctags.exe -f lgamelua.tags -R --languages=C,+C++,+CMake,+Automake,+Autoconf,+Lua --c++-kinds=+p --fields=+iaS --extras=+q ."
            silent! execute "!ctags.exe -f lgamexml.tags -R --options=".s:lgamexml." --languages=+lgamexml --c++-kinds=+p --fields=+iaS --extras=+q ."
            set tags+=lgamelua.tags
            set tags+=lgamexml.tags
            silent execute ':!'.getenv('VIMPROJ').'/mytag_helper/mytag_helper.exe -r -t '.getcwd().'/lgamelua.tags'
            silent execute ':!'.getenv('VIMPROJ').'/mytag_helper/mytag_helper.exe -r -t '.getcwd().'/lgamexml.tags'
            call ctrlp#mycmd#LGameCtrlPTag()
        else
            silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        endif
    endif

    if(executable('gtags') && has("cscope") )
        let s:lgameluacfg=getenv('VIMPROJ').'\\mygtags\\lgamelua.conf'
        silent! execute "!gtags --gtagsconf=".s:lgameluacfg
        silent! execute ":GtagsCscope"
    endif
endfunction

function ASTYLE_lua()
    echohl WarningMsg | echo "unsupport astyle for lua" | echohl None
endfunction

function! InitLua()
    set tags+=$VIMPROJ/vimlib/lua-5.1.5/tags
    if(g:iswindows==1)
        set tags+=lgamelua.tags
        set tags+=lgamexml.tags
    endif
    let g:chiylown_func_dict["UPFILE"]["lua"]="UPFILE_lua"
    let g:chiylown_func_dict["CSTAG"]["lua"]="CSTAG_lua"
    let g:chiylown_func_dict["ASTYLE"]["lua"]="ASTYLE_lua"
    silent! execute ":GtagsCscope"
endfunction
