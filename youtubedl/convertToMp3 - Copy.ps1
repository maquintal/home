   $outputExtension = ".mp3"
   $bitrate = 160
   $channels = 2
   
   foreach($inputFile in get-childitem 'C:\Users\vanaq\Downloads\PS1\Folk2' -recurse -Include "*.mp4","*.webm")
   { 
     $outputFileName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile.FullName) + $outputExtension;
     $outputFileName = [System.IO.Path]::Combine($inputFile.DirectoryName, $outputFileName);
     
     $programFiles = ${env:ProgramFiles(x86)};
     if($programFiles -eq $null) { $programFiles = $env:ProgramFiles; }
     
     $processName = $programFiles + "\VideoLAN\VLC\vlc.exe"
     $processArgs = "-I dummy -vvv `"$($inputFile.FullName)`" --sout=#transcode{acodec=`"mp3`",ab=`"$bitrate`",`"channels=$channels`"}:standard{access=`"file`",mux=`"wav`",dst=`"$outputFileName`"} vlc://quit"
     
     start-process $processName $processArgs -wait
   }

 #  get-childitem 'C:\Users\vanaq\Downloads\PS1\DeltaBlues' -recurse -Include "*.mp4","*.webm" | Remove-Item