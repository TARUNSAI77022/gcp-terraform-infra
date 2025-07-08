#!/bin/bash

# ==============================
# Update the system
# ==============================
sudo apt-get update -y

# ==============================
# Install Jenkins
# ==============================
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install -y fontconfig openjdk-17-jre jenkins

# ==============================
# Install Docker
# ==============================
sudo apt-get install -y ca-certificates curl gnupg lsb-release

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# ==============================
# Install PostgreSQL 17
# ==============================
sudo apt-get install -y curl ca-certificates gnupg

sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc \
  https://www.postgresql.org/media/keys/ACCC4CF8.asc

. /etc/os-release

echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] \
https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main" | \
sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null

sudo apt-get update
sudo apt-get install -y postgresql-17

# ==============================
# Enable services
# ==============================
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl enable docker
sudo systemctl start docker
# ==============================
# Enable and start PostgreSQL
# ==============================
sudo systemctl enable postgresql
sudo systemctl start postgresql

# ==============================
# Configure PostgreSQL to listen on all interfaces
# ==============================
sudo sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/17/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/17/main/pg_hba.conf
sudo systemctl restart postgresql

# ==============================
# Set password for default user
# ==============================
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'Postgresql';"

