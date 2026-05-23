#!/bin/bash
#
# GVA Droplet Setup Script
# Run this in DigitalOcean console: https://cloud.digitalocean.com/droplets/529151174/console
#
set -e

echo "=========================================="
echo "GVA Migration - Droplet Setup"
echo "=========================================="
echo ""

# Update system
echo "[1/6] Updating system packages..."
apt-get update -qq

# Install Python 3.12
echo "[2/6] Installing Python 3.12..."
apt-get install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update -qq
apt-get install -y python3.12 python3.12-venv python3.12-dev python3.12-distutils

# Install system dependencies
echo "[3/6] Installing system dependencies (ffmpeg, git, postgresql-client)..."
apt-get install -y ffmpeg build-essential libpq-dev libssl-dev libffi-dev git curl wget \
    libavcodec-extra libsndfile1 libsndfile1-dev portaudio19-dev postgresql-client

# Install Redis
echo "[4/6] Installing and configuring Redis..."
apt-get install -y redis-server
systemctl enable redis-server

# Configure Redis
sed -i 's/^bind .*/bind 127.0.0.1/' /etc/redis/redis.conf
if ! grep -q "^maxmemory" /etc/redis/redis.conf; then
    echo "maxmemory 256mb" >> /etc/redis/redis.conf
    echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf
fi

systemctl restart redis-server

# Test Redis
echo "[5/6] Testing Redis connection..."
redis-cli ping

# Verify Python 3.12
echo "[6/6] Verifying Python 3.12 installation..."
python3.12 --version

echo ""
echo "=========================================="
echo "✅ Droplet setup complete!"
echo "=========================================="
echo ""
echo "Installed:"
echo "  - Python 3.12"
echo "  - Redis (running on localhost:6379)"
echo "  - ffmpeg"
echo "  - PostgreSQL client"
echo "  - Build tools and libraries"
echo ""
echo "Next: Run the application deployment script"
echo "=========================================="
