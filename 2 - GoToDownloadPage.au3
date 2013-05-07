goToDownloadPage()

Func goToDownloadPage()
   WinActivate("New Tab - Google Chrome")
   WinWaitActive("New Tab - Google Chrome")
   sleep(500)
   Send("^l")
   send("http://www.oldapps.com/firefox.php")
   send("{Enter}")
EndFunc
