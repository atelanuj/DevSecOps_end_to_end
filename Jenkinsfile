pipeline {
    agent any

    // tools {
    //     sonar "Sonar"
    //     owasp "OWASP"
    // }

    environment {
        SONAR_HOME = tool "Sonar"
    }

    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
    }

    stages {
        stage("Validate Parameters") {
            steps {
                script {
                    if (params.FRONTEND_DOCKER_TAG == '' || params.BACKEND_DOCKER_TAG == '') {
                        error("FRONTEND_DOCKER_TAG and BACKEND_DOCKER_TAG must be provided.")
                    }
                }
            }
        }
        stage("Git Checkout") {
            steps {
                git url: "https://github.com/atelanuj/DevSecOps_end_to_end.git", branch: "Wonder_lust_jenkins_end_to_end"
            }
        }
        stage("Trivy: Filesystem scan"){
            steps{
                sh "trivy fs ."
            }
        }
        stage("OWASP: Dependency Check") {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        // stage("SonarQube: Code Analysis"){
        //     steps{
        //         withSonarQubeEnv("Sonar"){
        //             sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName='wanderlust' -Dsonar.projectKey='wanderlust' -X"
        //         }
        //     }
        // }
        // stage("SonarQube: Code Quality Gates"){
        //     steps{
        //         timeout(time: 1, unit: "MINUTES"){
        //             waitForQualityGate abortPipeline: false
        //         } 
        //     }
        // }
        // stage("Docker: Login") {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'dockerhubpass', usernameVariable: 'dockerhubuser')]) {
        //             sh "docker login -u ${dockerhubuser} -p ${dockerhubpass}"
        //         }
        //     }
        // }
        stage("Docker: Build") {
            parallel {
                stage("Backend Image Build") {
                    steps {
                        sh 'whoami'
                        sh "docker build -t anujatel/wanderlust-backend-beta:${params.BACKEND_DOCKER_TAG} -f ./backend/Dockerfile ."
                        // script {
                        //     dockerImage_f = docker.build("registry.hub.docker.com/anujatel/wanderlust-backend-beta:${params.BACKEND_DOCKER_TAG}", "-f ./backend/Dockerfile")
                        // }
                    }
                }
                stage("Frontend Image Build") {
                    steps {
                        sh 'whoami'
                        sh "docker build -t anujatel/wanderlust-frontend-beta:${params.FRONTEND_DOCKER_TAG} -f ./frontend/Dockerfile ."
                        // script {
                        //     dockerImage_b = docker.build("registry.hub.docker.com/anujatel/wanderlust-frontend-beta:${params.FRONTEND_DOCKER_TAG}", "-f ./frontend/Dockerfile")
                        // }
                    }
                }
            }
        }
        stage("Docker: Push to DockerHub"){
            parallel {
                stage("Push Backend Image") {
                    steps {
                        script {
                            withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKERHUB_PASS', usernameVariable: 'DOCKERHUB_USER')]) {
                                // sh "echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin"
                                sh "docker login -u ${DOCKERHUB_USER} -p ${DOCKERHUB_PASS}"
                                sh "docker push anujatel/wanderlust-backend-beta:${params.BACKEND_DOCKER_TAG}"
                            }
                        }                     
                    }
                }
                stage("Push Frontend Image") {
                    steps {
                        script {
                            withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKERHUB_PASS', usernameVariable: 'DOCKERHUB_USER')]) {
                                // sh "echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin"
                                sh "docker login -u ${DOCKERHUB_USER} -p ${DOCKERHUB_PASS}"
                                sh "docker push anujatel/wanderlust-frontend-beta:${params.FRONTEND_DOCKER_TAG}"
                            }
                        }                    
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
