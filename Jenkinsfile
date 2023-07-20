pipeline {
    agent any 

    stages{
        stage(" gitCode"){
            steps{
                echo "cloning code from git"
                git url : "https://github.com/adguchiya/nodejs-todo.git" , branch : "main"
            }
        }

        stage("dockerBuildImage"){
            steps{
                echo "building the image by using docker image"
                sh "docker build -t  new-todo:latest ."
            }
        }

        stage("pushCodeToDockerHub"){
            steps{
                echo "pushing code to docker hub"
                withCredentials([
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

            stage("deployAsDockerContainer"){
                steps{
                    sh "docker-compose down"
                    sh "docker-compose up -d"
                }
            }
    }
}