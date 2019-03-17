   $outputExtension = ".mp3"
   $bitrate = 160
   $channels = 2

   $folder = 'C:\Users\vanaq\Downloads\PS1\2019-01-30'
   
   foreach($inputFile in get-childitem $folder -recurse -Include "*.mp4","*.webm")
   { 
     $outputFileName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile.FullName) + $outputExtension;
     $outputFileName = [System.IO.Path]::Combine($inputFile.DirectoryName, $outputFileName);
     
     $programFiles = ${env:ProgramFiles(x86)};
     if($programFiles -eq $null) { $programFiles = $env:ProgramFiles; }
     
     $processName = $programFiles + "\VideoLAN\VLC\vlc.exe"
     $processArgs = "-I dummy -vvv `"$($inputFile.FullName)`" --sout=#transcode{acodec=`"mp3`",ab=`"$bitrate`",`"channels=$channels`"}:standard{access=`"file`",mux=`"wav`",dst=`"$outputFileName`"} vlc://quit"
     
     start-process $processName $processArgs -wait
   }

  get-childitem $folder -recurse -Include "*.mp4","*.webm" | Remove-Item
  get-childitem $folder -recurse -Include "*.mp3}" | rename-item -newname { [io.path]::ChangeExtension($_.name, "mp3") }