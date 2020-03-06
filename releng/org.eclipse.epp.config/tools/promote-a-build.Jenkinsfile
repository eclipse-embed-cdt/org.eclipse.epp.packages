// Based on https://wiki.eclipse.org/Jenkins#Pipeline_job_without_custom_pod_template
pipeline {
  agent any
  tools {
    jdk 'openjdk11-latest'
  }
  parameters {
    booleanParam(defaultValue: true, description: 'Do a dry run of the build. Everything will be done except the final copy to download which will be echoed', name: 'DRY_RUN')
    string(defaultValue: 'committers cpp dsl java javascript jee modeling parallel php rcp rust scout testing', description: 'The packages to publish', name: 'PACKAGES')
    string(defaultValue: 'linux.gtk.x86_64.tar.gz macosx.cocoa.x86_64.dmg win32.win32.x86_64.zip', description: 'The platforms to publish', name: 'PLATFORMS')
    string(defaultValue: '2020-03-RC1', description: 'The release name. The last dash is replaced by a / and release is uploaded to https://download.eclipse.org/technology/epp/downloads/release/RELEASE', name: 'RELEASE')
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
