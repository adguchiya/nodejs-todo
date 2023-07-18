pipeline {
    agent any 

    stages{
        stage("git code"){
            steps{
                  echo "cloning code from git"
                  git url: "https://github.com/adguchiya/nodejs-todo.git" , branch: "main"
            }
        }

        stage("build the code"){
            steps{
                echo "build the code as docker image"
                sh "docker build -t new-todo:latest ."
            }    
        }

        stage("pushing code on docker hub"){
            steps{
                echo "pushing code on docker hub"
                withCredentials([
                    usernamePassword(
                        creadentialId: "dockerhub" ,
                        usernameVariable : "d_user" ,
                        passwordVariable : "d_pass" 
                    ){ 
                        sh "docker tag new-todo:latest  $d_user/new-todo:latest"
                        sh "docker login -u $d_user -p $d_pass"
                        sh "docker push $d_user/new-todo:latest"
                    }
                ])
            }
        }

        stage("deploy"){
            steps{
                echo "deploying code as a docker containter"
                sh "docker-compose down"
                sh "docker-compose up -d"
            }
        }
    }
}