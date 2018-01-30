#!groovy

@Library('SovrinHelpers') _

def name = 'sovrin-genesis'

def getVersion() {
    version = ''
    stage('GetVersion') {
        node('ubuntu') {
            try {
                echo 'Get version'
                checkout scm

                ver = sh(returnStdout: true, script: "grep -E '^version =' ./sovrin/manifest.txt | head -n1 | cut -f2 -d= | cut -f2 -d '\"'").trim()
                patch = env.BUILD_NUMBER
                version = "${ver}.${patch}"
            }
            finally {
                echo 'Get version: Cleanup'
                step([$class: 'WsCleanup'])
            }
        }
    }

    return version
}

def buildDebUbuntu = { repoName, releaseVersion, sourcePath ->
    def volumeName = "${name}-deb-u1604"
    if (env.BRANCH_NAME != '' && env.BRANCH_NAME != 'master') {
        volumeName = "${volumeName}.${BRANCH_NAME}"
    }
    if (sh(script: "docker volume ls -q | grep -q '^$volumeName\$'", returnStatus: true) == 0) {
        sh "docker volume rm $volumeName"
    }
    dir('build-scripts/ubuntu-1604') {
        sh "./build-${name}-docker.sh \"$sourcePath\" $releaseVersion $volumeName"
    }
    return "$volumeName"
}


options = new TestAndPublishOptions()
options.enable([StagesEnum.PACK_RELEASE_COPY, StagesEnum.PACK_RELEASE_COPY_ST])
options.skip([StagesEnum.PYPI_RELEASE, StagesEnum.GET_RELEASE_VERSION])
options.setReleaseVersion(getVersion())
options.setCopyWithDeps(false)
testAndPublish(name, [ubuntu: [:]], true, options, [ubuntu: buildDebUbuntu])
