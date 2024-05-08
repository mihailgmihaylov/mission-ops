import os
import socket

def main(event, context):
    hostname = os.environ.get('DB_HOST')
    port = int(os.environ.get('DB_PORT'))

    is_open = is_port_open(hostname, port)

    if is_open:
        result = f"Port {port} on {hostname} is open."
        print(result)
        return {
            'statusCode': 200,
            'body': result
        }
    else:
        result = f"Port {port} on {hostname} is closed."
        print(result)
        return {
            'statusCode': 200,
            'body': result
        }

def is_port_open(hostname, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        sock.settimeout(1)

        result = sock.connect_ex((hostname, port))

        if result == 0:
            return True
        else:
            return False
    except Exception as e:
        print("Error:", e)
        return False
    finally:
        sock.close()
