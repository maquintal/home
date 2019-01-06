#Set-ExecutionPolicy RemoteSigned -Force

Set-Location "C:\Users\vanaq\Downloads\PS1"

$playlisturl = Read-Host 'enter URL: '
#$Playlisturl = "https://www.youtube.com/playlist?list=PLkHvEl7zu06o70dpsiVrRbYFLWreD9Jcw"
$VideoUrls= (invoke-WebRequest -uri $Playlisturl).Links | ? {$_.HREF -like "/watch*"} | `
? innerText -notmatch ".[0-9]:[0-9]." | ? {$_.innerText.Length -gt 3} | Select innerText, `
@{Name="URL";Expression={'http://www.youtube.com' + $_.href}} | ? innerText -notlike "*Play all*"
 
$VideoUrls
 
ForEach ($video in $VideoUrls){
Write-Host ("Downloading " + $video.innerText)
.\youtube-dl.exe $video.URL
}

#to download https://www.youtube.com/watch?v=Wet5OM7RR8Q&list=PLGpxiRQ20U6NSYZNdWMzFogtFT-9lu96z