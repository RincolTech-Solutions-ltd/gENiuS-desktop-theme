#!/usr/bin/env python3
"""Configure XScreenSaver to use glmatrix (Matrix digital rain) as the
gENiuS theme's screensaver, with a 5-minute idle timeout."""
import os
import re
import subprocess
import sys
import time

CONF = os.path.expanduser("~/.xscreensaver")

SETTINGS = {
    "timeout": "0:05:00",
    "splash": "False",
    "lock": "False",
    "dpmsEnabled": "False",
    "mode": "one",
    "selected": "0",
}

GLMATRIX_ENTRY = "  GL: \t\t\t\tglmatrix --root --no-fog --no-waves\t\t\t    \\n\\\n"


def ensure_conf_exists():
    if os.path.exists(CONF):
        return
    proc = subprocess.Popen(["xscreensaver", "-no-splash"],
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    for _ in range(20):
        if os.path.exists(CONF):
            break
        time.sleep(0.5)
    proc.terminate()
    try:
        proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        proc.kill()


def main():
    ensure_conf_exists()
    if not os.path.exists(CONF):
        print("error: could not generate ~/.xscreensaver", file=sys.stderr)
        sys.exit(1)

    with open(CONF) as f:
        lines = f.readlines()

    # Patch top-level settings
    for i, line in enumerate(lines):
        m = re.match(r"^(\w+):\s*\S", line)
        if m and m.group(1) in SETTINGS:
            lines[i] = f"{m.group(1)}:\t{SETTINGS[m.group(1)]}\n"

    # Find the "programs:" block (ends at the next blank line)
    start = next((i for i, l in enumerate(lines) if l.startswith("programs:")), None)
    if start is None:
        print("error: no 'programs:' block found in ~/.xscreensaver", file=sys.stderr)
        sys.exit(1)

    end = start + 1
    while end < len(lines) and lines[end].strip() != "":
        end += 1

    body = lines[start + 1:end]

    # Group lines into entries — each entry ends with a line ending in "\n\"
    entries, current = [], []
    for line in body:
        current.append(line)
        if line.rstrip("\n").endswith("\\n\\"):
            entries.append(current)
            current = []
    if current:
        entries.append(current)

    # Drop any existing glmatrix entries, prepend ours as entry 0
    entries = [e for e in entries if not any("glmatrix" in l for l in e)]
    entries.insert(0, [GLMATRIX_ENTRY])

    new_body = [l for e in entries for l in e]
    lines = lines[:start + 1] + new_body + lines[end:]

    with open(CONF, "w") as f:
        f.writelines(lines)

    print("Configured ~/.xscreensaver: glmatrix selected, 5-minute timeout")


if __name__ == "__main__":
    main()
