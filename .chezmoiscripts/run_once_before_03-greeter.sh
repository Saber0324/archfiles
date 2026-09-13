#!/usr/bin/env bash

set -e

DEST="/etc/greetd/config.toml"

GREETER_CMD="$(command -v noctalia-greeter-session)" || {
  echo "Error: 'noctalia-greeter-session' not found in PATH." >&2
  exit 1
}

export GREETER_CMD

sudo -E python3 - <<'EOF'
import os
import tomllib

dest = "/etc/greetd/config.toml"
greeter_cmd = os.environ.get("GREETER_CMD")

if not greeter_cmd:
    raise ValueError("GREETER_CMD environment variable is empty.")

with open(dest, "rb") as f:
    config = tomllib.load(f)

config.setdefault("default_session", {})
config["default_session"]["command"] = greeter_cmd
config["default_session"]["user"] = "greeter"

lines = []
for section, values in config.items():
    lines.append(f"[{section}]")
    for key, value in values.items():
        if isinstance(value, str):
            lines.append(f'{key} = "{value}"')
        elif isinstance(value, bool):
            lines.append(f"{key} = {str(value).lower()}")
        else:
            lines.append(f"{key} = {value}")
    lines.append("")

with open(dest, "w") as f:
    f.write("\n".join(lines))

print(f"greetd config merged successfully with command: {greeter_cmd}")
EOF

sudo systemctl enable greetd.service
