$version = "Firefox 21.0 (Beta 6)"
$path = "C:\FirefoxProject\installs\"



openOneFirefox($version, $path)

Func openOneFirefox($version, $path)
   Run($path&$version&"\firefox.exe")
   WinWait("Mozilla Firefox")
   WinActivate("Mozilla Firefox")
   WinWaitActive("Mozilla Firefox")
   Sleep(1000)
   Send("^l")
   Send("www.trusteer.com")
   Send("{Enter}")
EndFunc