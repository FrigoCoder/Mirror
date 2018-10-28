# Mirror

Drive backup script in PowerShell with Shadow Copy support. Optional Jenkins project included.

## Warning

Warning! The script completely erases the target drive! Only keeps files that are the same on the source drive. Do NOT run the script on drives you would like to preserve!

## Usage

Open up PowerShell, navigate to the folder, and execute the command:

    .\Mirror.ps1 sourceDrive: targetDrive: shadowDrive: -Verbose
    
Where sourceDrive is the drive you would like to backup, targetDrive is the backup drive, and shadowDrive is a free drive letter that will be used for a temporary snapshot of the source drive.

For example the following command will backup c: drive to d: drive with b: as the temporary drive letter:

    .\Mirror.ps1 c: d: b: -Verbose

## Usage in Jenkins

Download or fork the project, change Jenkinsfile to your preferences, and create a new pipeline job with it. Preferably do not clone the project because at any time I could make modifications that break your data.
