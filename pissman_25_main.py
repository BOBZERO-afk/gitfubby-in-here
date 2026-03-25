import sys, os, subprocess, time


def main(data: list):
    subprocess.run(["python", "pissman_25_GUI.py", "R"], shell=True)

    while True:
        while not os.path.exists("output.txt"):
            time.sleep(3)

        with open("output.txt", "r") as f:
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

            password = ""
            pin = ""
            EMAIL = ""

        elif out == "EXIT":
            sys.exit(0)

        main_output = [
            user,
            downloadsF,
            windows_ver,
            password,
            pin,
            EMAIL
        ]

        if os.path.exists("outmain.txt"):
            os.remove("outmain.txt")

        with open("outmain.txt", "a") as f:
            for line in main_output:
                f.write(str(line) + "\n")

if len(sys.argv) < 2:
    print("No argument given")
    sys.exit(1)

mode = sys.argv[1]

if mode == "start":
    if os.path.exists("pissman_25.bat") and os.path.exists("pissman.ps1"):

        subprocess.run([
            "powershell",
            "-ExecutionPolicy", "Bypass",
            "-File", "pissman.ps1"
        ])

        time.sleep(3)

        if os.path.exists("done.txt"):
            os.startfile("pissman_25.bat")

            while not os.path.exists("info2.txt"):
                time.sleep(1.5)

            with open("info2.txt", "r") as f:
                data = f.read().splitlines()

            main(data)

        else:
            with open("restart_please.txt", "w") as f:
                f.write("a")

            sys.exit(1)

elif mode == "restart":
    if not os.path.exists("done.txt"):
        if (
            os.path.exists("pissman_25.bat")
            and os.path.exists("pissman.ps1")
            and os.path.exists("restart_please.txt")
        ):
            os.remove("restart_please.txt")

            try:
                os.startfile("pissman_25.bat")

                while not os.path.exists("info2.txt"):
                    time.sleep(1.5)

                with open("info2.txt", "r") as f:
                    data = f.read().splitlines()

            except OSError as r:
                print(f"OSError! {r}")
                raise

            except FileNotFoundError as r:
                print(f"Try again without restarting... {r}")
                raise

            main(data)
