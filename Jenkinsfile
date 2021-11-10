def SLACK_ID

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

        stage('Deploy app to test namespace') {
            steps{
            sh "helm upgrade --install ${CHART_NAME} ${CHART_PATH}/ -n ${NAMESPACE_TEST} --create-namespace -f ${CHART_PATH}/${VALUES_TEST} --set image.tag=${DOCKER_TAG}"
            }
          }
        
        stage('Test app in test namespace') {
            steps{
			      sh ('''#!/bin/bash
            sleep 15
            status_app_test=$(curl -o /dev/null  -s  -w "%{http_code}"  http://10.10.18.158:30000)
	          if [[ $status_app_test == 200 ]]; then
	            curl -X POST -H 'Content-type: application/json' --data '{"text":"SERVICE http://tms.exam:30000 AVAILABLE IN TEST NAMESPACE"}' ${SLACK_ID}
	          else
	            curl -X POST -H 'Content-type: application/json' --data '{"text":"SERVICE http://tms.exam:30000 IS UNAVAILABLE IN TEST NAMESPACE"}' ${SLACK_ID}
	          fi
            ''')
            }
        }
  }
}