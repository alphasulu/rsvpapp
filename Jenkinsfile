stage('test') {  
    node ('docker-jenkins-slave'){    
        checkout scm    
        sh 'chmod a+x ./run_test.sh'   
        sh './run_test.sh'
    }
}

node() {
    checkout scm
    stage('build the image') {
        withDockerServer([credentialsId: 'dockerhost', uri: "tcp://${DOCKERHOST}:2376"]) {
            docker.build 'akhamsa/rsvpapp:mooc'
        }
    }
    
    stage('push the image to DockerHub') {
        withDockerServer([credentialsId: 'dockerhost', uri: "tcp://${DOCKERHOST}:2376"]) {
            withDockerRegistry([credentialsId: 'dockerhub_auth']) {
                docker.image('akhamsa/rsvpapp:mooc').push()
            }
        }
    }
    
    stage('deploy the image to staging server') {
        withDockerServer([credentialsId: 'staging remote connection', uri: "tcp://${STAGEHOST}:2376"]){
            sh 'docker-compose pull'
            sh 'docker-compose -p rsvp_staging up -d'
    }
    input "Check application running at http://${STAGEHOST}:5000 Looks good?"
        withDockerServer([credentialsId: 'staging remote connection', uri:"tcp://${STAGEHOST}:2376"]) {
            sh 'docker-compose -p rsvp_staging down -v'
        }
    }
    
    stage('deploy in production'){
        withDockerServer([credentialsId: 'production', uri:
        "tcp://${DEPLOYHOST}:2376"]) {
        sh 'docker stack deploy -c docker-stack.yaml myrsvpapp'
        }
        input "Check application running at http://${DEPLOYHOST}:5000"
        withDockerServer([credentialsId: 'production', uri:
        "tcp://${DEPLOYHOST}:2376"]) {
        sh 'docker stack down myrsvpapp'
        }
    }
}