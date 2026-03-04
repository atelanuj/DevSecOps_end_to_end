
pipeline {
    agent any

    environment {
        SONAR_TOKEN     = credentials('SONAR_TOKEN')
        SONAR_HOST_URL  = credentials('SONAR_HOST_URL')
        GIT_TOKEN       = credentials('GIT_TOKEN')
        DOCKER_USERNAME = credentials('DOCKER_USERNAME')
        DOCKERHUB_PASS  = credentials('DOCKERHUB_PASS')
        GITHUB_TOKEN    = credentials('GITHUB_TOKEN') // for SonarQube scan if needed
        PASS = "sample@123"
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Determine Changed Application') {
            id 'setApp'
            steps {
                script {
                    def changedFiles = sh(script: "git diff --name-only HEAD^ HEAD", returnStdout: true).trim()
                    if (changedFiles =~ /^vote\//) {
                        env.APP = 'vote'
                    } else if (changedFiles =~ /^worker\//) {
                        env.APP = 'worker'
                    } else if (changedFiles =~ /^result\//) {
                        env.APP = 'result'
                    } else {
                        env.APP = 'none'
                    }
                    echo "Changed APP: ${env.APP}"
                }
            }
        }

        stage('Security Scan') {
            when {
                expression { env.APP != 'none' }
            }
            steps {
                script {
                    // Java installation assumed available on agent
                    echo "Running SonarQube scan for ${env.APP}"
                    withSonarQubeEnv('SonarQubeServer') {
                        sh "sonar-scanner -Dsonar.projectKey=${env.APP} -Dsonar.sources=. -Dsonar.host.url=${SONAR_HOST_URL} -Dsonar.login=${SONAR_TOKEN}"
                    }

                    timeout(time: 8, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: false
                    }

                    echo "Running Datree policy check (non-blocking)"
                    sh "datree test k8s --only-k8s-files || true"

                    echo "Running OWASP Dependency Check (non-blocking)"
                    sh '''
                        dependency-check.sh \
                          --project "Call_Booking_app" \
                          --scan . \
                          --format HTML \
                          --out reports \
                          --failOnCVSS 7 \
                          --enableRetired || true
                    '''
                    archiveArtifacts artifacts: 'reports/dependency-check-report.html', allowEmptyArchive: true

                    echo "Running Trivy FS scan (non-blocking)"
                    sh "trivy fs . --ignore-unfixed --format sarif --output trivy-results.sarif --severity CRITICAL || true"
                }
            }
        }

        stage('Build and Push Docker Image') {
            when {
                expression { env.APP != 'none' }
            }
            steps {
                script {
                    docker.withRegistry('', 'docker-hub') {
                        sh """
                            echo "Building Docker image for ${env.APP}"
                            docker build -t ${env.APP} ./${env.APP}
                            
                            echo "Scanning Docker image using Trivy"
                            trivy image ${env.APP} --format table --exit-code 1 --ignore-unfixed --vuln-type os,library --severity CRITICAL,HIGH || true
                            
                            echo "Tagging and pushing Docker image"
                            docker tag ${env.APP} ${DOCKER_USERNAME}/${env.APP}:v${env.BUILD_NUMBER}
                            docker login -u ${DOCKER_USERNAME} -p ${DOCKERHUB_PASS}
                            docker push ${DOCKER_USERNAME}/${env.APP}:v${env.BUILD_NUMBER}
                        """
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                expression { env.APP != 'none' }
            }
            steps {
                script {
                    echo "Updating Kubernetes manifests with new image tag"
                    sh """
                        sed -i 's|image:.*|image: ${DOCKER_USERNAME}/${APP}:v${BUILD_NUMBER}|' k8s-specifications/${APP}-deployment.yaml
                        git config user.email "jenkins@automation.com"
                        git config user.name "jenkins"
                        git pull
                        git commit -am "Updated image tag to v${BUILD_NUMBER}"
                        git push https://x-access-token:${GIT_TOKEN}@github.com/<owner>/<repo>.git HEAD:${env.BRANCH_NAME}
                    """

                    echo "Deployed ${APP} to Kubernetes"
                    // You can call kubectl apply here if desired
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed for APP: ${env.APP}"
        }
        success {
            echo "Pipeline completed successfully for APP: ${env.APP}"
        }
    }
}
