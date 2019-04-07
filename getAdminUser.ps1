import-module ActiveDirectory
$pcs = get-Adcomputer -searchbase "OU=Computers, OU=_Clients, DC=domain, dc=local" -filter * -properties * | Select-Object CN, IPv4Address 
$output = @()

foreach($pc in $pcs){
    if (Test-Connection $pc.IPv4Address -Count 1 -Quiet){
        try{
            $result = New-Object PSobject
            $user = ""
            $detail = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $pc.CN | Select-Object Name, Model, Username
            $groups = Get-WmiObject -class win32_groupuser -ComputerName $pc.CN | Where-Object {$_.GroupComponent -like "*Admin*"}
            foreach ($g in $groups){
                $t = $g.partComponent
                $user += $t.split(",")[1].split("=")[1]
                #write $t
                $user += "-"
            }
            $result | Add-Member -NotePropertyName "PC Name" -NotePropertyValue $pc.CN
            $result | Add-Member -NotePropertyName "Model" -NotePropertyValue $detail.Model
            $result | Add-Member -NotePropertyName "Logged On User" -NotePropertyValue $detail.Username
            $result | Add-Member -NotePropertyName "Local Administrators" -NotePropertyValue $user
            #Write-Host $user
            $output += $result
                }
        catch {
                Write-Host "Failed"
        }
    }

}
$output  | Export-Csv -Path "C:\Users\hzabihi\AyalPC.csv"
