pickSelectedVersion("Firefox 21.0 (Beta 6)")
Func pickSelectedVersion($version)
   Sleep(2000)
   Send("^{Enter}")
   Sleep(1000)
   Send("^{Tab}")
   WinWaitActive("Old Version of "&$version&" Download")
   MsgBox(0,"","Ready")
EndFunc