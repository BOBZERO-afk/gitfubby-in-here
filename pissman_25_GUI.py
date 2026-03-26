import tkinter as tk
import hashlib, sys, os, getpass, requests, subprocess, time, threading
from cryptography.fernet import Fernet

def NextStep(need_password, need_pin, need_user):
    def worker():
        if not (need_password or need_pin or need_user):
            with open("output.txt", "w") as f:
                f.write("EXIT")
            return

        with open("output.txt", "w") as f:
            f.write("WLN")

        for _ in range(50):
            if os.path.exists("outmain.txt"):
                break
            time.sleep(1)
        else:
            print("Timeout waiting for outmain.txt")
            return

        subprocess.run(["postdata.bat"])

    threading.Thread(target=worker, daemon=True).start()


def start_main():
    subprocess.run(["python", "pissman_25_main.py", "start"])


root = tk.Tk()
root.title("main")
root.geometry("300x150")

if len(sys.argv) > 1 and sys.argv[1] == "R":
    tk.Button(root, text="Next", command=lambda: NextStep(True, True, True)).pack(pady=10)

tk.Button(root, text="Start main", command=start_main).pack(pady=10)

root.mainloop()
