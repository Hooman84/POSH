If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

<# 
.NAME
    ACL-Calculator
.SYNOPSIS
    Calculate ACL enrtries for each Folder
.DESCRIPTION
    It will go through all folders and check the ACL entries and report anything is not Enhierented 
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$ACLReport                       = New-Object system.Windows.Forms.Form
$ACLReport.ClientSize            = '410,193'
$ACLReport.text                  = "ACL Report on FS"
$ACLReport.TopMost               = $false

$RootFolder                      = New-Object system.Windows.Forms.Label
$RootFolder.text                 = "RootFolder"
$RootFolder.AutoSize             = $true
$RootFolder.width                = 25
$RootFolder.height               = 10
$RootFolder.location             = New-Object System.Drawing.Point(4,7)
$RootFolder.Font                 = 'Microsoft Sans Serif,10,style=Bold'

$RootFoldeTxt                    = New-Object system.Windows.Forms.TextBox
$RootFoldeTxt.multiline          = $false
$RootFoldeTxt.text               = "C:\"
$RootFoldeTxt.width              = 274
$RootFoldeTxt.height             = 20
$RootFoldeTxt.location           = New-Object System.Drawing.Point(123,7)
$RootFoldeTxt.Font               = 'Microsoft Sans Serif,10'

$ResultOutput                    = New-Object system.Windows.Forms.Label
$ResultOutput.text               = "ResultOutput"
$ResultOutput.AutoSize           = $true
$ResultOutput.width              = 25
$ResultOutput.height             = 10
$ResultOutput.location           = New-Object System.Drawing.Point(4,35)
$ResultOutput.Font               = 'Microsoft Sans Serif,10,style=Bold'

$ResultOutputtxt                 = New-Object system.Windows.Forms.TextBox
$ResultOutputtxt.multiline       = $false
$ResultOutputtxt.text            = "C:\"
$ResultOutputtxt.width           = 274
$ResultOutputtxt.height          = 20
$ResultOutputtxt.location        = New-Object System.Drawing.Point(123,33)
$ResultOutputtxt.Font            = 'Microsoft Sans Serif,10'

$ExcludeGroups                   = New-Object system.Windows.Forms.Label
$ExcludeGroups.text              = "ExcludeGroups"
$ExcludeGroups.AutoSize          = $true
$ExcludeGroups.width             = 25
$ExcludeGroups.height            = 10
$ExcludeGroups.location          = New-Object System.Drawing.Point(5,59)
$ExcludeGroups.Font              = 'Microsoft Sans Serif,10,style=Bold'

$ExcludeGroupstxt                = New-Object system.Windows.Forms.TextBox
$ExcludeGroupstxt.multiline      = $false
$ExcludeGroupstxt.text           = "Domain Admins, Administrators, OWNER, SERVICE, SYSTEM"
$ExcludeGroupstxt.width          = 275
$ExcludeGroupstxt.height         = 20
$ExcludeGroupstxt.location       = New-Object System.Drawing.Point(122,57)
$ExcludeGroupstxt.Font           = 'Microsoft Sans Serif,10'

$Run                             = New-Object system.Windows.Forms.Button
$Run.text                        = "Run"
$Run.width                       = 60
$Run.height                      = 30
$Run.location                    = New-Object System.Drawing.Point(157,103)
$Run.Font                        = 'Microsoft Sans Serif,10,style=Bold,Italic'

$Result                          = New-Object system.Windows.Forms.Label
$Result.text                     = "Result: "
$Result.AutoSize                 = $true
$Result.width                    = 25
$Result.height                   = 10
$Result.location                 = New-Object System.Drawing.Point(13,156)
$Result.Font                     = 'Microsoft Sans Serif,10,style=Bold'
$Result.ForeColor                = "#fb0a0a"

$ACLReport.controls.AddRange(@($RootFolder,$RootFoldeTxt,$ResultOutput,$ResultOutputtxt,$ExcludeGroups,$ExcludeGroupstxt,$Run,$Result))

#region gui events {
$Run.Add_MouseClick({ RunACL })
#endregion events }

#endregion GUI }
function RunACL () {
    try {
        $Today = Get-Date -Format "yyyy-MM-dd"
        $OutputFile = "{0}\Permissions{1}.csv" -f ($ResultOutputtxt.Text,$Today)
        $OutputFile = $OutputFile.Replace('\\','\')
    
        $Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
        Add-Content -Value $Header -Path $OutputFile
    
        $Folders = Get-ChildItem $RootFoldeTxt.text  | Where-Object {$_.psiscontainer -eq $true}
        $Pattern = ($ExcludeGroupstxt.text.Split(",")).Trim()
        $Patterns = $Pattern -join "|"
        foreach ($Folder in $Folders){
            $ACLs = Get-Acl $Folder.fullname | ForEach-Object {$_.Access}
            foreach ($ACL in $ACLs){
                if($ACL.IsInherited -eq $false -and $ACL.IdentityReference -notmatch $Patterns){
                    $OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
                    Add-Content -Value $OutInfo -Path $OutputFile
                }
            }
        }
        $Result.text = "SUCCESS. File Saved at {0}." -f $OutputFile
    }
    catch {
        $Result.Text = "An Issue Occured. Please check your settings again."
    }

    

    
}

#Write your logic code here

[void]$ACLReport.ShowDialog()