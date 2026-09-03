"==============================================================================
" Description: global plugin for lawrencechi
" Author:      lawrencechi <codeforfuture <at> 126.com>
" Last Change: 2023.08.29
" License:     This file is placed in the public domain.
" Version:     1.0.0
"==============================================================================
"

function Init_F11()
    let l:my_filetype=&filetype
    echo l:my_filetype
    if('markdown'==l:my_filetype)
        :PrevimOpen
    else
        echo "empty function"
    endif
endfunction

amenu &chiyl.Jedi环境配置.-SEP2-                              :
if g:iswindows==1
    amenu &chiyl.Jedi环境配置.Py39  :let g:jedi#environment_path = "E:\\env-python39" <CR>
    amenu &chiyl.Jedi环境配置.Py27  :let g:jedi#environment_path = "E:\\env-python27" <CR>
    amenu &chiyl.Jedi环境配置.Py310 :let g:jedi#environment_path = "E:\\env-python310" <CR>
endif
amenu &chiyl.Jedi环境配置.查看当前配置      :echo g:jedi#environment_path<CR>
amenu &chiyl.Jedi环境配置.说明      :echo "\n设置jedi的python运行环境\n配置其实是设置 g:jedi#environment_path\n说明:help g:jedi#environment_path\n配置地址:$VIMPROJ\vimrc\option.vim\n"<CR>
amenu &chiyl.-SEP3-                              :
amenu &chiyl.About                               :echo "\ngVIM-menu for chiyl.vim (https://github.com/xidiandaily/vim.git)\nby LawrenceChi\ncodeforfuture (at) 126.com\n"<CR>
amenu &chiyl.test                               :call Init_SSHConfig()<Cr>


map <F11> :call Init_F11()<CR>
