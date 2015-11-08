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
    "let g:proj_type="cpp"
    "let g:proj_type="pkm"
    "let g:proj_type="php"

	let g:SSHSendDir="/"
	let g:SSHUSER="chiyl@192.168.199.1"
	let g:SSHPORT=3600
	let g:SSHRemoteDir="/usr/server/EventMonitor/"

	"let g:SSHSendDir="/"
	"let g:SSHUSER="lawrenceChi@192.168.200.1"
	"let g:SSHPORT=3600
	"let g:SSHRemoteDir="/usr/server/EventMonitor/"
endfunction

"Main函数中的参数是项目所在的根目录
call Main("$YourProject_ROOTDIR/")

