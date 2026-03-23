pipeline {
    agent any

    stages {
        stage('Create directory') {
            steps {
                sh '''
                    set -e
                    echo "Workspace: $WORKSPACE"
                    mkdir -p "$WORKSPACE/mydir"
                    echo "Created directory: $WORKSPACE/mydir"
                '''
            }
        }

        stage('Create file (script)') {
            steps {
                sh '''
                    set -e
                    cat > "$WORKSPACE/mydir/runme.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from runme.sh"
echo "I am running from: $(pwd)"
date
EOF
                    echo "Created script: $WORKSPACE/mydir/runme.sh"
                '''
            }
        }

        stage('Execute file') {
            steps {
                sh '''
                    set -e
                    chmod +x "$WORKSPACE/mydir/runme.sh"
                    "$WORKSPACE/mydir/runme.sh"
                '''
            }
        }

        stage('Set permissions (after execution)') {
            steps {
                sh '''
                    set -e
                    # Directory readable and traversable by others, script readable by others
                    chmod 755 "$WORKSPACE/mydir"
                    chmod 644 "$WORKSPACE/mydir/runme.sh"
                    echo "Final permissions:"
                    ls -l "$WORKSPACE/mydir"
                '''
            }
        }
    }
}
