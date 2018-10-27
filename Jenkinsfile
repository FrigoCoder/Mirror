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
    stages{
        stage("Mirror"){
            powershell "Set-PSDebug -Trace 1"
            powershell ".\\Mirror.ps1 $SOURCE_DRIVE $TARGET_DRIVE $SHADOW_DRIVE -Verbose"
        }
    }
}
