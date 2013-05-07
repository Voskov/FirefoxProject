goToDownloadPage()

Func goToDownloadPage()
   WinActivate("New Tab - Google Chrome")
   WinWaitActive("New Tab - Google Chrome")
   Sleep(500)
   Send("^l")
   Send("http://www.oldapps.com/firefox.php")
   Send("{Enter}")
   Sleep(5000)
   If WinActive("lhttp://www?oldapps?com/firefox?php - Google Search - Google Chrome") Then
	  MsgBox(0,"","Hebrew")
	  Send ("!{Shift}")
	  Send ("+{Tab}")
	  Send("{Enter}")
   EndIf
EndFunc
