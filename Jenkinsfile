pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = "us-east-1"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Nitesh0815/terraform-jenkins-eks.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('EKS') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('EKS') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('EKS') {
                    sh 'terraform plan'
                }
                input(message: "Are you sure to proceed", ok: "Proceed")
            }
        }

        stage('Create / Destroy an EKS Cluster') {
            steps {
                dir('EKS') {
                    sh 'terraform $action -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo '✅ EKS Cluster created successfully!'
        }
        failure {
            echo '❌ Something went wrong. Check the logs.'
        }
    }
}