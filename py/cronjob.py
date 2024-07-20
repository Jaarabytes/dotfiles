import time
import schedule
import subprocess
import os
import logging
from pathlib import Path

# Set up logging
logging.basicConfig(filename='system_update.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

def get_os_type():
    """Determine the OS type."""
    os_release = Path('/etc/os-release').read_text()
    if any(os in os_release.lower() for os in ['arch', 'manjaro']):
        return 'arch'
    elif any(os in os_release.lower() for os in ['debian', 'kali', 'ubuntu']):
        return 'debian'
    else:
        return 'unknown'

def run_command(command):
    """Run a command and log its output."""
    try:
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        logging.info(f"Command '{' '.join(command)}' executed successfully")
        logging.debug(result.stdout)
    except subprocess.CalledProcessError as e:
        logging.error(f"Command '{' '.join(command)}' failed with error: {e}")
        logging.debug(e.stdout)
        logging.debug(e.stderr)

def update_system():
    """Update the system based on its type."""
    os_type = get_os_type()
    logging.info(f"Detected OS type: {os_type}")

    if os_type == 'arch':
        run_command(['sudo', 'pacman', '-Syu', '--noconfirm'])
        run_command(['sudo', 'pacman', '-Rns', '$(pacman -Qtdq)', '--noconfirm'])
    elif os_type == 'debian':
        run_command(['sudo', 'apt', 'update', '-y'])
        run_command(['sudo', 'apt', 'upgrade', '-y'])
        run_command(['sudo', 'apt', 'autoremove', '-y'])
    else:
        logging.error("Unsupported Operating System type")

def check_disk_space():
    """Check available disk space and log if it's low."""
    disk = os.statvfs('/')
    free_space = disk.f_frsize * disk.f_bavail / (1024 * 1024 * 1024)  # Free space in GB
    if free_space < 5:  # Alert if less than 5GB free
        logging.warning(f"Low disk space: {free_space:.2f}GB available")

def main():
    schedule.every().sunday.at("09:17").do(update_system)
    schedule.every().day.at("00:00").do(check_disk_space)

    logging.info("Scheduler started")
    while True:
        schedule.run_pending()
        time.sleep(60)  # Sleep for 1 minute instead of 1 second to reduce CPU usage

if __name__ == "__main__":
    main()
