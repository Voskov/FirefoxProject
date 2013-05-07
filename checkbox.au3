

WinActivate("User Accounts")
WinWaitActive("User Accounts")

$box = GUICtrlRead(1022)
MsgBox(0,"",$box)
BitAND