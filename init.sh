#!/bin/bash

# Variables
APACHE_CONF_DIR="/etc/apache2"
SSL_DIR="$APACHE_CONF_DIR/ssl"
HOSTNAME="example.net"  # Replace with your desired hostname
DOCUMENT_ROOT="/var/www/$HOSTNAME"
SSL_CERT="$SSL_DIR/server.crt"
SSL_KEY="$SSL_DIR/server.key"

# Ensure Apache is installed
echo "Ensuring Apache is installed..."
if ! command -v apache2 >/dev/null; then
    echo "Installing Apache..."
    sudo apt update && sudo apt install apache2 -y
else
    echo "Apache is already installed."
fi

# Enable necessary modules
echo "Enabling necessary Apache modules..."
sudo a2enmod ssl rewrite headers

# Create SSL directory
echo "Setting up SSL directory..."
if [ ! -d "$SSL_DIR" ]; then
    sudo mkdir -p "$SSL_DIR"
    echo "SSL directory created."
fi

# Generate a self-signed SSL certificate if it doesn't exist
if [ ! -f "$SSL_CERT" ] || [ ! -f "$SSL_KEY" ]; then
    echo "Generating self-signed SSL certificate..."
    sudo openssl req -newkey rsa:2048 -nodes -keyout "$SSL_KEY" -x509 -days 365 -out "$SSL_CERT" \
        -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=$HOSTNAME/emailAddress=admin@$HOSTNAME"
    echo "SSL certificate created."
else
    echo "SSL certificate already exists."
fi

# Create document root directory
echo "Setting up document root directory: $DOCUMENT_ROOT"
if [ ! -d "$DOCUMENT_ROOT" ]; then
    sudo mkdir -p "$DOCUMENT_ROOT"
    echo "<h1>Welcome to $HOSTNAME</h1>" | sudo tee "$DOCUMENT_ROOT/index.html"
    echo "Document root created and default index.html added."
fi

# Use Apache's default config creation flow
echo "Creating Apache virtual host configuration..."
SITE_CONF="$HOSTNAME.conf"
sudo bash -c "cat > /etc/apache2/sites-available/$SITE_CONF" <<EOF
<VirtualHost *:80>
    ServerName $HOSTNAME
    DocumentRoot $DOCUMENT_ROOT
    Redirect permanent / https://$HOSTNAME/
</VirtualHost>

<VirtualHost *:443>
    ServerName $HOSTNAME
    DocumentRoot $DOCUMENT_ROOT

    SSLEngine on
    SSLCertificateFile $SSL_CERT
    SSLCertificateKeyFile $SSL_KEY

    <Directory $DOCUMENT_ROOT>
        Options +Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        DirectoryIndex index.php index.html
    </Directory>
</VirtualHost>
EOF

# Enable the site configuration
echo "Enabling the site configuration..."
sudo a2ensite "$SITE_CONF"

# Test Apache configuration
echo "Testing Apache configuration..."
sudo apache2ctl configtest

# Restart Apache
echo "Restarting Apache to apply changes..."
sudo systemctl restart apache2

# Completion message
echo "Apache setup with SSL is complete."
echo "Your site is available at http://$HOSTNAME and https://$HOSTNAME"
