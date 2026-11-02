pipeline {
  agent { label 'generic' }

  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }

  stages {
    stage('betterleaks') {
      agent { label 'betterleaks' }
      steps {
        withChecks('betterleaks') {
          sh 'betterleaks git . --redact --no-banner --verbose'
        }
      }
    }

    stage('shell') {
      steps {
        withChecks('shell') {
          sh 'scripts/tests/shell.sh'
        }
      }
    }

    stage('ansible-code-check') {
      steps {
        withChecks('ansible-code-check') {
          sh './scripts/install.sh'
          sh 'scripts/tests/ansible/lint.sh'
          sh 'scripts/tests/ansible/syntax.sh'
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
