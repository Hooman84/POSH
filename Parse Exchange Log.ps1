
$csv = import-csv "~\Documents\EXO.csv" 
#$csv | Get-Member
foreach ($row in $csv){
    if ($row."custom_data" -like "S:AMA*"){

        $data = $row."custom_data"
        $match  = $data -match "\|ctry=\w\w\|" 
        $data | Select-String -Pattern "\|ctry=\w+\|" | % {$_.Matches.Groups[0].Value} >> "~\Documents\EXO-Results.csv" 
       
    }


}