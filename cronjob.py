# Cronjobs for all

import time
import schedule
import subprocess
import os

def update_system():
    # check if system if arch or debian based 
    os_type = ('/etc/os-release')
    if os_type == "*Arch*" or os_type == "*Manjaro*":
        subprocess.run(['sudo', 'pacman', '-Syu', '--noconfirm'])
        # autoremove packages
        subprocess.run(['sudo', 'pacman', '-R', '--noconfirm'])
    elif os_type == "*debian*" or os_type == "*Kali*" or os_type == "*ubuntu*":
        subprocess.run(['sudo', 'apt', 'update', '-y'])
        subprocess.run(['sudo', 'apt', 'upgrade', '-y'])
        subprocess.run(['sudo', 'apt', 'autoremove', '-y'])
    else:
        print("++++++++++++++++++++++++++++++++++++++++++")
        print("Cannot detect Operating System type, BYEEE")
        print("++++++++++++++++++++++++++++++++++++++++++")


schedule.every().sunday.at("09:17").do(update_system)

while True:
    schedule.run_pending()
    time.sleep(1)
