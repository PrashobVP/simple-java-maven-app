pipeline {
    agent any

    tools {
        maven 'maven'  // Ensure 'maven' is defined in Jenkins
    }

   
    stages {
        stage('SCM') {
            steps {
                echo 'Fetching the code'
                git changelog: false, poll: false, url: 'https://github.com/PrashobVP/simple-java-maven-app'
            }
        }

        stage('Install Trivy') {
            steps {
                echo 'Installing Trivy'
                sh '''
                    mkdir -p $HOME/bin
                    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b $HOME/bin
                    export PATH=$HOME/bin:$PATH
                '''
            }
        }

        stage("Trivy: Filesystem scan") {
            steps {
                echo 'Running Trivy scan'
                sh 'trivy filesystem --exit-code 1 --severity HIGH,CRITICAL .'
            }
        }

        stage('Dependency-Check') {
            steps {
                dependencyCheck additionalArguments: '--scan . --out .', odcInstallation: 'OWASP'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('Sonar') {
                    sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=Java-Prod'
                }
            }
        }

        stage("SonarQube: Code Quality Gates") {
            steps {
                script {
                    timeout(time: 1, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('BUILD') {
            steps {
                echo 'Building the project'
                sh 'mvn clean install'
            }
        }

        stage('TEST') {
            steps {
                echo 'Testing the project'
                sh 'mvn test'
            }
        }

        

        stage('BUILD Docker IMAGE') {
            steps {
                echo 'Building the Docker Image'
                script {
                    sh 'docker --version'
                    sh "docker build -t ponnu2014/javak8s ."
                }
            }
        }

        stage('PUSH TO Docker HUB') {
            steps {
                echo 'Pushing the docker images to Docker Hub'
                script {
                    sh 'docker login -u ponnu2014 -p *****'
                    sh 'docker push ponnu2014/javak8s'
                }
            }
        }
    }

    post {
        always {
            dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        }
    }
}


