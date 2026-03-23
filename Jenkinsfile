pipeline {
    agent any

    stages {
        stage('Create Directory') {
            steps {
                sh '''
                    #!/bin/bash
                    DIR_NAME="/home/administrator/mcet"

                    # Try to create directory
                    sudo mkdir -p "$DIR_NAME"

                    # Verify with sudo ls
                    if sudo test -d "$DIR_NAME"; then
                        echo "Directory created successfully: $DIR_NAME"
                    else
                        echo "Directory not created: $DIR_NAME"
                        exit 1
                    fi
                '''
            }
        }

        stage('Create File') {
            steps {
                sh '''
                    #!/bin/bash
                    DIR_NAME="/home/administrator/mcet"
                    FILE_NAME="$DIR_NAME/hello.sh"

                    if sudo test -d "$DIR_NAME"; then
                        echo '#!/bin/bash' | sudo tee "$FILE_NAME" > /dev/null
                        echo 'echo Hello from MCET!' | sudo tee -a "$FILE_NAME" > /dev/null
                        sudo chmod +x "$FILE_NAME"
                        echo "File created: $FILE_NAME"
                    else
                        echo "Directory not found: $DIR_NAME"
                        exit 1
                    fi
                '''
            }
        }

        stage('Execute File') {
            steps {
                sh '''
                    #!/bin/bash
                    FILE_NAME="/home/administrator/mcet/hello.sh"

                    if sudo test -f "$FILE_NAME"; then
                        sudo bash "$FILE_NAME"
                    else
                        echo "File not found: $FILE_NAME"
                        exit 1
                    fi
                '''
            }
        }

        stage('Change Permissions') {
            steps {
                sh '''
                    #!/bin/bash
                    DIR_NAME="/home/administrator/mcet"
                    FILE_NAME="$DIR_NAME/hello.sh"

                    if sudo test -f "$FILE_NAME"; then
                        sudo chmod 755 "$DIR_NAME"
                        sudo chmod 744 "$FILE_NAME"
                        echo "Permissions updated:"
                        sudo ls -l "$DIR_NAME"
                    else
                        echo "File not found, cannot change permissions."
                        exit 1
                    fi
                '''
            }
        }
    }
}
