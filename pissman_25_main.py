import sys, os, subprocess, time

def wait_for_file(file, timeout=50):
    for _ in range(timeout):
        if os.path.exists(file):
            return True
        time.sleep(0.5)
    return False

def main(data: list):
    subprocess.run(["python", "pissman_25_GUI.py", "R"])

    while True:
        if not wait_for_file("output.txt"):
            print("Timeout waiting for output.txt")
            continue

        with open("output.txt", "r", encoding="utf-8") as f:
            out = f.read().strip()

        os.remove("output.txt")

        user = downloadsF = windows_ver = password = pin = EMAIL = ""

        if out == "WLN":
            try:
                user = data[1]
                windows_ver = data[3]
                downloadsF = data[12]
            except IndexError:
                print("Data format error")
                continue

        elif out == "EXIT":
            sys.exit(0)

        main_output = [user, downloadsF, windows_ver, password, pin, EMAIL]

        with open("outmain.txt", "w", encoding="utf-8") as f:
            f.write("\n".join(main_output))


data = []

if len(sys.argv) < 2:
    print("No argument given")
    sys.exit(1)

mode = sys.argv[1]

if mode == "start":
    if os.path.exists("pissman_25.bat") and os.path.exists("pissman.ps1"):

        subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", "pissman.ps1"])
        time.sleep(2)

        if os.path.exists("done.txt"):
            os.startfile("pissman_25.bat")

            if not wait_for_file("info2.txt", 40):
                print("info2.txt timeout")
                sys.exit(1)

            with open("info2.txt", "r", encoding="utf-8") as f:
                data = f.read().splitlines()

            main(data)
        else:
            with open("restart_please.txt", "w") as f:
                f.write("a")
            sys.exit(1)

elif mode == "restart":
    if not os.path.exists("done.txt"):
        if all(os.path.exists(f) for f in ["pissman_25.bat", "pissman.ps1", "restart_please.txt"]):
            os.remove("restart_please.txt")

            os.startfile("pissman_25.bat")

            if not wait_for_file("info2.txt", 40):
                print("Timeout restart")
                sys.exit(1)

            with open("info2.txt", "r", encoding="utf-8") as f:
                data = f.read().splitlines()

            main(data)
