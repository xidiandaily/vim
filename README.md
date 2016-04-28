# vim
===

vim config, all file in one project
------------------------------------
请保证路径中没有空格

我的vim配置，所需要的文件全部在这个项目中，包括一些自己编写的，常用的脚本。

## 常用功能
- normal 模式下，用``NT`` 在窗口右侧打开资源管理器[NERD_tree](http://www.vim.org/scripts/script.php?script_id=1658)
- normal 模式下，用`Tl` 在窗口左侧打开函数列表[taglist](http://www.vim.org/scripts/script.php?script_id=273)
- input 模式下, 用``<Ctr>+X+O`` 自动补全（'omnifunc'补全）（**推荐**）
- input 模式下, 用``<Tab>`` 自动补全（'superTab'补全）
- input 模式下, 用``<Ctr>+X+N`` 自动补全（查询本文件关键字）
- input 模式下, 用``<Tab>`` 自动补全（tab补全）（遍历所有头文件，较慢）
- normal 模式下, 用``<Ctr>+F8`` 将语言切换至 cp936 
- normal 模式下, 用``<Ctr>+F9`` 将语言切换至 utf-8(**默认语言**） 
- 选择模式下, 用``ga``进行对齐[vim-easy-align](http://www.vim.org/scripts/script.php?script_id=4520)
- 新增插件放到 vimfiles/bundle/ 下就行 [pathogen](http://www.vim.org/scripts/script.php?script_id=2332) 
- 启动时候能够根据项目类型(cpp/php）选择性加载库文件
    - cpp tags:glibc/stl/linux kernel head file/zeromq head file/
- normal 模式下, 用``F5`` 设置当前项目类型(cpp/php)
- normal 模式下, 用``F12``更新当前的 tags、cscope文件
- 创建自定义项目
    1. 打开 VIMPROJ：win下面使用todo.bat 打开 cmd，调用 ``buildproject.bat projectname`` 就会创建空白的项目模板；mac/linux 采用 ``buildprojet.sh projectname`` 达到同样目标;
    2. 按照空白项目模板修改项目文件 projectname.vim;
    3. 执行 VIM/PROJ/projectname.bat(sh)，打开创建的项目

## 扩展功能,(需要安装 [Cygwin](https://www.cygwin.com/])):
- 启动项目时候打开最近修改的文件
- normal 模式下, 用``F7`` 自动上传 **全部** or **上次上传之后修改过** 文件

## 配置方法：
1. 下载本工程并覆盖在 vim根目录(文件路径如下）**（vim根目录不能含有空格)**
```
/Vim/
|+ExtTool/
|+Font/
|+vim73/
|+vimfiles/
|+VIMPROJ/
|-_vimrc
`-README.md
```

2. 设置 VIMPROJ 系统变量为 [your dir]/Vim/VIMPROJ 
3. 将 [your dir]/Vim/vim73 添加至系统变量
4. 将 ``/usr/local/bin;/usr/bin;`` 添加至系统变量 $PATH 的头部
6. ctags 和 cscope 在 ExtTool/ 中， 解压之后，将其所在的路径放到系统PATH中就可以了。（不要求在 vim 中，最好路径名称是英文）
7. win系统：启动gvim，命令模式输入(注意包含第一个冒号） ``:e $home/_vimrc``(修改``_vimrc``文件),输入(注意不包含冒号）:``source $VIMPROJ/vimrc/_vimrc``,保存退出
8. Mac系统：启动gvim，命令模式输入(注意包含第一个冒号） ``:e $home/.vimrc``(修改``.vimrc``文件),输入(注意不包含冒号）:``source $VIMPROJ/vimrc/_vimrc``,保存退出
9. (非必须)字体可以在 Font/ 中，自己安装到系统Font就可以。
10. (扩展功能)安装 cygwin， 安装 ssh 工具;
11. (扩展功能)设置 ssh通讯,参考: [Linux(Centos)配置OpenSSH无密码登陆](http://sjsky.iteye.com/blog/1123184)
12. (扩展功能) 设置系统变量 CYGWINPATH,值为 cygwin 的 mintty.exe 坐在的路径;
13. (扩展功能)sh的启动方式默认设成 cygwin的 mintty.exe;

## 下面是常见问题及解决办法：
1. 启动后提示找不gvim.exe： 请查看是否将 vim/vim73 添加到系统目录
2. 启动后无法打开最近修改的文件，报一串错误提示: 请查看 ``/usr/local/bin;/usr/bin;``是否在 $PATH 头部
3. stl库自动补全功能不能用，例如 ``inserter()`` 使用 ``<Ctr>+X+O``并没有提示:  请添加 ``std::`` 或者 ``using namespace std;``,一般是因为类没有添加导致的。~~已经将 ``std,_GLIBCXX_STD``配置到默认类中，但是不知为何不起作用~~(原因是在InitCPP设置``OmniCpp_DefaultNamespaces`` 没加``g:``前缀，导致设置失败。

Enjoy~

## 下面是扩展功能说明
#### 项目(Proj)
当前支持两种类型的项目``cpp``,``php``。如果写好项目配置文件，通过批处理脚本启动，则能够：
- 启动时候自动打开项目中最近修改文件
- 根据项目类型``cpp``,``php`` 使用最合适的函数匹配功能，自动补全功能，自动上传功能

###### 配置项目文件步骤(win）
1. 进入``$VIMPROJ\PROJ`` 文件夹，可以看到下面的文件：
```
$VIMPROJ/VIMPROJ/
        ├── buildprojet.bat
        ├── buildprojet.sh
        ├── PROJ
        │   ├── buildprojet.sh
        │   └── template.bat.bak
        ├── template.vim                   //项目模板文件
        ├── todo.bat                          //快速启动cmd
```

2.双击 ``todo.bat`` 启动window的 cmd。 在在命令行下输入 ``buildprojet.bat [projectname]``，例如创建项目 ``foo``。那就输入``buildprojet.bat foo``，回车后会自动创建项目描述文件并进入编辑模式。此时，文件变动为：
```
$VIMPROJ/VIMPROJ/
    ├── template.vim          //项目配置模板
    ├── todo.bat               
    ├── buildprojet.bat      
    ├── foo.vim               //新建的foo项目描述文件
    ├── PROJ
    │   ├── buildprojet.sh
    │   ├── BY_Hkqp.bat
    │   ├── foo.bat           //新建的foo项目启动脚本

```
3.项目文件的说明
```
"这个文件试图使得创建 VIM 项目更加简单方便。
"①常用的全局设置已经在 _vimrc中设置了
"②常用的CPP设置在InitCPP.vim中设置
"③还有一些每个项目私有的设置，比如说项目的根目录，启动时需要打开的文件，一键上传的目录配置等
"③‘项目的私有设置在这个文件进行设置。
"

"初始化Main函数
source  $VIMPROJ/Tool/main.vim
function! InitWorkSpace()
    "let g:proj_type="cpp"                    //创建CPP项目，则将此前面的注释 " 去掉
    "let g:proj_type="pkm"                   //非公共项目
    "let g:proj_type="php"                    //创建php项目，则将此前面注释 " 去掉

	let g:SSHRemoteBaseDir="/usr/server/Mahjong.gb/Borrow/Compile"        //F7 自动上传远程路径
	let g:SSHUSER="lawrenceChi@192.168.200.144"       //F7 自动上传远程服务器用户名及IP
	let g:SSHPORT=3600                                                 //F7   自动上传端口
endfunction

"Main函数中的参数是项目所在的根目录
call Main("E:/E_temp/foo")                                                   //项目所在路径，注意"/"分隔符号

```

4.配置好之后，下次启动，直接使用 foo.bat 就可以自动打开项目。

5.可以通过这个文章 [将PROJ文件夹放置在工具栏上](http://jingyan.baidu.com/article/91f5db1b3fcb981c7f05e3c9.html)，方便使用。

6.项目模板文件是``template.vim``,你可以把你常用配置写到里面，这样以后再创建新项目，会更方便。

###### 无项目配置文件时使用项目功能步骤
1. 打开gvim，输入项目路径。例如输入：``:cd E:/E_temp/foo``, 将``E:/E_temp/foo``设成当前工作目录;
2. normal模式下，用``NT`` 在窗口右侧打开资源管理器[NERD_tree](http://www.vim.org/scripts/script.php?script_id=1658)
3. normal模式下，用`Tl` 在窗口左侧打开函数列表[taglist](http://www.vim.org/scripts/script.php?script_id=273)
4. normal模式下，用``F5`` ，在弹出窗口选择 项目类型。
5. normal 模式下, 用``F12``更新当前的 tags、cscope文件
6. 注意这种方式下自动上传功能不可用;

###### 常见问题及解决办法：
1. 点击项目启动脚本``foo.bat``，启动失败，请先看看配置文件中的项目路径中的``"\"``是不是改成了 ``"/"``.

#### 自动上传功能
TODO:将来可能讲自动上传模块独立出来，现在还没做~


Enjoy~




