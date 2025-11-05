import time
import signal
import sys

def signal_handler(sig, frame):
    print("Got SIGINT. Exiting.")
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

while True:
    print("Backend is running.")
    time.sleep(10)