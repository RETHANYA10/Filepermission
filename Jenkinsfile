pipeline {
    agent any

    parameters {
        // Folder name you want to create (under /home/administrator)
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
                  bash -euo pipefail <<'BASH'
                  echo "[INFO] s=${s}"
                  echo "[DIR] Creating: ${DIR}"

                  if sudo mkdir -p "${DIR}"; then
                    sudo chown -R ${OWNER} "${DIR}"
                    # DEMO: all permissions for dir (777). Avoid in production.
                    sudo chmod 777 "${DIR}"
                    echo "[DIR] Created OK"
                    sudo ls -ld "${DIR}"
                  else
                    echo "[DIR] ERROR: Failed to create ${DIR}"
                    exit 1
                  fi
                  BASH
                '''
            }
        }

        stage('Create file if directory exists (sudo)') {
            steps {
                sh '''
                  bash -euo pipefail <<'BASH'
                  echo "[FILE] Checking directory exists before file creation"

                  if sudo test -d "${DIR}"; then
                    echo "[FILE] Creating: ${FILE}"
                    # Use tee+sudo so the write occurs with elevated permissions
                    sudo tee "${FILE}" > /dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from runme.sh"
echo "Running as: $(whoami)"
echo "PWD: $(pwd)"
date
EOF
                    sudo chown ${OWNER} "${FILE}"
                    # DEMO: give all permissions to script (777) so it is executable by anyone
                    sudo chmod 777 "${FILE}"
                    sudo ls -l "${FILE}"
                  else
                    echo "[FILE] ERROR: Directory missing: ${DIR}"
                    exit 2
                  fi
                  BASH
                '''
            }
        }

        stage('Execute file if created (sudo)') {
            steps {
                sh '''
                  bash -euo pipefail <<'BASH'
                  echo "[EXEC] Verifying and executing file"

                  if sudo test -f "${FILE}"; then
                    if ! sudo test -x "${FILE}"; then
                      echo "[EXEC] Script not executable; adding exec bit"
                      sudo chmod +x "${FILE}"
                    fi

                    echo "[EXEC] Running ${FILE}"
                    # Run the script and capture output
                    sudo "${FILE}" | sudo tee "${OUT}" > /dev/null
                    sudo chown ${OWNER} "${OUT}"
                    # DEMO: data file writable by all (666). Avoid in production.
                    sudo chmod 666 "${OUT}"
                  else
                    echo "[EXEC] ERROR: File missing: ${FILE}"
                    exit 3
                  fi
                  BASH
                '''
            }
        }

        stage('Final permission pass (sudo)') {
            steps {
                sh '''
                  bash -euo pipefail <<'BASH'
                  echo "[PERMS] Setting FINAL permissions (demo - wide open)"

                  # DEMO: all permissions. Prefer 755 (dir) and 644 (files) in real environments.
                  sudo chmod 777 "${DIR}"
                  sudo chmod 777 "${FILE}"
                  sudo chmod 666 "${OUT}"

                  echo "[PERMS] Final state:"
                  sudo ls -ld "${DIR}"
                  sudo ls -l "${DIR}"
                  echo "DIR_MODE=$(sudo stat -c '%a' "${DIR}")"
                  echo "FILE_MODE=$(sudo stat -c '%a' "${FILE}")"
                  echo "OUT_MODE=$(sudo stat -c '%a' "${OUT}")"
                  BASH
                '''
            }
        }

        stage('Verify & print paths') {
            steps {
                sh '''
                  bash -euo pipefail <<'BASH'
                  sudo test -d "${DIR}"
                  sudo test -f "${FILE}"
                  sudo test -f "${OUT}"

                  echo "[VERIFY] Success."
                  echo "[VERIFY] Folder: ${s}"
                  echo "[VERIFY] Full path: ${DIR}"
                  echo "[VERIFY] Contents:"
                  sudo ls -l "${DIR}"
                  BASH
                '''
            }
        }
    }

    post {
        always {
            echo "Done. Folder created at: ${DIR}"
            echo "NOTE: Path is outside the Jenkins workspace; artifact archiving will not capture it."
        }
    }
}
