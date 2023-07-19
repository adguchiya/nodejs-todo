pipeline {
    agent any 

    environment {
        PATH = "$PATH:/path/to/sonar-scanner-directory/bin"
    }

    stages {
        stage("git code") {
            steps {
                echo "Cloning code from git"
                git url: "https://github.com/adguchiya/nodejs-todo.git", branch: "main"
            }
        }

        stage("code quality") {
            steps {
                echo "Running SonarQube analysis"
                withSonarQubeEnv('SONARQUBE_HOME') {
                    sh "sonar-scanner"
                }
            }
        }

        stage("build the code") {
            steps {
                echo "Build the code as a docker image"
                sh "docker build -t new-todo:latest ."
            }
        }

        stage("pushing code on docker hub") {
            steps {
                echo "Pushing code on docker hub"
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
                echo "Deploying code as a docker container"
                sh "docker-compose down"
                sh "docker-compose up -d"
            }
        }
    }
}
