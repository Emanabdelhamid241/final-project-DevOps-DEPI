pipeline {
    agent any
    triggers {
        githubPush()
    }

    environment {
        DOCKER_REGISTRY = 'docker.io/emanabdelhamed241'
        NODE_IMAGE = "${DOCKER_REGISTRY}/node-app-final:latest"
        REACT_IMAGE = "${DOCKER_REGISTRY}/react-app-final:latest"
        // KUBECONFIG = '/path/to/.kube/config'
        ANSIBLE_INVENTORY = 'ansible/inventories/hosts.yaml'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Node.js Docker Image') {
            steps {
                script {
                    docker.build("${NODE_IMAGE}", './backend')
                }
            }
        }

        stage('Build React Docker Image') {
            steps {
                script {
                    docker.build("${REACT_IMAGE}", './frontend')
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
                        docker.image("${NODE_IMAGE}").push()
                        docker.image("${REACT_IMAGE}").push()
                    }
                }
            }
        }

        // stage('Deploy to Kubernetes via Ansible') {
        //     steps {
        //         ansiblePlaybook(
        //             playbook: 'ansible/playbooks/deploy-app.yaml',
        //             inventory: ANSIBLE_INVENTORY,
        //             extras: "-e 'nodejs_image=${NODE_IMAGE} react_image=${REACT_IMAGE}'"
        //         )
        //     }
        // }
    }

    post {
        always {
            cleanWs()
        }
        success {
        slackSend color: 'good', message: 'build success '
        }
        failure {
        slackSend color: 'denger', message: 'build failed'
        }
    }
}
