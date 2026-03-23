pipeline {
    agent any

    // Adjust these to your needs
    environment {
        TARGET_DIR  = '/home/administrator/newfolder1'
        TARGET_FILE = '/home/administrator/newfolder1/runme.sh'
        OWNER       = 'administrator:administrator'
    }

    stages {

        stage('Create directory (sudo)') {
            steps {
                sh '''
                  set -e
                  echo "[DIR] Creating directory: ${TARGET_DIR}"
                  sudo mkdir -p "${TARGET_DIR}"
                  sudo chown -R ${OWNER} "${TARGET_DIR}"
                  sudo chmod 755 "${TARGET_DIR}"

                  echo "[DIR] Verify:"
                  sudo ls -ld "${TARGET_DIR}"
                '''
            }
        }

        stage('Create file if directory exists (sudo)') {
            steps {
                sh '''
                  set -e
                  echo "[FILE] Checking directory exists before file creation"
                  if sudo test -d "${TARGET_DIR}"; then
                    echo "[FILE] Directory OK — creating file: ${TARGET_FILE}"
                    # Use tee with sudo so redirection happens with elevated rights
                    sudo tee "${TARGET_FILE}" > /dev/null << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from runme.sh"
echo "Running as: $(whoami)"
echo "PWD: $(pwd)"
date
EOF
                    sudo chown ${OWNER} "${TARGET_FILE}"
                    # Make it executable now so we can run it next stage
                    sudo chmod 755 "${TARGET_FILE}"
                  else
