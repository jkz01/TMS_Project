def SLACK_ID

pipeline {
    agent { node { label 'Ansible' } }
    parameters {
    string(name: 'PATH_DOCKERFILE', defaultValue: 'app/Dockerfile', description: '')
    string(name: 'IMAGE_NAME', defaultValue: 'project', description: '')
    string(name: 'USER_REPO', defaultValue: 'jkz01', description: '')
    string(name: 'NAMESPACE_TEST', defaultValue: 'test-namespace', description: '')
    string(name: 'NAMESPACE_PROD', defaultValue: 'prod-namespace', description: '')
    string(name: 'CHART_NAME', defaultValue: 'project', description: '')
    string(name: 'CHART_PATH', defaultValue: 'chart-app', description: '')
    string(name: 'VALUES_PROD', defaultValue: 'values_prod.yaml', description: '')
    string(name: 'VALUES_TEST', defaultValue: 'values_test.yaml', description: '')
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
            sh "sudo helm upgrade --install ${CHART_NAME} ${CHART_PATH}/ -n ${NAMESPACE_TEST} --create-namespace -f ${CHART_PATH}/${VALUES_TEST} --set image.tag=${DOCKER_TAG}"
            }
          }
        
        stage('Test app in test namespace') {
            steps{
			      sh ('''#!/bin/bash
            sleep 15
            status_app_test=$(curl -o /dev/null  -s  -w "%{http_code}"  http://project.silich:30030)
	          if [[ $status_app_test == 200 ]]; then
	            curl -X POST -H 'Content-type: application/json' --data '{"text":"SERVICE PORT 30030 UP"}' ${SLACK_ID}
	          else
	            curl -X POST -H 'Content-type: application/json' --data '{"text":"SERVICE PORT 30030 DOWN"}' ${SLACK_ID}
	          fi
            ''')
            }
        }

        stage('Approval deploy to prod') {
            steps {
              script {
                def userInput = input(id: 'confirm', message: 'Apply deploy to PROD?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Deploy to production?', name: 'confirm'] ])
                }
            }
        }

        stage('Deploy to prod ns') {
            steps{
            sh ('''#!/bin/bash
            helm upgrade --install ${CHART_NAME} ${CHART_PATH}/ -n ${NAMESPACE_PROD} --create-namespace -f ${CHART_PATH}/${VALUES_PROD} --set image.tag=${DOCKER_TAG}
            sleep 15
            status_app_prod=$(curl -o /dev/null  -s  -w "%{http_code}"  http://project.silich:30050)
	          if [[ $status_app_prod == 200 ]]; then
	            curl -X POST -H 'Content-type: application/json' --data '{"text":"SERVICE PORT 30050 UP"}' ${SLACK_ID}
	          else
	            curl -X POST -H 'Content-type: application/json' --data '{"text":"SERVICE PORT 30050 DOWN"}' ${SLACK_ID}
	          fi
            '''
          )
        }
      }
  }
}