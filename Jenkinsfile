@Library("Shared") _
pipeline {
	agent any
	options {
        quietPeriod(5) // wait 30 seconds before starting build
    }
	stages {
		stage('HELLO') {
			steps {
				script {
					hello('Anuj')
				}
			}
		}
		stage('BUILD') {
			steps{
				echo "BUILDING..."
			}
		}
		stage('TEST') {
			steps{
				echo "Testing.."
			}
		}
		stage('DEPLOYING') {
			steps{
				echo "Deploying..."
			}
		}
		stage('CONFIGURING') {
			steps{
				echo "Configuring..."
			}
		}
	}
}
///
