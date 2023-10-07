all:

launch_exe:
	pyinstaller --onefile launch.py
	cp dist/launch.exe ./

conemu_exe:
	pyinstaller --onefile run_base_conemu.py
	cp dist/run_base_conemu.exe ./

clean:
	rm -rf build
	rm -rf dist
	rm -f *.spec

