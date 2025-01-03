﻿$Playlisturl = "https://www.youtube.com/watch?v=xuEPz6bEno4&list=PL-u26gILWGF01D893ULmT8UfWb_ddEfnG"
$VideoUrls= (invoke-WebRequest -uri $Playlisturl).Links | ? {$_.HREF -like "/watch*"} | `
? innerText -notmatch ".[0-9]:[0-9]." | ? {$_.innerText.Length -gt 3} | Select innerText, `
@{Name="URL";Expression={'http://www.youtube.com' + $_.href}} | ? innerText -notlike "*Play all*"
 
$VideoUrls
 
ForEach ($video in $VideoUrls){
Write-Host ("Downloading " + $video.innerText)
.\youtube-dl.exe $video.URL
}