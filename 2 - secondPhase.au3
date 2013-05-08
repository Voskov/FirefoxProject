#RequireAdmin;

$configuration_file = getConfigurationFile(@WorkingDir&"\configuration.properties")
$installation_path = IniRead(@WorkingDir&"\credentials.ini","Paths","installation","ERROR -1")



;~ rSend("#d")
;~ Sleep(10000)
undoStuff()
;~ openEveryFirefox()

Func undoStuff()
   removeStartupLink()
   undoLoginBypass()
EndFunc

Func openEveryFirefox()
   $version_counter = 1
   While 1
	  $version = getVersion($configuration_file, $version_counter)
	  If $version = "" Then ExitLoop
	  MsgBox(0,"Open Firefox","Open version "&$version,1)
	  openOneFirefox($version, $installation_path)
	  $version_counter = $version_counter + 1
   WEnd
EndFunc

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

Func openOneFirefox($version, $installation_path)
   Run($installation_path&$version&"\firefox.exe")
   WinWait("Mozilla Firefox")
   WinActivate("Mozilla Firefox")
   WinWaitActive("Mozilla Firefox")
   Sleep(1000)
   Send("^l")
   Send("www.trusteer.com")
   Send("{Enter}")
EndFunc

Func getConfigurationFile($file_name)
   $configuration_file = FileOpen($file_name, 0)
   ; Check if file opened for reading OK
   If $configuration_file = -1 Then
	  MsgBox(0, "Error", "Unable to open the configuration file")
	  Exit
   EndIf
   Return $configuration_file
EndFunc
Func getVersion($configuration_file, $line)
   $version = FileReadLine($configuration_file, $line)
   return $version
EndFunc
Func removeStartupLink()
   FileDelete(@StartupDir&"\firefoxStartup.lnk")
EndFunc
