FROM python:3.11-slim

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install apt-utils and other required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libjpeg-dev \
        zlib1g-dev \
        libpng-dev \
        libfreetype6-dev \
        pkg-config \
        gfortran \
        libopenblas-dev \
        liblapack-dev \
        python3-venv && \
    rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and install pip dependencies
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir virtualenv

# Copy requirements.txt
COPY requirements.txt .

# Install dependencies within the virtual environment
RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Ensure the virtual environment's Python is used
ENV PATH="/opt/venv/bin:$PATH"

# Command to run the application
CMD ["python", "app.py"]
