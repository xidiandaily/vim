"函数
function UPFILE_vim()
    echohl WarningMsg | echo "vim not support upfile" | echohl None
endfunction

function CSTAG_vim()
    let dir = getcwd()
    if(executable('ctags'))
        silent! execute "!ctags -f vim.tags -R --languages=Vim --c++-kinds=+p --fields=+iaS  ."
    endif
endfunction

function ASTYLE_vim()
    echohl WarningMsg | echo "vim not support astyle" | echohl None
endfunction

function! InitVim()
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
    :set tags=vim.tags,./tags,C:\Vim\vimfiles\bundle\vimcdoc\doc\tags-cn
    set completeopt=menuone,menu,longest,preview
    ":set path+=$VIMPROJ/vimlib/cppstl/cpp_src,$VIMPROJ/vimlib/linux/include,$VIMPROJ/vimlib/linux/include/sys/,$VIMPROJ/vimlib/zeromq-3.2.5/include
    let g:chiylown_func_dict["UPFILE"]["vim"]="UPFILE_vim"
    let g:chiylown_func_dict["CSTAG"]["vim"]="CSTAG_vim"
    let g:chiylown_func_dict["ASTYLE"]["vim"]="ASTYLE_vim"
endfunction

