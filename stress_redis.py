import redis
import threading
import os
import base64
import time
import random

# === CONFIG ===
HOST = "10.119.24.164"
PORT = 6379
KEY_PREFIX = "stress_key_"
VALUE_SIZE_BYTES = 100 * 1024  # 100 KB value
TOTAL_KEYS = 200000  # unique keys (high memory usage)
TTL = 600  # 10 minutes
THREADS = 10

# === Writer Thread ===
def writer_thread(start, end):
    r = redis.StrictRedis(host=HOST, port=PORT)
    for i in range(start, end):
        key = f"{KEY_PREFIX}{i}"
        value = base64.b64encode(os.urandom(VALUE_SIZE_BYTES))
        try:
            r.setex(key, TTL, value)
        except Exception as e:
            print(f"[Writer] Error on key {key}: {e}")

# === Reader/Writer Loop (CPU Stressor) ===
def cpu_stressor():
    r = redis.StrictRedis(host=HOST, port=PORT)
    while True:
        i = random.randint(0, TOTAL_KEYS - 1)
        key = f"{KEY_PREFIX}{i}"
        try:
            r.get(key)
            r.set(key, b"cpu_stress_value")
        except Exception as e:
            print(f"[CPU] Error on key {key}: {e}")

# === RUN ===
if __name__ == "__main__":
    keys_per_thread = TOTAL_KEYS // THREADS
    writer_threads = []

    print(f"Starting memory + eviction stress with {THREADS} writer threads...")

    for i in range(THREADS):
        start = i * keys_per_thread
        end = (i + 1) * keys_per_thread
        t = threading.Thread(target=writer_thread, args=(start, end))
        writer_threads.append(t)
        t.start()

    # Launch 2 CPU stress threads
    print("Starting CPU stress threads...")
    cpu_threads = []
    for _ in range(2):
        t = threading.Thread(target=cpu_stressor, daemon=True)
        cpu_threads.append(t)
        t.start()

    for t in writer_threads:
        t.join()

    print("Initial memory load complete. CPU stressors still running...")
    print("Wait and monitor Redis metrics / alert firing.")
