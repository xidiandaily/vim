# vim
===

vim config, all file in one project
------------------------------------
请保证路径中没有空格

我的vim配置，所需要的文件全部在这个项目中，包括一些自己编写的，常用的脚本。

## 常用功能
- normal 模式下，用``NT`` 在窗口右侧打开资源管理器[NERD_tree](http://www.vim.org/scripts/script.php?script_id=1658)
- normal 模式下，用`Tl` 在窗口左侧打开函数列表[taglist](http://www.vim.org/scripts/script.php?script_id=273)
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
7. (非必须)字体可以在 Font/ 中，自己安装到系统Font就可以。
8. (扩展功能)安装 cygwin， 安装 ssh 工具;
9. (扩展功能)设置 ssh通讯,参考: [Linux(Centos)配置OpenSSH无密码登陆](http://sjsky.iteye.com/blog/1123184)
10. (扩展功能) 设置系统变量 CYGWINPATH,值为 cygwin 的 mintty.exe 坐在的路径;
11. (扩展功能)sh的启动方式默认设成 cygwin的 mintty.exe;

## 下面是常见问题及解决办法：
1. 启动后提示找不gvim.exe： 请查看是否将 vim/vim73 添加到系统目录
2. 启动后无法打开最近修改的文件，报一串错误提示: 请查看 ``/usr/local/bin;/usr/bin;``是否在 $PATH 头部

Enjoy~

