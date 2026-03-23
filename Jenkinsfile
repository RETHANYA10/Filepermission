pipeline {
    agent any

    parameters {
        string(name: 's', defaultValue: 'f1', description: 'Folder name (f1 = foldername)')
    }

    environment {
        F1   = "${params.s}"                                  // folder name from parameter
        DIR  = "${env.WORKSPACE}/${params.s}"                 // workspace/<f1>
        FILE = "${env.WORKSPACE}/${params.s}/runme.sh"        // script file
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
echo "Folder name (F1) = ${F1}"
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
            archiveArtifacts artifacts: '${s}/**', allowEmptyArchive: true
        }
    }
}

