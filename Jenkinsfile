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
            environment {
                KUBECONFIG = credentials('kubeconfig')
            }
            steps {
                echo "Deploying the Docker container"
                sh "kubectl config use-context minikube" // Optional if using a different context
                sh "kubectl delete deployment todo-deployment --ignore-not-found=true"
                sh "kubectl apply -f deployment.yml"
                sh "kubectl apply -f service.yml"
                sh "kubectl port-forward service/todo-service 8001:8001 &"
            }
        }

        stage("test") {
            steps {
                echo "Waiting for the service to be available"
                sh "sleep 10"
                echo "Accessing the service on localhost:8001"
                sh "curl http://localhost:8001"
            }
        }
    }
}
