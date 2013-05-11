#RequireAdmin

MsgBox(0,"",checkIfUserBoxChecked())
;This function checks whether the checkbox "Users must enter..." is checked
;It does so by sampeling the color of the box below.
;It's a rough patch, but it seems to work
Func checkIfUserBoxChecked() 
   Opt("PixelCoordMode", 0)
   WinActivate("User Accounts")
   If PixelGetColor(430,270) = 16777215 Then
	  Return True
   ElseIf PixelGetColor(430,270) = 15790320 Then
	  Return False
   Else
	  Return 0
   EndIf
EndFunc
