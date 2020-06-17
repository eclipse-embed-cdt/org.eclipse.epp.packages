// Based on https://wiki.eclipse.org/Jenkins#Pipeline_job_without_custom_pod_template
pipeline {
  agent any
  tools {
    jdk 'openjdk11-latest'
  }
  parameters {
    booleanParam(defaultValue: true, description: 'Do a dry run of the build. Everything will be done except the final copy to download which will be echoed', name: 'DRY_RUN')
    string(defaultValue: '2020-09', description: 'The release name. Release is uploaded to https://download.eclipse.org/technology/epp/downloads/release/RELEASE_NAME', name: 'RELEASE_NAME')
    string(defaultValue: 'M3', description: 'The name of the milestone, e.g. M1, M2, M3, RC1 or R', name: 'RELEASE_MILESTONE')
    string(defaultValue: 'M3', description: 'The name of the directory to place the release, generally the same as RELEASE_MILESTONE except for R builds when it should be RC2 (or RC2a, etc for respins)', name: 'RELEASE_DIR')
    string(defaultValue: '12345', description: 'The CI build number being promoted from of job simrel.epp-tycho-build', name: 'BUILD_NUMBER')
  }
  options {
    timestamps()
    disableConcurrentBuilds()
  }
  stages {
    stage('Upload') {
      steps {
        // XXX: When EPP is moved to JIRO we need sshagent
         sh './releng/org.eclipse.epp.config/tools/promote-a-build.sh'
      }
    }
  }
  post {
    always {
      // We have a sleep as a post action to keep the
      // workspace around so it can be examined - very
      // useful on DRY_RUN builds to examine the
      // workspace to see if content is right, or to
      // examine a broken build.
      // It does mean however that the build needs to
      // cancelled manually
      sh 'sleep 1d'
    }
    cleanup {
      cleanWs()
    }
  }
}
