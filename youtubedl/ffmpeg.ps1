$outputExtension = ".mp3"
$bitrate = 160
$channels = 2

$folder = Read-Host 'Enter folder path: '
$counter = 1
$totalFiles = (Get-ChildItem $folder -Recurse -Include "*.mp4","*.webm").Count

foreach ($inputFile in Get-ChildItem $folder -Recurse -Include "*.mp4", "*.webm") {
    Write-Progress -Activity "Processing Input File" -CurrentOperation $inputFile.Name -PercentComplete (($counter / $totalFiles) * 100)
    
    $outputFileName = [System.IO.Path]::ChangeExtension($inputFile.FullName, $outputExtension)

    # FFmpeg path (assurez-vous que ffmpeg est dans votre PATH ou mettez son chemin absolu)
    $ffmpegPath = "C:\ffmpeg\bin\ffmpeg.exe"

    # Arguments pour extraire l’audio sans réencoder (beaucoup plus rapide)
    $processArgs = "-i `"$($inputFile.FullName)`" -vn -acodec libmp3lame -b:a ${bitrate}k -ac $channels `"$outputFileName`" -y"

    # Lancer FFmpeg
    Start-Process -NoNewWindow -Wait -FilePath $ffmpegPath -ArgumentList $processArgs

    $counter++
}

Write-Output "Extraction terminée !"
