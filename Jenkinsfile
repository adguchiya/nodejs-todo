pipeline {
    agent any
    stages {
        stage("git code") {
            steps {
                echo "code coming from git"
                git url: "https://github.com/adguchiya/nodejs-todo.git", branch: "main"
            }
        }

        stage("Build the code") {
            steps {
                echo "build the code with docker"
                sh "docker build -t new-todo:latest ."
            }
        }

        stage("pushing code in DockerHub") {
            steps {
                echo "push code to Docker Hub"
                withCredentials([
                    usernamePassword(
                        credentialsId: "dockerhub",
                        usernameVariable: "d_user",
                        passwordVariable: "d_pass"
                    )
                ]) {
                    sh "docker tag new-todo:latest $d_user/new-todo:latest"
                    sh "docker login -u $d_user -p $d_pass"
                    sh "docker push $d_user/new-todo:latest"
                }
                  
                
            }
        }

        stage("deploy") {
            steps {
                echo "deploy the Docker Hub image by running a Docker container"
                sh "docker-compose down"
                sh "docker-compose up -d"
            }
        }
    }
}
