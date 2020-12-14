Set-Location "C:\temp\youtubedl"

.\youtube-dl.exe -U

$playlisturl = Read-Host 'enter URL: '

try {
    .\youtube-dl -i -f mp4 --yes-playlist $playlisturl
} catch { write-host $_ }
    
