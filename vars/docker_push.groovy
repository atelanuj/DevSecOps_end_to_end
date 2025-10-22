def call(String Project, String ImageTag, String dockerhubuser, String credsId = 'docker'){
  withCredentials([usernamePassword(credentialsId: credsId, passwordVariable: 'dockerhubpass', usernameVariable: 'dockerhubuser')]) {
      sh "docker login -u ${dockerhubuser} -p ${dockerhubpass}"
  }
  sh "docker push ${dockerhubuser}/${Project}:${ImageTag}"
}
