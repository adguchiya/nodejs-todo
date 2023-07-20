pipeline {
    agent any 

    stages{
        stage("git code"){
            steps{
                echo "git cloning"
                git url : "https://github.com/adguchiya/nodejs-todo.git" , branch : "main"
            }
        }

        stage("build"){
            steps{
                echo "building the docker image"
                sh "docker build -t new-todo:latest"
            }
        }

        stage("push"){
            steps{
                echo "pushing docker image to docker hub"
                withcredentials([
                    usernamePassword(
                        credentialsId : "dockerhub" , 
                        usernameVariable : "username" ,
                        passwordVariable : "password"
                    )
                ]){
                    sh "docker tag new-todo:latest $username/new-todo:latest"
                    sh "docker login -u $username -p $password"
                    sh "docker push $username/new-todo:latest"
                }
            }    
        }

        stage("deploy"){
                steps{
                    echo "deploying image as a container"
                    sh "docker-compose  down"
                    sh "docker-compose up -d"
                }
            }
    }
}