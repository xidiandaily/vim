function! InitCPP()
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
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set completeopt=menuone,menu,longest
    :set tags+=$VIMPROJ/vimlib/tags,$VIMPROJ/vimlib/linux/tags
    :set path+=$VIMPROJ/vimlib/cpp_src,$VIMPROJ/vimlib/linux/include,$VIMPROJ/vimlib/linux/include/sys/
endfunction
