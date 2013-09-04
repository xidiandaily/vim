"这个文件试图使得创建 VIM 项目更加简单方便。
"①常用的全局设置已经在 _vimrc中设置了
"②常用的CPP设置在InitCPP.vim中设置
"③还有一些每个项目私有的设置，比如说项目的根目录，启动时需要打开的文件，一键上传的目录配置等
"③‘项目的私有设置在这个文件进行设置。
"

"初始化Main函数
source  $VIMPROJ/Tool/main.vim

function! InitWorkSpace()
	normal /Game
	normal o
	normal /MahjongGB
	normal o
	normal /GameTable-gb.cpp
	normal o
	:set rnu

	let g:SSHSendDir="/"
	let g:SSHIPRemote="chiyl@192.168.1.108:/usr/server/Mahjong.gb/Complie/Mahjong/"
	let g:SSHPortRemote=22
endfunction

"Main函数中的参数是项目所在的根目录
call Main("$YourProject_ROOTDIR/")

