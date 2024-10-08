# Node.js Docker Application with Let's Encrypt SSL on Amazon Linux 2023

This project sets up a Node.js application using Docker on Amazon Linux 2023, with Nginx as a reverse proxy (with SSL support from Let's Encrypt) and PM2 for process management.

## Prerequisites

- Amazon Linux 2023 instance (AWS Lightsail)
- Docker (install instructions below)
- Docker Compose (install instructions below)
- The domain api.in30.com.br pointing to your Lightsail instance's public IP address

## Installation on Amazon Linux 2023

1. Update the system and install Docker:
   ```
   sudo dnf update -y
   sudo dnf install docker -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker ec2-user
   ```

2. Install Docker Compose:
   ```
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

3. Install additional useful tools (git, htop, unzip):
   ```
   sudo dnf install git htop unzip -y
   ```

4. Log out and log back in for the group changes to take effect.

## Getting Started

1. Clone this repository:
   ```
   git clone <repository-url>
   cd <project-directory>
   ```

2. The `nginx.conf` file is already configured for the domain api.in30.com.br.

3. In the `init-letsencrypt.sh` script, add your email address to the `email` variable for important notifications from Let's Encrypt.

4. Make the script executable and run it:
   ```
   chmod +x init-letsencrypt.sh
   ./init-letsencrypt.sh
   ```

5. Once the certificates are obtained, start the application:
   ```
   docker-compose up -d
   ```

## Project Structure

- `index.js`: The main Node.js application file.
- `Dockerfile`: Defines the Docker image for the Node.js application, based on Amazon Linux 2023.
- `docker-compose.yml`: Orchestrates the multi-container Docker application.
- `nginx.conf`: Configuration file for the Nginx reverse proxy with SSL support.
- `init-letsencrypt.sh`: Script to initialize Let's Encrypt certificates.

## Services

1. **app**: The main Node.js application.
2. **nginx**: Acts as a reverse proxy with SSL termination, forwarding requests to the Node.js application.
3. **certbot**: Handles SSL certificate generation and renewal.
4. **pm2**: Manages the Node.js application process for improved reliability and performance.

## Development

To make changes to the application:

1. Modify the `index.js` file as needed.
2. Rebuild and restart the Docker containers:
   ```
   docker-compose down
   docker-compose up --build -d
   ```

## Stopping the Application

To stop the application and remove the containers:

```
docker-compose down
```

## SSL Certificate Renewal

Certbot will automatically try to renew the certificates when they are close to expiry. The Docker Compose configuration includes a service that runs Certbot in the background and automatically reloads Nginx when certificates are renewed.

## Notes

- The Node.js application runs on port 3000 inside the container.
- Nginx listens on ports 80 (HTTP) and 443 (HTTPS), redirecting all HTTP traffic to HTTPS.
- PM2 is used to manage the Node.js process in production mode.
- SSL certificates are provided by Let's Encrypt and are valid for 90 days, with automatic renewal.
- The application will be accessible at https://api.in30.com.br once set up.

## Security Considerations

- Ensure that your Lightsail instance's firewall allows inbound traffic on ports 80 and 443.
- Consider setting up AWS WAF for additional security.
- Regularly update your Amazon Linux 2023 instance and Docker images.

For any issues or questions, please open an issue in the repository.