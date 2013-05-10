#RequireAdmin;
$username = IniRead("credentials.ini","Credentials","username","ERROR -1")
$password = IniRead("credentials.ini","Credentials","password","ERROR -1")


bypassLogin($username, $password)

Func bypassLogin($username, $password)
   Send("#r") ;run
   WinWaitActive("Run")
   Send("netplwiz")
   Send("{Enter}")
   WinWaitActive("User Accounts")
   Sleep(100)
   Send("!e")
   Send("!a")
   WinWaitActive("Automatically sign in")
   Send("+{Tab}")
   Send("^a") ;select all, just in case
   Send($username)
   Send("{Tab}")
   Send($password)
   Send("{Tab}")
   Send($password)
   Send("{Enter}")
   Sleep(500)
   Send("{Enter}")
EndFunc