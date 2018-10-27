pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        timestamps()
    }
    parameters {
        string(name: "SOURCE_DRIVE", defaultValue: "C:")
        string(name: "TARGET_DRIVE", defaultValue: "D:")
        string(name: "SHADOW_DRIVE", defaultValue: "E:")
    }
    triggers {
        cron("0 4 * * *")
    }
    stages {
        stage("Mirror") {
            steps {
                powershell "Set-PSDebug -Trace 1"
                powershell ".\\Mirror.ps1 ${params.SOURCE_DRIVE} ${params.TARGET_DRIVE} ${params.SHADOW_DRIVE} -Verbose"
            }
        }
    }
}
