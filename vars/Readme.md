# Jenkins Shared Library — vars Directory

This README documents the contents and usage of the `vars/` folder in this repository. The `vars/` directory contains simple global pipeline steps (Groovy scripts) exposed to Jenkins Pipelines as single-step functions.

## Purpose
- Provide reusable pipeline steps (utility helpers) for building, scanning, and publishing artifacts.
- Keep pipeline code DRY and easier to maintain.
- Designed to be consumed from a Pipeline via `@Library` or a globally-configured shared library.

## Files in this folder
- `docker_push.groovy` — Helper to authenticate to Docker registry and push an image.
- `owasp_dependency.groovy` — Wrapper around the OWASP Dependency-Check Jenkins plugin to run scans and publish reports.
- `Readme.md` — This file.

## Usage
Import the shared library in your Jenkinsfile. Example if library is named `devsecops-end-to-end` and is available to the job:

Declarative example:
```groovy
@Library('devsecops-end-to-end') _
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t myapp:1.0 .'
      }
    }

    stage('Push Image') {
      steps {
        // params: Project, ImageTag, credsId (optional, defaults to 'docker')
        docker_push('myapp', '1.0', 'dockerhub-creds')
      }
    }

    stage('Dependency Scan') {
      steps {
        // params: installationName (optional), scanPath (optional), reportPattern (optional)
        owasp_dependency('OWASP', './', '**/dependency-check-report.xml')
      }
    }
  }
}
```

Scripted pipeline example:
```groovy
@Library('devsecops-end-to-end') _
node {
  stage('Build') {
    sh 'docker build -t myapp:1.0 .'
  }

  stage('Push') {
    docker_push('myapp', '1.0', 'dockerhub-creds')
  }

  stage('Scan') {
    owasp_dependency('OWASP', './', '**/dependency-check-report.xml')
  }
}
```

## Function details

### docker_push
Signature examples (depending on implementation version in repo):
- def call(String Project, String ImageTag, String dockerhubuser, String credsId = 'docker')
- Recommended: def call(String Project, String ImageTag, String credsId = 'docker')

Behavior:
- Logs in to Docker using Jenkins Credentials (username/password).
- Pushes image `${DOCKER_USER}/${Project}:${ImageTag}`.
Important:
- Use a credentialsId (e.g. `dockerhub-creds`) configured in Jenkins Credentials.
- Prefer implementations that use `--password-stdin` to avoid leaking passwords on the command line.

Example:
```groovy
docker_push('frontend', 'v1.2.3', 'dockerhub-creds')
```

### owasp_dependency
Signature examples:
- def call(String installationName = 'OWASP', String scanPath = './', String reportPattern = '**/dependency-check-report.xml')

Behavior:
- Runs the OWASP Dependency-Check step pointing at `scanPath`.
- Publishes the XML report using the provided pattern.

Example:
```groovy
owasp_dependency('OWASP', './backend', '**/dependency-check-report.xml')
```

Notes:
- `installationName` must match the name of the Dependency-Check installation configured in Jenkins (if used).
- Ensure the Jenkins OWASP Dependency-Check plugin is installed and configured.

## Credentials & Security
- Configure credentials in Jenkins (Credentials → System → Global credentials).
- Use `username:password` type credentials and pass the credentials ID into `docker_push`.
- Do not hardcode usernames or passwords in the repository.
- The library should use secure methods (e.g. `--password-stdin`) to avoid exposing secrets.

## Testing Locally
- Unit-test library steps with the Jenkins Pipeline Unit framework or run minimal pipelines in a test Jenkins instance.
- Validate behavior by creating a job that imports the library and runs the example pipelines.

## Troubleshooting
- "command not found: docker" — ensure Jenkins agent has Docker and the Jenkins user can run Docker.
- Authentication failures — verify credential ID and that username/password are correct.
- Dependency-Check not found — install and configure the Jenkins OWASP Dependency-Check plugin and its tool installation (if needed).

## Contributing / Updating
- Update functions in `vars/` with clear signatures and default values.
- Add documentation here when adding/removing steps.
- Follow Jenkins Shared Library best practices: keep steps idempotent, avoid long-running blocking logic, and keep environment-specific details configurable.

## References
- Jenkins Shared Libraries: https://www.jenkins.io/doc/book/pipeline/shared-libraries/
- OWASP Dependency-Check Jenkins plugin: https://plugins.jenkins.io/dependency-check-jenkins-plugin/
- Best practices for credentials: https://www.jenkins.io/doc/book/using/remote-credentials/
