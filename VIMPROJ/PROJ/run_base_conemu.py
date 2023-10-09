import subprocess
import configparser

config=configparser.ConfigParser()
config.read('config.ini')

conemu_path = config.get('global','conEmu_path')  # 替换为实际的 ConEmu.exe 路径
your_script_exe_path = config.get('global','vimproj_path')  # 替换为实际的 your_script.exe 路径
subprocess.run([conemu_path,"/single","/run", f"{your_script_exe_path} -new_console:n"])
