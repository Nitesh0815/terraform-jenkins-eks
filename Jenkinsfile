pipeline {
    agent any
    
    // Define a parameter to choose the action (apply or destroy)
    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
    }
    
    environment {
        // Ensure 'AWS_ACCESS_KEY_ID' and 'AWS_SECRET_ACCESS_KEY' are set up 
        // as secret text credentials in Jenkins
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = "us-east-1"
    }
    
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/gauri17-pro/terraform-jenkins-eks.git']])
                }
            }
        }
        
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('EKS'){
                        // Initialise with explicit backend configuration
                        sh 'terraform init -backend-config=bucket="cicd-terraform-eks" -backend-config=key="eks/terraform.tfstate" -backend-config=region="us-east-1"'
                    }
                }
            }
        }
        
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('EKS'){
                        // Use -check for CI to ensure code style is correct
                        sh 'terraform fmt -check -recursive'
                    }
                }
            }
        }
        
        stage('Validating Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('EKS'){
                        // Create a plan file
                        sh "terraform plan -var-file=terraform.tfvars -out=tfplan"
                    }
                }
                // Interactive confirmation before proceeding to apply/destroy
                input(message: "Plan created. Proceed with ${params.action}?", ok: "Proceed")
            }
        }
        
        stage('Creating/Destroying an EKS Cluster'){
            when { 
                // Only run if apply or destroy is selected
                expression { params.action == 'apply' || params.action == 'destroy' } 
            }
            steps{
                script{
                    dir('EKS') {
                        if (params.action == 'apply') {
                            sh "terraform apply -auto-approve tfplan"
                        } else {
                            sh "terraform destroy -auto-approve"
                        }
                    }
                }
            }
        }
        
        stage('Deploying Nginx Application') {
            when { 
                // Only run if we are applying the infrastructure
                expression { params.action == 'apply' } 
            }
            steps{
                script{
                    // Update kubeconfig from the EKS directory
                    dir('EKS') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster --region us-east-1'
                    }
                    // Apply Kubernetes configurations
                    dir('EKS/ConfigurationFiles') {
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
    }
}