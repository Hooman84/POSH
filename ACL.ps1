$OutFile = "C:\Permission.csv"
$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
#Del $OutFile
Add-Content -Value $Header -Path $OutFile 

$RootPath = "D:\Shares"

$Folders = dir $RootPath -recurse | where {$_.psiscontainer -eq $true}

foreach ($Folder in $Folders){
	$ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  }
	Foreach ($ACL in $ACLs){
        if ($ACL.IsInherited -eq $false  -and $ACL.IdentityReference -like "*ALTACORP*" -and $ACL.IdentityReference -notlike "*Domain Admins"){
	        $OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
            Add-Content -Value $OutInfo -Path $OutFile
        }
        
    }
}