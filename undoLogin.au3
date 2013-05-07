#RequireAdmin;

Func undoLoginBypass()
   Send("#r") ;run
   WinWaitActive("Run")
   Send("netplwiz")
   Send("{Enter}")
   WinWaitActive("User Accounts")
   Sleep(100)
   Send("!e")
   Sleep(100)
   Send("{Enter}")
EndFunc