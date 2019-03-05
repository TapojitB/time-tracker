pipeline {
    agent any	
    tools {
        maven 'localMaven'
    }	
    stages {
       stage('Initialize') {
            steps {
                echo 'Initializing..'
            }
        }
        stage('Build') {
            steps {
				echo 'Building..'		
				bat 'mvn clean package' 
		        bat "docker stop demo-webapp-staging demo-webapp-production"
		        bat "docker rm demo-webapp-staging demo-webapp-production"
				bat "docker image build -t tapojitb/demo-webapp:${env.BUILD_ID} ."		    	
		    	bat "docker container run -d  --name demo-webapp-staging -p 8383:8080 tapojitb/demo-webapp:${env.BUILD_ID}"		     	
		    	bat "docker container run -d  --name demo-webapp-production -p 8484:8080 tapojitb/demo-webapp:${env.BUILD_ID}"
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
		stage ('Deployments'){
			parallel{
				stage ('Static analysis'){
					steps {
						echo 'Running Checkstyle....'
						//build job: 'static analysis'

					}
				}

				stage ("Deploy to Staging"){
					steps {
						echo 'Deploying to staging environment....'
						build job: 'deploy-demo-to-staging'

						}
				 post {
						success {
							echo 'Demo code deployed to Staging.'
						}

						failure {
							echo ' Deployment of demo in Staging failed.'
						}
					}

					}
				}
			}		
			stage ('Deploy to Production'){
					steps{
						timeout(time:5, unit:'DAYS'){
							input message:'Approve PRODUCTION Deployment?'
						}

						build job: 'deploy-demo-to-Production'
					}
					post {
						success {
							echo 'Demo code deployed to Production.'
						}

						failure {
							echo ' Deployment of demo in Production failed.'
						}
					}
				}
		
		}
}
