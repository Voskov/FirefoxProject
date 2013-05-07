;The pauses are there to make the path visible
#RequireAdmin;
$version = "Firefox 21.0 (Beta 6)"
$filename = $version&".exe"
$installationFolderPath = "C:\FirefoxProject\Installs"&"\"&$version

;$fullpath = $path&"\"&$filename
;TODO: check if "run" window pops (UAC)

installFirefox($version, $installationFolderPath)

Func installFirefox($version, $installationFolderPath)
   WinWait("Mozilla Firefox Setup")
   WinActivate("Mozilla Firefox Setup")
   WinWaitActive("Mozilla Firefox Setup")
   SendKeepActive("Mozilla Firefox Setup")
   Sleep(1000)
   Send("!n") ;1st next
   Sleep(1000)
   Send("!c") ;choose custom
   Sleep(1000)
   Send("!n") ;next
   Send($installationFolderPath&') ;insert installation path
   Sleep(1000)
   Send("!n") ;next
   Sleep(1000)
   Send("!ds") ;remove checkboxes (desktop and start menu)
   Sleep(1000)
   Send("!n") ;next
   Sleep(1000)
   if (winGetText("Mozilla Firefox Setup", "Install")) <> "0" Then
	  Send("!i") ;install
   ElseIf (winGetText("Mozilla Firefox Setup", "Upgrade")) <> "0" Then
	  Send("!u") ;upgrade
   EndIf
   Sleep(1000)
   WinWait("Mozilla Firefox Setup","Completing the Mozilla Firefox Setup Wizard",200)
   Send("!l") ;don't launch
   Sleep(1000)
   Send("!f") ;finish
EndFunc


   