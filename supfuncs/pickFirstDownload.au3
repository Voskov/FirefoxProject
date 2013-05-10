$version = "Firefox 21.0 (Beta 6)"

WinActivate("Old Version of Firefox Download - OldApps.com - Google Chrome")
WinWaitActive("Old Version of Firefox Download - OldApps.com - Google Chrome")
;GoToFirstDownload()
findVersion($version)
Send("^{enter}")
Sleep(6000)
Send("^{tab}")
Sleep(50)

Func GoToFirstDownload()
   For $i = 1 to 36 step 1
	  send("{tab}")
	  sleep(50)
   Next
EndFunc

Func findVersion($ver)
   Send("^f")
   Sleep(30)
   Send($ver)
   Send("{Esc}")
EndFunc