pipeline {
    agent any
    environment {
        SONAR_TOKEN = credentials('sonar-token')
        SONAR_HOST_URL = credentials('sonar-host-url')
        DOCKER_USERNAME = credentials('docker-username')
        DOCKERHUB_PASS = credentials('dockerhub-pass')
        GIT_TOKEN = credentials('git-token')
    }
    stages {
        stage('Security Scan') {
            steps {
                script {
                    // Checkout code
                    checkout scm

                    // Install Java
                    sh """
                        sudo apt-get update -y
                        sudo apt-get install -y openjdk-21-jdk
                    """

                    // OWASP Dependency Check
                    sh 'dependency-check.sh --project "Call_Booking_app" --scan . --format HTML --out reports --failOnCVSS 7 --enableRetired'
                    archiveArtifacts artifacts: 'reports/dependency-check-report.html', allowEmptyArchive: true

                    // Trivy filesystem scan
                    sh 'trivy fs --ignore-unfixed --format sarif --output trivy-results.sarif --severity CRITICAL .'
                }
            }
        }
        
        stage('Build and Push') {
            steps {
                script {
                    // Checkout code
                    checkout scm

                    // Docker build
                    sh 'docker build -t vote ./vote'

                    // Trivy image scan
                    catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                        sh 'trivy image --ignore-unfixed --format table --exit-code 1 --severity CRITICAL,HIGH vote'
                    }

                    // Docker push
                    withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh """
                            docker login -u $DOCKER_USERNAME -p $DOCKERHUB_PASS
                            docker tag vote $DOCKER_USERNAME/vote:v${BUILD_NUMBER}
                            docker push $DOCKER_USERNAME/vote:v${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Checkout code
                    checkout scm

                    // Update manifest
                    sh """
                        sed -i 's|image:.*|image: ${DOCKER_USERNAME}/vote:v${BUILD_NUMBER}|g' k8s-specifications/vote-deployment.yaml
                        git config user.email "jenkins@example.com"
                        git config user.name "Jenkins"
                        git commit -a -m "Updated the Image tag to ${BUILD_NUMBER}"
                    """

                    // Push changes
                    withCredentials([usernamePassword(credentialsId: 'git-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                        sh 'git push https://${GIT_USER}:${GIT_TOKEN}@github.com/your-repo.git HEAD:${GIT_BRANCH}'
                    }

                    // Kubernetes deploy (assuming kubeconfig is available)
                    sh 'kubectl apply -f k8s-specifications/'
                }
            }
        }
    }
    post {
        always {
            // Cleanup workspace
            deleteDir()
        }
    }
}