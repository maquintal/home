﻿<#
#   Description
#       Copies the Bakupdirs to the Destination
#       You can configure more than one Backupdirs, every Dir
#       wil be copied to the Destination. A Progress Bar
#       is showing the Status of copied MB to the total MB
#       Only Change Variables in Variables Section
#       Change LoggingLevel to 3 an get more output in Powershell Windows
#
#   Creator: Michael Seidl aka Techguy
#   Contributor: Marc-Andre Quintal
#   CreationDate: 21.01.2014
#   Version: 1.3
#   Doc: http://www.techguy.at/tag/backupscript/
#   PSVersion tested: 3 and 4
#
#   Task Scheduler: powershell.exe -ExecutionPolicy Bypass C:\Users\User\Desktop\home\Dell_E6440-BackupScript.ps1 -RunType $true -Path C:\Users\User\Desktop\home
#>

Get-ChildItem \\diskstation.local\BackupMA

####################################
#
# SCRIPT VARIABLES
#
####################################

#Copy the Files to this Location
$Destination="\\diskstation.local\BackupMA"

#How many of the last Backups you want to keep
$Versions="3"
#What Folders you want to backup

$BackupDirs="C:\Users\Admin\Documents\BeerSmith2", "\\diskstation.local\BAMAQ\RecipeDatabase.bsmx", "\\diskstation.local\BackupMA\Impots", "C:\Users\Admin\OneDrive\Budget"

#This list of Directories will not be copied
#$ExcludeDirs="C:\Program Files (x86)\OpenVPN\bin", "C:\Program Files (x86)\OpenVPN\config"

#Log Name
$LogName="Log.txt"

#LoggingLevel only for Output in Powershell Window, 1=smart, 3=Heavy
$LoggingLevel="3"

#Zip the Backup Destination
$Zip=$true

#Remove copied files after Zip, only if $Zip is true
$RemoveBackupDestination=$false


#Send Mail Settings
$SendEmail = $true                     # = $true if you want to enable send report to e-mail (SMTP send)
$EmailTo   = 'maquintal16@gmail.com'   # user@domain.something (for multiple users use "User01 &lt;user01@example.com&gt;" ,"User02 &lt;user02@example.com&gt;" )
$EmailFrom = 'vanaquin@hotmail.com'    # matthew@domain 
#$EmailSMTP = 'smtphm.sympatico.ca'     # smtp server adress, DNS hostname.
$EmailSMTP = 'smtp.gmail.com'


####################################
#
# GLOBAL VARIABLES
#
####################################
#STOP-no changes from here
#STOP-no changes from here
#Settings - do not change anything from here
$Backupdir=$Destination +"\Backup-"+ (Get-Date -format yyyy-MM-dd-HH-mm-ss)+"\"#+(Get-Random -Maximum 100000)+"\"
$Log=$Backupdir+$LogName
$Items=0
$Count=0
$ErrorCount=0
$StartDate=Get-Date #-format dd.MM.yyyy-HH:mm:ss

####################################
#
# FUNCTIONS
#
####################################
#Logging
Function Logging ($State, $Message) {
    $Datum=Get-Date -format dd.MM.yyyy-HH:mm:ss

    if (!(Test-Path -Path $Log)) {
        New-Item -Path $Log -ItemType File | Out-Null
    }
    $Text="$Datum - $State"+":"+" $Message"

    if ($LoggingLevel -eq "1" -and $Message -notmatch "was copied") {Write-Host $Text}
    elseif ($LoggingLevel -eq "3") {Write-Host $Text}
   
    add-Content -Path $Log -Value $Text
    sleep -Milliseconds 100
}


#Create Backupdir
Function Create-Backupdir {
    New-Item -Path $Backupdir -ItemType Directory | Out-Null
    sleep -Seconds 3
    Logging "INFO" "Create Backupdir $Backupdir"
}

#Delete Backupdir
Function Delete-Backupdir {
    $Folder=Get-ChildItem $Destination | where {$_.Attributes -eq "Directory" -and $_.BaseName -match 'Backup'}
    $nb_del = $Folder.Count - $Versions
    $Folder_to_delete = Get-ChildItem $Destination | where {$_.Attributes -eq "Directory" -and $_.BaseName -match 'Backup'} | Sort-Object -Property $_.CreationTime | Select-Object -First $nb_del

    Logging "INFO" "Remove Dir: $Folder_to_delete"
    
    $Folder_to_delete.FullName | Remove-Item -Recurse -Force 
}


#Delete Zip
Function Delete-Zip {
    $Zip=Get-ChildItem $Destination | where {$_.Attributes -eq "Archive" -and $_.Extension -eq ".zip" -and $_.BaseName -match 'Backup'}
    $nb_del = $Zip.Count - $Versions
    $Zip_to_delete = Get-ChildItem $Destination | where {$_.Attributes -eq "Archive" -and $_.BaseName -match 'Backup'} | Sort-Object -Property $_.CreationTime | Select-Object -First $nb_del

    Logging "INFO" "Remove Zip: $Zip_to_delete"
    
    $Zip_to_delete.FullName | Remove-Item -Recurse -Force 
}

#Check if Backupdirs and Destination is available
function Check-Dir {
    Logging "INFO" "Check if BackupDir and Destination exists"
    if (!(Test-Path $BackupDirs)) {
        return $false
        Logging "Error" "$BackupDirs does not exist"
    }
    if (!(Test-Path $Destination)) {
        return $false
        Logging "Error" "$Destination does not exist"
    }
}

