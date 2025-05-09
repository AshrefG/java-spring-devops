# Java Spring Boot DevOps Pipeline with Green-Blue Deployment

## Table of Contents
1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [Setup Instructions](#setup-instructions)
    - [Git Repository Setup](#git-repository-setup)
    - [Jenkins Configuration](#jenkins-configuration)
    - [Docker Setup](#docker-setup)
    - [Kubernetes Cluster Setup](#kubernetes-cluster-setup)
    - [Ansible Configuration](#ansible-configuration)
4. [Pipeline Walkthrough](#pipeline-walkthrough)
5. [Green-Blue Deployment Strategy](#green-blue-deployment-strategy)
6. [Troubleshooting](#troubleshooting)
7. [References](#references)

## Project Overview
This project demonstrates a complete CI/CD pipeline for a Java Spring Boot application using:
- Git for version control
- Jenkins for CI/CD automation
- Docker for containerization
- Ansible for configuration management
- Kubernetes for orchestration
- Green-blue deployment strategy for zero-downtime releases

![DevOps Pipeline](/images/devops-pipeline-overview.png)

## Prerequisites
Before starting, ensure you have these tools installed:

| Tool | Installation Guide | Documentation |
|------|--------------------|---------------|
| Git | [Git Installation](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) | [Git Docs](https://git-scm.com/doc) |
| Jenkins | [Jenkins Installation](https://www.jenkins.io/doc/book/installing/) | [Jenkins Docs](https://www.jenkins.io/doc/) |
| Docker | [Docker Installation](https://docs.docker.com/get-docker/) | [Docker Docs](https://docs.docker.com/) |
| Kubernetes | [Kubernetes Setup](https://kubernetes.io/docs/setup/) | [K8s Docs](https://kubernetes.io/docs/home/) |
| Ansible | [Ansible Installation](https://docs.ansible.com/ansible/latest/installation_guide/index.html) | [Ansible Docs](https://docs.ansible.com/) |
| Maven | [Maven Installation](https://maven.apache.org/install.html) | [Maven Docs](https://maven.apache.org/guides/) |

## Setup Instructions

### Git Repository Setup
![Git Workflow](/images/git-workflow.png)

1. Initialize your Git repository
2. Create the project structure
3. Set up branches (main, dev)

### Jenkins Configuration
![Jenkins Dashboard](/images/jenkins-dashboard.png)

1. Install required plugins:
    - Docker Pipeline
    - Kubernetes
    - Ansible
    - Blue Ocean (optional)
2. Set up credentials for:
    - Docker registry
    - Kubernetes cluster
    - Git repository

### Docker Setup
![Docker Build](/images/docker-build-output.png)

1. Build your Docker image
2. Configure Docker registry access
3. Test image locally

### Kubernetes Cluster Setup
![Kubernetes Cluster](/images/k8s-cluster-diagram.png)

1. Set up your cluster (Minikube or cloud provider)
2. Configure kubectl access
3. Verify cluster status

### Ansible Configuration
![Ansible Output](/images/ansible-playbook-output.png)

1. Create inventory file
2. Set up playbook for deployments
3. Test connection to Kubernetes cluster

## Pipeline Walkthrough
![Jenkins Pipeline](/images/jenkins-pipeline-stages.png)

Our Jenkins pipeline executes these stages:

1. **Checkout**: Pulls code from Git repository  
   `git branch: 'main', url: 'https://github.com/your-repo/java-spring-devops.git'`

2. **Build**: Compiles Java application  
   `mvn clean package`

3. **Test**: Runs unit tests  
   `mvn test`

4. **Dockerize**: Builds and pushes Docker image  
   `docker.build()`

5. **Deploy**: Uses Ansible to deploy to Kubernetes  
   `ansible-playbook playbook.yaml`

6. **Verify**: Smoke tests the deployment  
   `curl http://service-url/`

## Green-Blue Deployment Strategy
![Green-Blue Deployment](/images/green-blue-deployment.png)

Our deployment process:

1. Initial state: Blue deployment active
2. New version deployed to Green environment
3. Traffic shifted to Green after verification
4. Blue remains as fallback option

## Troubleshooting
![Troubleshooting Guide](/images/troubleshooting-cheatsheet.png)

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Docker build fails | Check Dockerfile syntax and build context |
| Kubernetes pods not starting | Verify resource limits and image pull secrets |
| Ansible connection refused | Check inventory file and SSH configuration |
| Pipeline fails at test stage | Review unit test output in Jenkins console |

## References
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Kubernetes Deployment Strategies](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Ansible Kubernetes Module](https://docs.ansible.com/ansible/latest/collections/community/kubernetes/k8s_module.html)
