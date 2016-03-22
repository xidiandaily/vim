let s:datapath='C:/Vim/VIMPROJ/Tool/data/'

function Create_SSHConfig()
    echo "hello wolrd"<Cr>
    :echo "\n分别要求填写:1. 远程服务器IP;\n 2.访问用户名;\n 3.访问端口;\n 4.远程文件夹路径;\n 调用实例: ssh -p 端口 用户名@服务器IP或域名:远程文件夹路径/ \n"<Cr>
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
    :amenu  &chiyl.上传文件配置.-SEP1-                  :
    :nmenu  &chiyl.上传文件配置.创建                    :call Create_SSHConfig()
    :amenu  &chiyl.上传文件配置.说明                    :echo "通过ssh上传文件到远程服务器，可以分为全部上传，只上传最新更新两种模式，这里选择配置好的远程服务器ip、端口。\n配置文件放置在$VIMPROJ/Tool/data/下，文件名是:*.sshdconfig\n 配置文件放到文件夹下会自动加载" <Cr>

    if (g:iswindows==1)
        let l:projpath=substitute(substitute(getcwd(),'\','_','g'),':','_','g')
    else
        let l:projpath=substitute(getcwd(),'/','_','g')
    endif
    let l:projconfig=s:datapath."/".l:projpath.".dat"
    if filereadable(l:projconfig)
    endif
endfunction

call Init_SSHConfig()
:amenu &chiyl.-SEP2-                              :
:amenu &chiyl.About                               :echo "\ngVIM-menu for chiyl.vim (https://github.com/xidiandaily/vim.git)\nby LawrenceChi\ncodeforfuture (at) 126.com\n"<Cr>
:amenu &chiyl.test                               :call Init_SSHConfig()

