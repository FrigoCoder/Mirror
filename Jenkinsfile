pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        timestamps()
    }
    parameters {
        string(name: "Source", defaultValue: "C:", description: "Source drive")
        string(name: "Target", defaultValue: "D:", description: "Target drive")
        string(name: "Shadow", defaultValue: "E:", description: "Shadow drive")
    }
    triggers {
        cron("0 4 * * *")
    }
    stages {
        stage("Mirror") {
            steps {
                powershell "Set-PSDebug -Trace 1"
                powershell ".\\Mirror.ps1 ${params.Source} ${params.Target} ${params.Shadow} -Verbose"
            }
        }
    }
}
