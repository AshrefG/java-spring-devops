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
		    // Ensure lowercase tag
		    def dockerTag = env.VERSION.toLowerCase()
		    
		    // Log in fresh (avoid cached creds)
		    withCredentials([usernamePassword(
		        credentialsId: 'docker-hub-repo',
		        usernameVariable: 'DOCKER_USER',
		        passwordVariable: 'DOCKER_PASS'
		    )]) {
		        sh """
		            docker logout docker.io
		            echo "\${DOCKER_PASS}" | docker login -u "\${DOCKER_USER}" --password-stdin docker.io
		            docker push ashrefg/project_pipeline:${dockerTag}
		        """
		    }
		}
	    }
	}

	stage('Deploy to Kubernetes') {
	    steps {
		script {
		    // Install Ansible if missing (optional)
		    sh '''
		        if ! command -v ansible-playbook &> /dev/null; then
		            echo "Installing Ansible..."
		            sudo apt update && sudo apt install -y ansible || sudo yum install -y ansible
		        fi
		    '''
		    // Run playbook
		    sh 'ansible-playbook ansible/playbook.yaml -i ansible/inventory -e "image_version=${env.VERSION}"'
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
