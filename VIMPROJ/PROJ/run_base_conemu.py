import subprocess

conemu_path = "C:\\Program Files\\ConEmu\\ConEmu64.exe"  # 替换为实际的 ConEmu.exe 路径
your_script_exe_path = "G:\\CodeBase.github\\vim\\VIMPROJ\\PROJ\\launch.exe"  # 替换为实际的 your_script.exe 路径
subprocess.run([conemu_path,"/single","/run", f"{your_script_exe_path} -new_console:n"])
