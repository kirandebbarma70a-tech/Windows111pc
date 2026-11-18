FROM python:3.10-slim

# Install system dependencies for mounting, networking, and Rclone
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    fuse3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install latest Rclone for cloud storage integration
RUN curl https://rclone.org/install.sh | bash

WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source files
COPY . .

# Create persistent mount directory
RUN mkdir -p /tmp/terabox_storage

EXPOSE 10000

# Run FastAPI with WebSocket support on Render's default port
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000", "--ws-ping-interval", "20", "--ws-ping-timeout", "20"]
