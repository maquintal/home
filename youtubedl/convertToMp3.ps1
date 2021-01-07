#C:\Users\vanaq\Downloads\PS1\pref2C:\Users\vanaq\Downloads\PS1\pref2C:\Users\vanaq\Downloads\PS1\pref2C:\Users\vanaq\Downloads\PS1\pref2   
$outputExtension = ".mp3"
   $bitrate = 160
   $channels = 2

   $folder = Read-Host 'enter folder path: '
   $counter = 1
   
   foreach($inputFile in get-childitem $folder -recurse -Include "*.mp4","*.webm")
   { 
     Write-Progress -Activity 'Processing Input File' -CurrentOperation $inputFile -PercentComplete (($counter / (Get-ChildItem $folder).Length) * 100)
     $outputFileName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile.FullName) + $outputExtension;
     $outputFileName = [System.IO.Path]::Combine($inputFile.DirectoryName, $outputFileName);
     
     #$programFiles = ${env:ProgramFiles(x86)};
     $programFiles = $env:ProgramFiles;
     #if($programFiles -eq $null) { $programFiles = $env:ProgramFiles; }
     
     $processName = $programFiles + "\VideoLAN\VLC\vlc.exe"
     $processArgs = "-I dummy -vvv `"$($inputFile.FullName)`" --sout=#transcode{acodec=`"mp3`",ab=`"$bitrate`",`"channels=$channels`"}:standard{access=`"file`",mux=`"wav`",dst=`"$outputFileName`"} vlc://quit"
     
     start-process $processName $processArgs -wait
     $counter++
   }

  #get-childitem $folder -recurse -Include "*.mp4","*.webm" | Remove-Item
  #get-childitem $folder -recurse -Include "*.mp3}" | rename-item -newname { [io.path]::ChangeExtension($_.name, "mp3") }