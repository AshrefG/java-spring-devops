pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }
    
    environment {
        DOCKER_REGISTRY = 'docker-hub-repo'
        KUBE_CONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/AshrefG/java-spring-devops.git'
                script {
                    env.VERSION = readMavenPom().getVersion()
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
                    docker.build("${env.DOCKER_REGISTRY}/java-spring-devops:${env.VERSION}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://${env.DOCKER_REGISTRY}", 'docker-creds') {
                        docker.image("${env.DOCKER_REGISTRY}/java-spring-devops:${env.VERSION}").push()
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
