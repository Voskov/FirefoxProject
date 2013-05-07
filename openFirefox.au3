#RequireAdmin;
$version = "Firefox 21.0 (Beta 6)"
$path = "C:\FirefoxProject\Installs"
$filepath = $path&"\"&$version&"\firefox.exe"
Send("#r")
Sleep(500)
Send($filepath)
Send("{Enter}")
WinWait("Mozilla Firefox Start Page - Mozilla Firefox")
If ProcessExists("firefox.exe") Then
EndIf
WinActivate("Mozilla Firefox Start Page - Mozilla Firefox")
Send("^l")
Send("http://www.trusteer.com")
Send("{Enter}")