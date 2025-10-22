def call(String name = 'OWASP'){
  dependencyCheck additionalArguments: '--scan ./', odcInstallation: '${name}'
  dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
}
