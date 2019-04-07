Import-Module activedirectory
$ArrComputers =  Get-ADComputer -server 'dc01' -filter * -Properties * -SearchBase 'OU= PCs, OU=computers, dc=Domain,dc=local' | select Name, operatingSystem

write-host $ArrComputers
$results = @()
foreach ($Computer in $ArrComputers.Name) 
{
    $name = ""
    $Manufacturer =""
    $model = ""
    $Username = ""
    $SerialNumber = ""
    $caption = ""
    $UserName = ""
    $InstallDate = ""
    $user = ""
	$cpu = ""
	$ram = ""
	$memSlot = ""
        $memSlotFree = ""
        $screen = ""
   try{
        $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $Computer | Select-Object Name, Model, Username, Manufacturer
        if ($?){
            $name = $Computer
            $model = $computerSystem.Model
            $Manufacturer = $computerSystem.Manufacturer 
            $UserName = $computerSystem.UserName
	    $ram = [Math]::Round(($computerSystem.TotalPhysicalMemory/1GB),2)
        }
        else{
            $name = $Computer
            $model = "NA"
            $Manufacturer = "NA"
            $UserName = "NA"

        }
        $computerBIOS = get-wmiobject Win32_BIOS -Computer $Computer
        if ($?){
                $SerialNumber = $computerBIOS.SerialNumber
        }
        else{
                $SerialNumber = "NA"
        }
        $computerOS = get-wmiobject Win32_OperatingSystem -Computer $Computer
        if ($?){
            $caption = $computerOS.caption
            $InstallDate = $computerOS.ConvertToDateTime($computerOS.InstallDate)
        }
        else{
                $caption = (Get-ADComputer -Identity $Computer -Properties OperatingSystem).OperatingSystem
                $InstallDate = "NA"
        }
        $computerLastLogon = Get-ADComputer -Identity $Computer -Properties * | select lastlogondate
        $groups = Get-WmiObject -class win32_groupuser -ComputerName $Computer | Where-Object {$_.GroupComponent -like "*Admin*"}
        if ($?){
            $user = ""
            foreach ($g in $groups){
                $t = $g.partComponent
                $user += $t.split(",")[1].split("=")[1]
                #write $t
                $user += "-"
                }
        }
        else{
                $user = "NA"
        }
        $user = ""
            foreach ($g in $groups){
                $t = $g.partComponent
                $user += $t.split(",")[1].split("=")[1]
                #write $t
                $user += "-"
                }
		$computerCPU = get-wmiobject win32_Processor -Computer $Computer
        if ($?){
                $cpu  = $computerCPU.Name
        }
        else{
                $cpu = "NA"
        }
		
		$computerMemory = get-wmiobject Win32_PhysicalmemoryArray -Computer $Computer
		if ($?){
                $memSlot  = $computermemory.MemoryDevices
        }
        else{
                $memSlot = "NA"
        }
		
		$computerfreeSlot = get-wmiobject Win32_Physicalmemorylocation -Computer $Computer 
		if ($?){
                $memSlotFree  = $computerfreeSlot | select PartComponent | measure
				$memSlotFree = $memSlotFree.count
				
        }
        else{
                $memSlotFree = "NA"
        }

        $computerScreens = Get-WmiObject -Class WmiMonitorID -ComputerName $Computer -Namespace root\Wmi
        if ($?){
                $screen += $computerScreens | Measure-Object | Select Count
                $screen += "--"
                ForEach ($Monitor in $Monitors){
        
	                $screen += ($Monitor.ManufacturerName -notmatch 0 | ForEach{[char]$_}) -join ""
	                $screen += ($Monitor.UserFriendlyName -notmatch 0 | ForEach{[char]$_}) -join ""
	                $screen += ($Monitor.SerialNumberID -notmatch 0 | ForEach{[char]$_}) -join ""
	
	}
            }
            else{
                    $screen = "NA"
            }

        $obj = New-Object PSObject
        $obj | Add-Member -MemberType NoteProperty -Name "Computer Name" -Value $name 
        $obj | Add-Member -MemberType NoteProperty -Name "Manufacturer" -Value $Manufacturer
        $obj | Add-Member -MemberType NoteProperty -Name "Model" -Value $model
        $obj | Add-Member -MemberType NoteProperty -Name "Last Logon on AD" -Value $computerLastLogon.lastlogondate
        $obj | Add-Member -MemberType NoteProperty -Name "Last User LoggedOn" -Value $Username
        $obj | Add-Member -MemberType NoteProperty -Name "Serial Number" -Value $SerialNumber
        $obj | Add-Member -MemberType NoteProperty -Name "Operating System" -Value $caption
        $obj | Add-Member -MemberType NoteProperty -Name "User logged In" -Value $UserName
        $obj | Add-Member -MemberType NoteProperty -Name "Install Date" -Value $InstallDate
        $obj | Add-Member -MemberType NoteProperty -Name "Local Admins" -Value $user
	$obj | Add-Member -MemberType NoteProperty -Name "CPU" -Value $cpu
	$obj | Add-Member -MemberType NoteProperty -Name "RAM" -Value $ram
	$obj | Add-Member -MemberType NoteProperty -Name "Memory Slots" -Value $memSlot
	$obj | Add-Member -MemberType NoteProperty -Name "Used Slots" -Value $memSlotFree
	$obj | Add-Member -MemberType NoteProperty -Name "Screens" -Value $screen	
        $obj
        $results += $obj
        }
   catch{
    Write-Host $Computer, " Error Out!!"
   }
}
$results| Export-Csv "c:\PC_Inventory.csv"
