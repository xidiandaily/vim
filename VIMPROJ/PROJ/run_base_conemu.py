import subprocess
import configparser
import chardet

config_file='config.ini'

with open(config_file,'rb') as f:
    raw_data=f.read()
    result = chardet.detect(raw_data)
    encoding=result['encoding']

config=configparser.ConfigParser()
with open(config_file,'r',encoding=encoding)  as f:
    config.read_file(f)

conemu_path = config.get('global','conEmu_path')  # 替换为实际的 ConEmu.exe 路径
your_script_exe_path = config.get('global','vimproj_path')  # 替换为实际的 your_script.exe 路径
subprocess.run([conemu_path,"/single","/run", f"{your_script_exe_path} -new_console:n"])
