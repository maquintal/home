  $folder = 'C:\Users\vanaq\Downloads\PS1\Pop 2018-May\'

$collection = (Get-ChildItem $folder -Filter *.mp3 | Select-Object -First 1).Name


#%{ ren -new ($_.Name + ".txt") }

foreach ($item in $collection)
{
    $newname = $item.Substring(0, $item.lastindexof('-')) + ".mp3"

    $newname

    Rename-ItemProperty -Name -NewName $newname -Path 'C:\Users\vanaq\Downloads\PS1\Pop 2018-May\new'
}