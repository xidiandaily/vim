"³õÊ¼»¯Mainº¯Êý
source  $VIMPROJ/Tool/main.vim

function! InitWorkSpace()
	normal /Game
	normal o
	normal /MahjongGB
	normal o
	normal /GameTable-gb.cpp
	normal o
	:set rnu
    ":e makefile
	let g:SSHSendDir="/"
	"let g:SSHSendRemote="LawrenceChi@192.168.100.144:/usr/server/Mahjong.gb/Complie/Mahjong/"
	"let g:SSHPortRemote=3600
	let g:SSHIPRemote="chiyl@192.168.1.108:/usr/server/Mahjong.gb/Complie/Mahjong/"
	let g:SSHPortRemote=22
endfunction

call Main("G:/boyaa/MahjongTwServer")
