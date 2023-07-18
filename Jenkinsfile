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
               
                echo "Deploying the Docker container"
               sh "docker-compose down"
               sh "docker-compose up -d"
            }
        }
        
     
   
    }
}
