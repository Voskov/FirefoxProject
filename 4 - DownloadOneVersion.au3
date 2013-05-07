#RequireAdmin

$version = "Firefox 21.0 (Beta 6)"
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
   WinWaitActive("Save As")
   sleep(50)
   send($version&".exe")
   Send("{tab}{tab}{tab}{tab}{tab}")
   Send("{Enter}")
   Send($download_path&$version)
   Send("{Enter}")
   Sleep(30)
   Send("!s")
   Sleep(50)
   if WinActive("Confirm Save As") Then ;in case of an overwrite
	  Send("!y")
   EndIf
   WinActivate("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   Sleep(30)
   Send("^w")
EndFunc
	  
   
Func ceateDownloadFolder($version, $download_path)
   $created = DirCreate($download_path&$version)
   if $created = 0 Then
	  MsgBox(48, "failure", '"C:\FirefoxProject\Downloads\'&$version&'" could NOT be created')
   EndIf
EndFunc