all:

launch_exe:
	pyinstaller --onefile --icon=icon.ico launch.py
	cp dist/launch.exe ./

conemu_exe:
	pyinstaller --onefile --icon=icon.ico run_base_conemu.py
	cp dist/run_base_conemu.exe ./

clean:
	rm -rf build
	rm -rf dist
	rm -f *.spec

