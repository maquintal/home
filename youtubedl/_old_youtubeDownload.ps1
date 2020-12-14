Set-Location "C:\temp\youtubedl"

.\youtube-dl.exe -U

#$playlisturl = Read-Host 'enter URL: '
##$Playlisturl = "https://www.youtube.com/playlist?list=PLkHvEl7zu06o70dpsiVrRbYFLWreD9Jcw"
#$VideoUrls= (invoke-WebRequest -uri $Playlisturl).Links | ? {$_.HREF -like "/watch*"} | `
#? innerText -notmatch ".[0-9]:[0-9]." | ? {$_.innerText.Length -gt 3} | Select innerText, `
#@{Name="URL";Expression={'http://www.youtube.com' + $_.href}} | ? innerText -notlike "*Play all*"
 
#$VideoUrls
 
#ForEach ($video in $VideoUrls){
#Write-Host ("Downloading " + $video.innerText)
#Write-Host "jjj"
#try {
#    #.\youtube-dl.exe -v --yes-playlist -i -f mp4 $video.URL
#} catch { Write-Host $_ }

# if not working
#.\youtube-dl -i -f mp4 --yes-playlist 'https://www.youtube.com/watch?v=B6_iQvaIjXw&list=PLMC9KNkIncKseYxDN2niH6glGRWKsLtde'
#}

    .\youtube-dl -i -f mp4 --yes-playlist 'https://www.youtube.com/watch?v=B6_iQvaIjXw&list=PLMC9KNkIncKseYxDN2niH6glGRWKsLtde'
