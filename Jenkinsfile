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
                sh "docker build -t todo-node:latest ."
            }
        }
        
        stage("push to dh") {
            steps {
                echo "Pushing the Docker image to Docker Hub"
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker tag todo-node ${DOCKER_USERNAME}/todo-node:latest"
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    sh "docker push ${DOCKER_USERNAME}/todo-node:latest"
                }
            }
        }
        
        stage("deploy") {
            steps {
                echo "Deploying the Docker container"
                sh "docker-compose down"
                sh "docker-compose up -d --force-recreate --no-deps --build web"
            }
        }
        
        stage("SonarQube Analysis") {
            steps {
                echo "Running SonarQube analysis with Docker"
                withEnv(["SONAR_HOST_URL=http://172.17.0.1:9000",
                         "SONAR_PROJECT_KEY=todoapp",
                         "SONAR_TOKEN=sqa_7cdbd4c459d60f6ee360c2dde16bc566dca70ff4",
                         "SONAR_SCANNER_OPTS=-Dsonar.projectKey=todoapp"]) {
                    sh "docker run --rm \
                         -e SONAR_HOST_URL=${SONAR_HOST_URL} \
                         -e SONAR_SCANNER_OPTS=${SONAR_SCANNER_OPTS} \
                         -e SONAR_TOKEN=${SONAR_TOKEN} \
                         -v /var/lib/jenkins/workspace/todoapp:/usr/src \
                         sonarsource/sonar-scanner-cli"
                }
            }
        }
    }
}
