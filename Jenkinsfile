pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        timestamps()
    }
    parameters {
        string(name: "Source", defaultValue: "C:", description: "Source drive")
        string(name: "Target", defaultValue: "D:", description: "Target drive")
        string(name: "Shadow", defaultValue: "B:", description: "Shadow drive")
    }
    triggers {
        cron("0 4 * * *")
    }
    stages {
        stage("Mirror") {
            steps {
                bat "where powershell"
                ps ".\\Mirror.ps1 ${params.Source} ${params.Target} ${params.Shadow}"
            }
        }
    }
}

def ps (String command) {
    bat "powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass \"Set-PSDebug -Trace 1; $command\" -Verbose"
}
