pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }
    
    environment {
        // 👇 Updated with your Docker Hub repo path
        DOCKER_IMAGE = 'ashrefg/project_pipeline'  // Format: <dockerhub-username>/<repo-name>
        KUBE_CONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/AshrefG/java-spring-devops.git'
                script {
                    env.VERSION = sh(script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout", returnStdout: true).trim()
                }
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Build Docker Image') {
	    steps {
		script {
		    // Convert version to lowercase for Docker Hub compatibility
		    def dockerTag = env.VERSION.toLowerCase()
		    docker.build("ashrefg/project_pipeline:${dockerTag}")
		}
	    }
	}

	stage('Push Docker Image') {
	    steps {
		script {
		    def dockerTag = env.VERSION.toLowerCase()
		    docker.withRegistry('https://docker.io', 'docker-hub-repo') {
		        docker.image("ashrefg/project_pipeline:${dockerTag}").push()
		    }
		}
	    }
	}
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    ansiblePlaybook(
                        playbook: 'ansible/playbook.yaml',
                        inventory: 'ansible/inventory',
                        extras: "-e 'image_version=${env.VERSION}'"
                    )
                }
            }
        }
    }
    
    post {
        failure {
            echo "Build Failed: ${env.JOB_NAME} ${env.BUILD_NUMBER} (${env.BUILD_URL})"
        }
        success {
            echo "Build Succeeded: ${env.JOB_NAME} ${env.BUILD_NUMBER} (${env.BUILD_URL})"
        }
    }
}