#Save all the Files
Function Make-Backup {
    Logging "INFO" "Started the Backup"
    $Files=@()
    $SumMB=0
    $SumItems=0
    $SumCount=0
    $colItems=0
    Logging "INFO" "Count all files and create the Top Level Directories"

    foreach ($Backup in $BackupDirs) {
        $colItems = (Get-ChildItem $Backup -recurse | Where-Object {$_.mode -notmatch "h"} | Measure-Object -property length -sum) 
        $Items=0
        $FilesCount += Get-ChildItem $Backup -Recurse | Where-Object {$_.mode -notmatch "h"}  
        Copy-Item -Path $Backup -Destination $Backupdir -Force -ErrorAction SilentlyContinue
        $SumMB+=$colItems.Sum.ToString()
        $SumItems+=$colItems.Count
    }

    $TotalMB="{0:N2}" -f ($SumMB / 1MB) + " MB of Files"
    Logging "INFO" "There are $SumItems Files with  $TotalMB to copy"

    foreach ($Backup in $BackupDirs) {
        $Index=$Backup.LastIndexOf("\")
        $SplitBackup=$Backup.substring(0,$Index)
        $Files = Get-ChildItem $Backup -Recurse | Where-Object {$_.mode -notmatch "h" -and $ExcludeDirs -notcontains $_.FullName} 
        foreach ($File in $Files) {
            $restpath = $file.fullname.replace($SplitBackup,"")
            try {
                Copy-Item  $file.fullname $($Backupdir+$restpath) -Force -ErrorAction SilentlyContinue |Out-Null
                Logging "INFO" "$file was copied"
            }
            catch {
                $ErrorCount++
                Logging "ERROR" "$file returned an error an was not copied"
            }
            $Items += (Get-item $file.fullname).Length
            $status = "Copy file {0} of {1} and copied {3} MB of {4} MB: {2}" -f $count,$SumItems,$file.Name,("{0:N2}" -f ($Items / 1MB)).ToString(),("{0:N2}" -f ($SumMB / 1MB)).ToString()
            $Index=[array]::IndexOf($BackupDirs,$Backup)+1
            $Text="Copy data Location {0} of {1}" -f $Index ,$BackupDirs.Count
            Write-Progress -Activity $Text $status -PercentComplete ($Items / $SumMB*100)  
            if ($File.Attributes -ne "Directory") {$count++}
        }
    }
    $SumCount+=$Count
    $SumTotalMB="{0:N2}" -f ($Items / 1MB) + " MB of Files"
    Logging "INFO" "----------------------"
    Logging "INFO" "Copied $SumCount files with $SumTotalMB"
    Logging "INFO" "$ErrorCount Files could not be copied"


    # Send e-mail with reports as attachments
    if ($SendEmail -eq $true) {
        $EmailSubject = "Backup Email $(get-date -format MM.yyyy)"
        $EmailBody = "Backup Script $(get-date -format MM.yyyy) (last Month).`nYours sincerely `Matthew - SYSTEM ADMINISTRATOR"
        Logging "INFO" "Sending e-mail to $EmailTo from $EmailFrom (SMTPServer = $EmailSMTP) "
        ### the attachment is $log 
        Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $EmailBody -SmtpServer $EmailSMTP -attachment $Log 
    }
}

####################################
#
# MAIN
#
####################################
#Bcreate Backup Dir
Create-Backupdir
Logging "INFO" "----------------------"
Logging "INFO" "Start the Script"

#Check if Backupdir needs to be cleaned and create Backupdir
$Count=(Get-ChildItem $Destination | where {$_.Attributes -eq "Directory" -and $_.BaseName -match 'Backup-'}).count
Logging "INFO" "Check if there are more than $Versions Directories in the Backupdir"

if ($count -gt $Versions) {
    Delete-Backupdir
}

$CountZip=(Get-ChildItem $Destination | where {$_.Attributes -eq "Archive" -and $_.Extension -eq ".zip" -and $_.BaseName -match 'Backup-'}).count
Logging "INFO" "Check if there are more than $Versions Zip in the Backupdir"

if ($CountZip -gt $Versions) {

    Delete-Zip 

}

#Check if all Dir are existing and do the Backup
$CheckDir=Check-Dir

if ($CheckDir -eq $false) {
    Logging "ERROR" "One of the Directory are not available, Script has stopped"
} else {
    Make-Backup

    $Enddate=Get-Date #-format dd.MM.yyyy-HH:mm:ss
    $span = $EndDate - $StartDate
    $Minutes=$span.Minutes
    $Seconds=$Span.Seconds

    Logging "INFO" "Backupduration $Minutes Minutes and $Seconds Seconds"
    Logging "INFO" "----------------------"
    Logging "INFO" "----------------------" 

    if ($Zip)
    {
        Logging "INFO" "Compress thew Backup Destination"
        Compress-Archive -Path $Backupdir -DestinationPath ($Destination+("\"+$Backupdir.Replace($Destination,'').Replace('\','')+".zip")) -CompressionLevel Optimal -Force

        If ($RemoveBackupDestination)
        {
            Logging "INFO" "Backupduration $Minutes Minutes and $Seconds Seconds"

            #Remove-Item -Path $BackupDir -Force -Recurse 
            get-childitem -Path $BackupDir -recurse -Force  | remove-item -Confirm:$false -Recurse
            get-item -Path $BackupDir   | remove-item -Confirm:$false -Recurse
        }
    }
}

#Write-Host "Press any key to close ..."

#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")



