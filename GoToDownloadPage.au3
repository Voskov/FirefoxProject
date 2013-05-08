goToDownloadPage()
Func goToDownloadPage()
   WinActivate("New Tab - Google Chrome")
   WinWaitActive("New Tab - Google Chrome")
   Sleep(500)
   Send("^l")
   Send("http://www.oldapps.com/firefox.php")
   Send("{Enter}")
   $counter = 1
   While WinWait("Old Version of Firefox Download - OldApps.com - Google Chrome","www.oldapps.com/firefox.php",3) = 0
	  addToLog("ERROR: Could not load download page - retrying")
	  WinActivate("New Tab - Google Chrome")
	  Send("{f5}")
	  
	  if $counter > 3 Then
		 addToLog("Done retrying to load the page - exiting")
		 MsgBox(48,"ERROR","Could not load the download page, please check your internet connection and run the script again")
		 Exit
	  EndIf
	  $counter = $counter + 1
   WEnd  
EndFunc