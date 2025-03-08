pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage("Pull SRC") {
            steps {
                git 'https://github.com/archu0/Business.git'
            }
        }
        stage("Prepare Build") {
            steps {
                sh 'mvn clean package'
            }
        }
        stage("Copy *.war file to ansible") {
            steps {
                sh 'mv target/Business.war .'
                sshPublisher(
                    continueOnError: false, 
                    failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                            configName: "marcos",
                            transfers: [sshTransfer(sourceFiles: 'Business.war')],
                            verbose: true
                        )
                    ]
                )
            }
        }
        stage("Copy Docker file to ansible") {
            steps {
                sshPublisher(
                    continueOnError: false, 
                    failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                            configName: "marcos",
                            transfers: [
                                sshTransfer(sourceFiles: 'Dockerfile'),
                                sshTransfer(execCommand: "docker rm -f tomcat; docker rmi marcos; docker build -t marcos .; docker run -it -d -p 8081:8080 --name tomcat marcos")
                            ],
                            verbose: true
                        )
                    ]
                )
            }
        }
        stage("Build image and push to dockerhub") {
            steps {
                sshPublisher(
                    continueOnError: false, 
                    failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                            configName: "marcos",
                            transfers: [
                                sshTransfer(sourceFiles: 'Dockerfile'),
                                sshTransfer(execCommand: """
                                docker rm -f tomcat
                                docker rmi -f marcos
                                docker build -t newimage .
                                docker tag newimage archu09/business
                                docker push archu09/business
                                """)
                            ],
                            verbose: true
                        )
                    ]
                )
            }
            }
         stage("Copy playbook file to ansible and execute") {
            steps {
               
                sshPublisher(
                    continueOnError: false, 
                    failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                            configName: "marcos",
                            transfers: [
                                sshTransfer(sourceFiles: 'play.yml'),
                                sshTransfer(execCommand: "ansible-playbook play.yml")
                            ],
                            verbose: true
                        )
                    ]
                )
            
            }
        }
        
    }
}
