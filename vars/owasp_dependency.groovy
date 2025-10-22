def call(String installationName = 'OWASP'){
  dependencyCheck additionalArguments: '--scan ./', odcInstallation: installationName
  dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
}
