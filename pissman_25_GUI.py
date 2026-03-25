import tkinter as tk
from tkinter import messagebox
import hashlib, XNOR_module, sys, os, getpass, json, requests, subprocess, time
from cryptography.fernet import Fernet
import threading

XNOR_module.cls()

def NextStep(need_password: bool, need_pin: bool, need_user: bool):
    def worker():
        if not need_password and not need_pin and not need_user:
            with open("output.txt", "w") as f:
                f.write("EXIT")
            return

        with open("output.txt", "w") as f:
            f.write("WLN")

        # Wait for outmain.txt
        for _ in range(100):
            if os.path.exists("outmain.txt"):
                break
            time.sleep(1)
        else:
            print("Timeout waiting for outmain.txt")
            return

        with open("outmain.txt", "r") as f:
            info = f.read()

        subprocess.run(["postdata.bat"])

    threading.Thread(target=worker, daemon=True).start()

VERSION = "1.0.0"
GetVersionFile = "https://raw.githubusercontent.com/BOBZERO-afk/pissman-25-V2/refs/heads/main/version.txt"

def read_github_partial(url, start_line=None, end_line=None):
    try:
        response = requests.get(url)
        response.raise_for_status()
        lines = response.text.splitlines()
        if start_line is not None and end_line is not None:
            return lines[start_line-1:end_line]
        return response.text
    except requests.RequestException as e:
        print(f"Failed to fetch file from GitHub: {e}")
        return None

version_lines = read_github_partial(GetVersionFile, 1, 5)

def start_main():
    subprocess.run(["python", "pissman_25_main.py", "start"], shell=True)

try:
    computer_user = getpass.getuser()
except OSError:
    print("OSError: Windows USERNAME not set")
    raise

home_dir = f"C:\\Users\\{computer_user}\\pissman_25_V2"
key_file = os.path.join(home_dir, "key.key")
login_file = os.path.join(home_dir, "login.json")
local_path = os.path.join(home_dir, "moter_fucker.txt")

if version_lines and VERSION not in version_lines:
    try:
        response = requests.get(GetVersionFile)
        response.raise_for_status()

        os.makedirs(home_dir, exist_ok=True)
        with open(local_path, "w") as f:
            f.write(str(response.text))

        print(f"File downloaded successfully to {local_path}")
    except requests.RequestException as e:
        print(f"Download failed: {e}")

key = Fernet.generate_key()
cipher = Fernet(key)

password = None
pin = None
username = None

root = tk.Tk()
root.title("main")
root.maxsize(555, 250)

if len(sys.argv) > 1 and sys.argv[1] == "R":
    but = tk.Button(root, text=".", command=lambda: NextStep(True, True, True))
    but.pack(pady=10)

bur = tk.Button(
    root,
    text="start main",
    bd=0,
    command=start_main
)
bur.pack(pady=10)

root.mainloop()
