pipeline {
    agent any 
    stages{
        stage("git code"){
            echo "code comming from git"
            git url: "https://github.com/adguchiya/nodejs-todo.git" , branch : "main"
        }

        stage("Build the code"){
            echo "build the code with docker"
            sh "docker build -t new-todo:latest ."
        }

        stage("pushing code in DockerHub"){
            echo "push code in docker hub"
            withCredentials([
                usernamePassword(
                    credentialId : "dockerhub" ,
                    usernameVariable : "d_user" , 
                    passwordVariable : "d_pass"
                )
            ])
            sh "docker tag new-todo:latest $d_user/new-todo:latest"
            sh "docker login -u $d_user  -p $d_pass"
            sh "docker push $d_user/new-todo:latest"

        }
        stage("deploy") {
            echo "deploy the docker hub image by running docker container"
            sh "docker-compose down"
            sh "docker-compose up -d"
        }
    }
}

