import socket
import time
import os
import sys

host = os.environ.get("DB_HOST", "localhost")
port = int(os.environ.get("DB_PORT", 3306))
timeout = 15  # seconds

start_time = time.time()
while time.time() - start_time < timeout:
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1)
            s.connect((host, port))
        print("Database is up!", file=sys.stderr)
        sys.exit(0)
    except socket.error as ex:
        print(f"Database isn't up yet, waiting... ({ex})", file=sys.stderr)
        time.sleep(1)

print("Database connection timed out.", file=sys.stderr)
sys.exit(1)
