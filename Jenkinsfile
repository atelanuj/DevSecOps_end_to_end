pipeline {
	agent any
	options {
        quietPeriod(30) // wait 30 seconds before starting build
    }
	stages {
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
//
