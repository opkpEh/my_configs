import psutil
import time

def get_disk_io_speed():
    initial_disk_io = psutil.disk_io_counters()
    time.sleep(1)
    final_disk_io = psutil.disk_io_counters()
    read_speed = (final_disk_io.read_bytes - initial_disk_io.read_bytes) / 1
    write_speed = (final_disk_io.write_bytes - initial_disk_io.write_bytes) / 1
    return read_speed, write_speed

def format_speed(speed):
    units = ["KB/s", "MB/s"]
    for unit in units:
        if speed < 1024:
            return f"{speed:.2f} {unit}"
        speed /= 1024

def main():
    read_speed, write_speed = get_disk_io_speed()
    read_speed_str = format_speed(read_speed)
    write_speed_str = format_speed(write_speed)
    print(f"{read_speed_str} | {write_speed_str}")

if __name__ == "__main__":
    main()
