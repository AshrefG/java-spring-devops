pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker-hub-repo'
        KUBE_CONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/AshrefG/java-spring-devops.git'
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
                    def version = readMavenPom().getVersion()
                    docker.build("${DOCKER_REGISTRY}/java-spring-devops:${version}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://${DOCKER_REGISTRY}', 'docker-creds') {
                        docker.image("${DOCKER_REGISTRY}/java-spring-devops:${version}").push()
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Use Ansible to deploy to Kubernetes
                    ansiblePlaybook(
                        playbook: 'ansible/playbook.yaml',
                        inventory: 'ansible/inventory',
                        extras: '-e "image_version=${version}"'
                    )
                }
            }
        }
        
        stage('Smoke Test') {
            steps {
                script {
                    // Simple curl test to verify deployment
                    sh '''
                        curl -s http://your-service-url/ | grep "Hello from Spring Boot"
                    '''
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
