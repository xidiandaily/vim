"³õÊ¼»¯Mainº¯Êý
source  $VIMPROJ/Tool/main.vim

function! InitWorkSpace()
	normal gg
	normal /Logic
	normal o
	normal /GameServer.cpp
	normal o
	"normal /GameTable-gb.cpp
	"normal o
	let g:SSHSendDir="/"
	let g:SSHSendRemot="LawrenceChi@192.168.100.144:/usr/server/Mahjong.gb/Borrow/Redis2Log/"
	"let g:SSHSendRemot="chiyl@192.168.1.108:/usr/server/Mahjong.gb/Complie/Mahjong/"
	:set rnu
endfunction

call Main("G:/boyaa/Redis2Log")
