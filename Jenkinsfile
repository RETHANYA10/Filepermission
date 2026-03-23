pipeline {
    agent any

    parameters {
        // Folder name to create (default mfolder)
        string(name: 's', defaultValue: 'mfolder', description: 'Folder name to create under /home/administrator')
    }

    environment {
        DIR   = "/home/administrator/${params.s}"
        FILE  = "/home/administrator/${params.s}/runme.sh"
        OUT   = "/home/administrator/${params.s}/output.txt"
        OWNER = "administrator:administrator"
    }

    stages {

        stage('Create directory (sudo)') {
            steps {
                sh '''
                  set -euo pipefail
                  echo "[INFO] Folder param (s): ${s}"
                  echo "[DIR] Creating: ${DIR}"

                  if sudo mkdir -p "${DIR}"; then
                    sudo chown -R ${OWNER} "${DIR}"
                    # Give ALL permissions (demo only)
                    sudo chmod 777 "${DIR}"
                    echo "[DIR] Created OK"
                    sudo ls -ld "${DIR}"
                  else
                    echo "[DIR] ERROR: Failed to create ${DIR}"
                    exit 1
                  fi
                '''
            }
        }

        stage('Create file if directory exists (sudo)') {
            steps {
                sh '''
                  set -euo pipefail
                  echo "[FILE] Checking directory exists before file creation"

                  if sudo test -d "${DIR}"; then
                    echo "[FILE] Creating: ${FILE}"
                    # Use tee with sudo so redirect happens with elevated perms
                    sudo tee "${FILE}" > /dev/null << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from runme.sh"
echo "Running as: $(whoami)"
echo "PWD: $(pwd)"
date
EOF
                    sudo chown ${OWNER} "${FILE}"
                    # Give ALL permissions (demo only)
                    sudo chmod 777 "${FILE}"
                    sudo ls -l "${FILE}"
                  else
                    echo "[FILE] ERROR: Directory missing: ${DIR}"
                    exit 2
                  fi
                '''
            }
        }

        stage('Execute file if created (sudo)') {
            steps {
                sh '''
                  set -euo pipefail
                  echo "[EXEC] Verifying and executing file"

                  if sudo test -f "${FILE}"; then
                    if ! sudo test -x "${FILE}"; then
                      echo "[EXEC] File not executable, adding exec bit"
                      sudo chmod +x "${FILE}"
                    fi
                    echo "[EXEC] Running ${FILE}"
                    sudo "${FILE}" | sudo tee "${OUT}" > /dev/null
                    sudo chown ${OWNER} "${OUT}"
                    # Give ALL read/write (demo only); no need for exec on output
                    sudo chmod 666 "${OUT}"
                  else
                    echo "[EXEC] ERROR: File missing: ${FILE}"
                    exit 3
                  fi
                '''
            }
        }

        stage('Final permission pass (sudo)') {
            steps {
                sh '''
                  set -euo pipefail
                  echo "[PERMS] Setting FINAL ALL permissions (demo only)"
                  sudo chmod 777 "${DIR}"
                  sudo chmod 777 "${FILE}"
                  # OUT is a data file; keep rw for all, no exec
                  sudo chmod 666 "${OUT}"
                  echo "[PERMS] Final state:"
                  sudo ls -ld "${DIR}"
                  sudo ls -l "${DIR}"
                  echo "DIR_MODE=$(sudo stat -c '%a' "${DIR}")"
                  echo "FILE_MODE=$(sudo stat -c '%a' "${FILE}")"
                  echo "OUT_MODE=$(sudo stat -c '%a' "${OUT}")"
                '''
            }
        }

        stage('Verify & print paths') {
            steps {
                sh '''
                  set -euo pipefail
                  sudo test -d "${DIR}"
                  sudo test -f "${FILE}"
                  sudo test -f "${OUT}"
                  echo "[VERIFY] Folder name: ${s}"
                  echo "[VERIFY] Full path: ${DIR}"
                  echo "[VERIFY] Contents:"
                  sudo ls -l "${DIR}"
                '''
            }
        }
    }

    post {
        always {
            echo "Done. Folder created at: ${DIR}"
            echo "NOTE: This path is outside the Jenkins workspace, so artifact archiving will not capture it."
        }
    }
}
