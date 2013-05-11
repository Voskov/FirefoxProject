#RequireAdmin

HotKeySet("^+z", "Terminate")
Opt("WinTitleMatchMode", 2)
$versions_file = getConfigurationFile(@WorkingDir&"\versions.txt")
$installation_path = IniRead(@WorkingDir&"\configuration.ini","Paths","installation","ERROR -1")
$log_path = IniRead(@WorkingDir&"\configuration.ini","Paths","log","ERROR -1")

Global $log = FileOpen(IniRead(@WorkingDir&"\configuration.ini","Logs","last_log",0),1)
addToLog("Second phase has begun")


Send("#d")
Sleep(10000)
openEveryFirefox()
verifyProccess()
undoStuff()
lookForErrors()


Func undoStuff()
   removeStartupLink()
   If checkIfUserBoxChecked() Then
	  undoLoginBypass()
   EndIf   
EndFunc

Func openEveryFirefox()
   $version_counter = 1
   While getVersion($versions_file, $version_counter) <> ""
	  $version = getVersion($versions_file, $version_counter)
	  MsgBox(0,"Open Firefox","Open version "&$version,1)
	  If openOneFirefox($version, $installation_path),2) = 1 Then
		 verifyPageLoadFirefox($version)
	  EndIf
	  $version_counter = $version_counter + 1
   WEnd
EndFunc

Func undoLoginBypass()
   Send("#r") ;run
   Sleep(100)
   WinActivate("Run")
   Send("netplwiz")
   Send("{Enter}")
   WinWaitActive("User Accounts")
   Sleep(100)
   Send("!e")
   Sleep(100)
   Send("{Enter}")
   addToLog("Undid the login bypass")
EndFunc

Func openOneFirefox($version, $installation_path)
   if Run($installation_path&$version&"\firefox.exe") = 0 Then
	  MsgBox(48,"ERROR","Could not open "&$version)
	  addToLog("Could not open "&$version)
	  Return 0
   Else
	  Sleep(2000)
	  If WinExists("Import Wizard") Then
		 WinActivate("Import Wizard")
		 importWizzard()
	  EndIf
	  If WinExists("Default Browser") Then
		 WinActivate("Default Browser")
		 Sleep(100)
		 defaultBrowser()
	  EndIf
	  Sleep(2000)
	  Send("{F6}")
	  Send("www.trusteer.com")
	  Send("{Enter}")
	  Return 1
   EndIf
EndFunc



Func verifyPageLoadFirefox($version)
   $loaded = 0
   $timer = TimerInit()
   While $loaded = 0
	  If WinActive("Trusteer - Mozilla Firefox") Then
		 ExitLoop
	  EndIf
	  if Floor(TimerDiff($timer)) = 5000 Then
		 MsgBox(0,"Waiting","Just waitig for the page to load",3)
	  ElseIf Floor(TimerDiff($timer)) = 15000 Then
		 MsgBox(0,"Reloading","Let's try to reload the page",3)
		 WinActivate("Mozilla Firefox")
		 Send("{F6}")
		 Send("www.trusteer.com")
		 Send("{Enter}")
	  ElseIf Floor(TimerDiff($timer)) > 25000 Then
		 MsgBox(0,"aborting","This page isn't going to load, aborting and closing the browser",4)
		 addToLog("ERROR: Couldn't load the page on "&$version)
		 WinActivate("Mozilla Firefox")
		 Send("!{F4}")
		 Sleep(300)
		 if WinActivate("Confirm close") Then
			Send("{Enter}")
		 EndIf
		 ExitLoop
	  EndIf
   WEnd
EndFunc

Func verifyProccess()
   if ProcessExists("firefox") Then
	  MsgBox(0,"","The proccess exists",3)
   Else
	  MsgBox(48,"ERROR","Could not find the proccess")
	  addToLog("ERROR: Could not find the proccess")
   EndIf
EndFunc
   
Func lookForErrors()
   Send("#r")
   WinWaitActive("Run")
   Send(IniRead(@WorkingDir&"\configuration.ini","Logs","last_log",0))
   send("{Enter}")
   Sleep(500)
   WinWaitActive(StringTrimLeft(IniRead(@WorkingDir&"\configuration.ini","Logs","last_log",0),23))
   Sleep(200)
   Send("^f")
   Send("Error")
   Send("{Enter}")
   Sleep(200)
   if WinExists("Notepad","Cannot find ""Error""") Then
	  Send("{Esc}{Esc}")
	  Sleep(100)
	  WinClose(StringTrimLeft(IniRead(@WorkingDir&"\configuration.ini","Logs","last_log",0),23)&" - Notepad")
	  MsgBox(0,"Success","Script was completed successfully")
   Else
	  Send("{Esc}")
	  MsgBox(0,"Success","Script finished with some errors")
   EndIf
EndFunc

Func importWizzard()
   Send("!d") ;don't import
   Sleep(50)
   Send("!n")
EndFunc

Func defaultBrowser()
   Send("!n")
EndFunc


Func getConfigurationFile($file_name)
   $versions_file = FileOpen($file_name, 0)
   ; Check if file opened for reading OK
   If $versions_file = -1 Then
	  MsgBox(0, "Error", "Unable to open the file")
	  Exit
   EndIf
   Return $versions_file
EndFunc

Func getVersion($versions_file, $line)
   $version = FileReadLine($versions_file, $line)
   return $version
EndFunc

Func removeStartupLink()
   If FileExists(@StartupDir&"\firefoxStartup.lnk") = 1 Then
	  if FileDelete(@StartupDir&"\firefoxStartup.lnk") = 1 Then
		 addToLog("Startup shortcut was removed")
	  Else
		 MsgBox(48,"ERROR","Could not remove the shortcut from the startup folder, please remove it manually")
		 addToLog("ERROR: Could not remove the shortcut from the startup folder")
	  EndIf
   EndIf
EndFunc

Func addToLog($String)
   FileWriteLine($log,current_time()&" - "&$String)
EndFunc
Func current_time()
   Return @MDAY&"\"&@MON&"\"&@YEAR&"_"&@HOUR&":"&@MIN&":"&@SEC
EndFunc   
Func Terminate()
    addToLog("Script was terminated manually")
	Exit 0
 EndFunc
 
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