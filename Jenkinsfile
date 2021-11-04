pipeline {
    agent { node { label 'Ansible' } }
    parameters {
    string(name: 'PATH_DOCKERFILE', defaultValue: 'app/Dockerfile', description: '')
    string(name: 'IMAGE_NAME', defaultValue: 'project', description: '')
    string(name: 'USER_REPO', defaultValue: 'jkz01', description: '')
    }
    environment {
        registry = "jkz01/dos03"
        registryCredential = 'dockerhub_id_SA'
        dockerImage = ''
        DOCKER_TAG = "${GIT_COMMIT[0..5]}"
        APP_VERSION = "${DOCKER_TAG}"
    }
    options {
      ansiColor('xterm')
      timestamps () }

    stages{
        stage('Start Docker step') {
            steps {
                sh 'docker run --rm -i hadolint/hadolint < ${PATH_DOCKERFILE}'

              script {
              dockerImage = docker.build ("${USER_REPO}/${IMAGE_NAME}", "-f ${PATH_DOCKERFILE} .")
              }

              script {
              docker.withRegistry( '', registryCredential ) {
              dockerImage.push("${DOCKER_TAG}")
              }

              sh "docker rmi ${USER_REPO}/${IMAGE_NAME}:${DOCKER_TAG}"

            }
          }
        }
  }
}