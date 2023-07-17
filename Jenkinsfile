pipeline {
    agent any
    
    stages {
        stage("code") {
            steps {
                echo "Cloning the code"
                git url: "https://github.com/adguchiya/nodejs-todo.git", branch: "main"
            }
        }
        
        stage("build") {
            steps {
                echo "Building the Docker image"
                sh "docker build -t new-todo:latest ."
            }
        }
        
        stage("push to dh") {
            steps {
                echo "Pushing the Docker image to Docker Hub"
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker tag new-todo:latest ${DOCKER_USERNAME}/new-todo:latest"
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    sh "docker push ${DOCKER_USERNAME}/new-todo:latest"
                }
            }
        }
        
        stage("deploy") {
            steps {
                echo "Configuring kubeconfig"
                sh "cp /path/to/kubeconfig ~/.kube/config"
                
                echo "Deploying the Docker container"
                sh "kubectl apply -f deployment.yml"
                sh "kubectl apply -f service.yml"
                sh "kubectl port-forward service/new-todo 8001:8001 &"
                sh "sleep 5" // Wait for port forwarding to establish the tunnel
            }
        }
        
        stage("test") {
            steps {
                echo "Running tests"
                sh "npm install"
                sh "npm test"
            }
        }
        
        stage("cleanup") {
            steps {
                echo "Cleaning up"
                sh "kubectl delete -f service.yml"
                sh "kubectl delete -f deployment.yml"
                sh "killall kubectl" // Stop the port forwarding
            }
        }
    }
}
