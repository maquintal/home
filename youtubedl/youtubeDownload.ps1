Set-Location "C:\temp\youtubedl"

#.\youtube-dl.exe -U
C:\Users\User\Desktop\home\youtubedl\yt-dlp.exe -U

$playlisturl = Read-Host 'enter URL: '

try {
    #.\youtube-dl -i -f mp4 --yes-playlist $playlisturl
    C:\Users\User\Desktop\home\youtubedl\yt-dlp.exe $playlisturl
} catch { write-host $_ }
    
