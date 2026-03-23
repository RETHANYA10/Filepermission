pipeline {
    agent any

    parameters {
        // s = folder name (f1 by default)
        string(name: 's', defaultValue: 'f1', description: 'Folder name to create (e.g., f1)')
    }

    environment {
        DIR  = "${env.WORKSPACE}/${params.s}"
        FILE = "${env.WORKSPACE}/${params.s}/runme.sh"
    }

    stages {
        stage('Create directory') {
            steps {
                sh '''
                  set -e
                  echo "[DIR] Creating: ${DIR}"
                  mkdir -p "${DIR}"
                  ls -ld "${DIR}"
                '''
            }
        }

        stage('Create file (script)') {
            steps {
                sh '''
                  set -e
                  cat > "${FILE}" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from runme.sh"
echo "Folder name (F1) = ${F1:-N/A}"   # will show N/A unless you set F1
echo "Running as: $(whoami)"
echo "PWD: $(pwd)"
date
EOF
                  chmod +x "${FILE}"
                  ls -l "${FILE}"
                '''
            }
        }

        stage('Execute file') {
            steps {
                sh '''
                  set -e
                  "${FILE}" | tee "${DIR}/output.txt"
                '''
            }
        }

        stage('Set final permissions') {
            steps {
                sh '''
                  set -e
                  chmod 755 "${DIR}"
                  chmod 644 "${FILE}" "${DIR}/output.txt"
                  echo "[PERMS] Final:"
                  ls -ld "${DIR}"
                  ls -l "${DIR}"
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                  set -e
                  test -d "${DIR}"
                  test -f "${FILE}"
                  test -f "${DIR}/output.txt"
                  echo "DIR_MODE=$(stat -c '%a' "${DIR}")"
                  echo "FILE_MODE=$(stat -c '%a' "${FILE}")"
                  echo "OUT_MODE=$(stat -c '%a' "${DIR}/output.txt")"
                '''
            }
        }
    }

    post {
        always {
            // IMPORTANT: use DOUBLE quotes so ${params.s} expands
            archiveArtifacts artifacts: "${params.s}/**", allowEmptyArchive: false
            echo "Archived folder: ${params.s}"
        }
    }
}
