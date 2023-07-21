pipeline {
    agent any 

    stages{
        stage("git code"){
            steps{
                echo "cloning the code from git"
                git url : "https://github.com/adguchiya/nodejs-todo.git" , branch : "main"
            }
        }

        stage("build"){
            steps{
                echo "building the docker image"
                sh "docker build -t new-todo:latest ."
            }
        }

        stage("push code on dockerhub"){
            steps{
                echo "pushing code on docker hub"
                withCreadentials([usernamePassword(credentialsId : "dockerhub" , usernameVariable : "username" , passwordVariable : "password")]){
                    sh "docker tag new-todo:latest $username/new-todo:latest"
                    sh "docker login -u $username -p $password"
                    sh "docker push $username/new-todo:latest"
                }
            }
        }

        stage("deploy"){
            echo "deploying docker image in docker container"
            sh "docker-compose down"
            sh "docker-compose up -d"
        }
    }
}