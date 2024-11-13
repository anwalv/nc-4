# FTP Server Setup and Authentication

## Brief Description
This project automates the setup of an FTP server on a fresh Ubuntu 24.04 installation using `vsftpd`. It also provides an authentication service that 
controls access to the FTP server based on IP address and authorization key.

## Installation
1. Download and extract the provided archive.
2. Run `configureServer.sh` to install the necessary packages and configure the FTP server.
3. The FTP server will only allow access to specified IP addresses.
4. The `authServer.sh` service listens on port 7777 for incoming client connections, validating their authorization.

## How to Use
1. To configure the FTP server, run:
    ```bash
    ./configureServer.sh 192.168.0.105,10.10.1.2
    ```
    This will allow access only from the specified IPs.
2. The `authServer.sh` will prompt for an authorization key when clients attempt to connect.
3. Add valid IP and key pairs to `credentials.txt` for authorized clients.
4. The FTP server will be available at port 21. If you want to connect from ip which was passed when the script was run, use the command :
    ```bash
    ftp 172.22.234.41
    ```
    Use user login and password(from assignment)

    If your address was not passed, then try using the command to attempt authorization:
    ```bash
    nc 172.22.234.41 7777
    ```
    Enter authorisation key and run:
   ```bash
    ftp 172.22.234.41
    ``` 
(You need to change **172.22.234.41** to ip of VM where was runned configureServer.sh)
