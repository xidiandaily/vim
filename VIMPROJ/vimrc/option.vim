
function Create_SSHConfig()
    let conf={"ip":"null","port":"3600","username":"null","remotedir":"null"}
    let ask=["0. 远程服务器IP:","1. 服务器登陆名:","2. 服务器登陆端口:","3. 服务器存放路径:","5. 完成配置"]
    let answer=["","","","",""]
    while 1
        echo "\n 参数使用:ssh -p 端口 用户名@服务器IP或域名:远程文件夹路径/ \n"
        let tip=["选择输入项:"]
        for i in [0,1,2,3,4] 
            let tip= tip+[ask[i].answer['ip']]
        endfor
        let idx = inputlist(tip)
        if idx ==0 
            break
        endif
        let cnf[cnfidx[idx]]=input(title[idx],cnf[cnfidx[idx]])
    endwhile

endfunction

function Init_SSHConfig()
    let l:filelist=split(globpath(s:datapath,'*.sshconfig'),'\n')
    for l:i in l:filelist
        if (g:iswindows==1)
            let l:tmp=split(l:i,'\')
        else
            let l:tmp=split(l:i,'/')
        endif
        let l:item=":amenu 90 &chiyl.上传文件配置.".substitute(l:tmp[-1],'\.','_','g')."   :echo 'helloworld' "
        exec l:item
    endfor
    amenu  &chiyl.上传文件配置.-SEP1-                  :
    nmenu  &chiyl.上传文件配置.创建                    :call Create_SSHConfig()<Cr>
    amenu  &chiyl.上传文件配置.说明                    :echo "通过ssh上传文件到远程服务器，可以分为全部上传，只上传最新更新两种模式，这里选择配置好的远程服务器ip、端口。\n配置文件放置在$VIMPROJ/Tool/data/下，文件名是:*.sshdconfig\n 配置文件放到文件夹下会自动加载" <Cr>

    if (g:iswindows==1)
        let l:projpath=substitute(substitute(getcwd(),'\','_','g'),':','_','g')
    else
        let l:projpath=substitute(getcwd(),'/','_','g')
    endif
    let l:projconfig=s:datapath."/".l:projpath.".dat"
    if filereadable(l:projconfig)
    endif
endfunction

function Init_PyenvConfig()

    let l:filelist=split(globpath(s:datapath,'*.sshconfig'),'\n')
    for l:i in l:filelist
        if (g:iswindows==1)
            let l:tmp=split(l:i,'\')
        else
            let l:tmp=split(l:i,'/')
        endif
        let l:item=":amenu 90 &chiyl.上传文件配置.".substitute(l:tmp[-1],'\.','_','g')."   :echo 'helloworld' "
        exec l:item
    endfor
    amenu  &chiyl.上传文件配置.-SEP1-                  :
    nmenu  &chiyl.上传文件配置.创建                    :call Create_SSHConfig()<Cr>
    amenu  &chiyl.上传文件配置.说明                    :echo "通过ssh上传文件到远程服务器，可以分为全部上传，只上传最新更新两种模式，这里选择配置好的远程服务器ip、端口。\n配置文件放置在$VIMPROJ/Tool/data/下，文件名是:*.sshdconfig\n 配置文件放到文件夹下会自动加载" <Cr>

    if (g:iswindows==1)
        let l:projpath=substitute(substitute(getcwd(),'\','_','g'),':','_','g')
    else
        let l:projpath=substitute(getcwd(),'/','_','g')
    endif
    let l:projconfig=s:datapath."/".l:projpath.".dat"
    if filereadable(l:projconfig)
    endif
endfunction

function Init_F11()
    let l:my_filetype=&filetype
    echo l:my_filetype
    if('markdown'==l:my_filetype)
        :PrevimOpen
    else
        echo "empty function"
    endif
endfunction


let s:datapath='C:/Vim/VIMPROJ/Tool/data/'
call Init_SSHConfig()
amenu &chiyl.Jedi环境配置.-SEP2-                              :
if g:iswindows==1
    amenu &chiyl.Jedi环境配置.Py39  :let g:jedi#environment_path = "E:\\env-python39" <CR>
    amenu &chiyl.Jedi环境配置.Py27  :let g:jedi#environment_path = "E:\\env-python27" <CR>
    amenu &chiyl.Jedi环境配置.Py310 :let g:jedi#environment_path = "E:\\env-python310" <CR>
endif
amenu &chiyl.Jedi环境配置.查看当前配置      :echo g:jedi#environment_path<CR>
amenu &chiyl.Jedi环境配置.说明      :echo "\n设置jedi的python运行环境\n配置其实是设置 g:jedi#environment_path\n说明:help g:jedi#environment_path\n配置地址:$VIMPROJ\vimrc\option.vim\n"<CR>
call Init_PyenvConfig()
amenu &chiyl.-SEP3-                              :
amenu &chiyl.About                               :echo "\ngVIM-menu for chiyl.vim (https://github.com/xidiandaily/vim.git)\nby LawrenceChi\ncodeforfuture (at) 126.com\n"<CR>
amenu &chiyl.test                               :call Init_SSHConfig()<Cr>


map <F11> :call Init_F11()<CR>
