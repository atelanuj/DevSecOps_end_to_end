def call(Map config = [:]) {
    def projectName = config.projectName ?: 'Project'
    def imageName = config.imageName ?: ''
    def imageTag = config.imageTag ?: ''
    
    echo "Generating build report..."
    
    // Create directory for reports
    sh "mkdir -p reports"
    
    // Generate report
    sh """
        echo "===== ${projectName} Build Report =====" > reports/build-report.txt
        echo "Generated: \$(date)" >> reports/build-report.txt
        echo "" >> reports/build-report.txt
        echo "Build Number: ${env.BUILD_NUMBER}" >> reports/build-report.txt
        echo "Docker Images: ${imageName}" >> reports/build-report.txt
        echo "Image Tag: ${imageTag}" >> reports/build-report.txt
        echo "Build Status: ${currentBuild.result ?: 'SUCCESS'}" >> reports/build-report.txt
        echo "Build URL: ${env.BUILD_URL}" >> reports/build-report.txt
    """
    
    // Archive the report
    archiveArtifacts artifacts: 'reports/*', allowEmptyArchive: true
}
