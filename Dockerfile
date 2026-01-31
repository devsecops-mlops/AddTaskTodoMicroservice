# Use the official Python image
FROM python:3.9-bullseye

# Set the working directory
WORKDIR /app

# Copy the application files
COPY . .

# Install required system dependencies
RUN apt-get update && apt-get install -y curl gnupg2 unixodbc unixodbc-dev

# Add Microsoft’s official GPG key
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft.gpg

# Detect architecture and add the correct repository
# This version uses "bullseye" to match the base image
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/11/prod bullseye main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Install Microsoft ODBC driver for SQL Server
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
