#RequireAdmin

$version = "Firefox 21.0 (Beta 4)"
$download_path = "C:\FirefoxProject\downloads\"

downloadOneVersion($version, $download_path)

Func downloadOneVersion($version, $download_path)
   ceateDownloadFolder($version, $download_path)
   
   WinActivate("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   WinWaitActive("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   Send("^f")
   Sleep(30)
   send("screenshots")
   Send("{esc}")
   Send("{tab}{tab}")
   Send("{enter}")
   $counter = 1
   while WinWaitActive("Save As", "", 10) = 0 And $counter < 4
	  MsgBox(48,"",$counter,1)
	  WinActivate("Download")
	  Send("^f")
	  Send($version)
	  Send("{f3}")
	  Send("{Esc}")
	  send("{Enter}")
	  if WinWaitActive("Save As", "", 10) = 0 Then
		 Send ("{f5}")
	  Else
		 ExitLoop
	  EndIf
	  $counter = $counter + 1
	  if $counter => 4 Then
		 MsgBox(0,"","Done retrying, skipping")
		 Return
	  EndIf
   WEnd
   WinActivate("Save As")
   send($version&".exe")
   Send("{F4}")
   Send("^a")
   Send($download_path&$version)
   Send("{Enter}")
   Sleep(30)
   Send("!s")
   Sleep(50)
   if WinActive("Confirm Save As") Then ;in case of an overwrite
	  Send("!y")
   EndIf
;~    addToLog("began downloading "&$version)
   WinActivate("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   Sleep(30) 
   Send("^w")
   Sleep(50)
EndFunc
	  
   
Func ceateDownloadFolder($version, $download_path)
   $created = DirCreate($download_path&$version)
   if $created = 0 Then
	  MsgBox(48, "failure", '"C:\FirefoxProject\Downloads\'&$version&'" could NOT be created')
   EndIf
EndFunc