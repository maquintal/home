#Set-ExecutionPolicy RemoteSigned -Force

.\youtube-dl.exe -U

Set-Location "C:\Users\vanaq\Downloads\PS1"

$playlisturl = Read-Host 'enter URL: '
#$Playlisturl = "https://www.youtube.com/playlist?list=PLkHvEl7zu06o70dpsiVrRbYFLWreD9Jcw"
$VideoUrls= (invoke-WebRequest -uri $Playlisturl).Links | ? {$_.HREF -like "/watch*"} | `
? innerText -notmatch ".[0-9]:[0-9]." | ? {$_.innerText.Length -gt 3} | Select innerText, `
@{Name="URL";Expression={'http://www.youtube.com' + $_.href}} | ? innerText -notlike "*Play all*"
 
$VideoUrls
 
ForEach ($video in $VideoUrls){
Write-Host ("Downloading " + $video.innerText)
.\youtube-dl.exe $video.URL -v

# if not working
#youtube-dl -i -f mp4 --yes-playlist 'https://www.youtube.com/watch?v=7Vy8970q0Xc&list=PLwJ2VKmefmxpUJEGB1ff6yUZ5Zd7Gegn2'
}

#to download https://www.youtube.com/watch?v=Wet5OM7RR8Q&list=PLGpxiRQ20U6NSYZNdWMzFogtFT-9lu96z