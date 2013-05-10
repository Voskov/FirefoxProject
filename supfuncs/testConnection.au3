MsgBox(0,"connected",testConnection())

Func testConnection()
   $ping = Ping("www.google.com")
   if $ping > 0 Then
	  $connected = "True"
   Else
	  $connected = "False"
   EndIf
   Return $connected
EndFunc
   