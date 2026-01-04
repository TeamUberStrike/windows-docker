import paramiko
from scp import SCPClient
from dotenv import load_dotenv
import os

load_dotenv()  # loads .env from current directory

host = os.getenv("HOST")
user = os.getenv("USER")
password = os.getenv("PASS")
port = int(os.getenv("PORT", 22))

def create_ssh_client(host, user, password=None, key_file=None, port=22):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(
        hostname=host,
        username=user,
        password=password,
        port=port,
        key_filename=key_file,
    )
    return client

ssh = create_ssh_client(
    host=host,
    user=user,
    password=password,
    port=port,
    #key_file="~/.ssh/id_rsa"  # or use password="secret"
)

ssh.exec_command(
    'powershell -Command "New-Item -ItemType Directory -Path C:\\production -Force"'
)

with SCPClient(ssh.get_transport()) as scp:
   scp.put("setupWindowsWebservice.ps1", "C:/production")
   scp.put("setupWindowsPorts.ps1", "C:/production")


#ssh.exec_command("cd C:/production && setupWindowsPorts ")

ssh.close()

