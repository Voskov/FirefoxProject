#RequireAdmin

Opt("WinTitleMatchMode", 2)
HotKeySet("^+z", "Terminate")
$all_versions = getVersionsFile(@WorkingDir&"\versions.txt")
$download_path = IniRead(@WorkingDir&"\configuration.ini","Paths","download","ERROR -1")
$installation_path = IniRead(@WorkingDir&"\configuration.ini","Paths","installation","ERROR -1")
$log_path = IniRead(@WorkingDir&"\configuration.ini","Paths","log","ERROR -1")
$defaultUsername = IniRead(@WorkingDir&"\configuration.ini","Credentials","username","ERROR -1")
$defaultPassword = IniRead(@WorkingDir&"\configuration.ini","Credentials","password","ERROR -1")

Global $log = createLog($log_path)
addToLog("log created - script started")

getCredentials()
downloadEverything()
installEverything()
restart()

Func downloadEverything()
   $version_counter = 1
   MsgBox(0,"","open chrome",1)
   openChrome()
   MsgBox(0,"","go to download page",1)
   goToDownloadPage()
   While 1
	  $version = getVersion($all_versions, $version_counter)
	  If $version = "" Then ExitLoop
	  WinWaitActive("Old Version of Firefox Download - OldApps.com - Google Chrome")
	  MsgBox(0,"","find version "&$version,1)
	  findVersion($version)
	  MsgBox(0,"","select it",1)
	  pickSelectedVersion($version)
	  MsgBox(0,"","Download it",1)
	  downloadOneVersion($version, $download_path)
	  $version_counter = $version_counter + 1
   WEnd
EndFunc

Func installEverything()
   $version_counter = 1
   While getVersion($all_versions, $version_counter) <> ""
	  $version = getVersion($all_versions, $version_counter)
	  If $version_counter = 1 Then MsgBox(0,"","Run installer",1)
	  if runDownloadedInstaller($version, $download_path) == 1 Then
		 installFirefox($version, $installation_path)
	  EndIf
	  $version_counter = $version_counter + 1
   WEnd
EndFunc

Func restart()
   FileClose($all_versions)
   createStartupShortcut()
   bypassLogin($defaultUsername, $defaultPassword)
   reboot()
   FileClose($log)
EndFunc

Func openChrome()
   if Run("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") = 0 Then
	  addToLog("ERROR: could not open chrome")
	  MsgBox(48,"ERROR","Could not open Chrome, please open manually or quit the script")
   EndIf
   
   WinWait("New Tab - Google Chrome")
   WinActivate("New Tab - Google Chrome")
   WinWaitActive("New Tab - Google Chrome")
   Send("#{up}")
EndFunc

Func goToDownloadPage()
   WinActivate("New Tab - Google Chrome")
   WinWaitActive("New Tab - Google Chrome")
   Sleep(500)
   Send("^l")
   Send("http://www.oldapps.com/firefox.php")
   Send("{Enter}")
   Sleep(4000)
   $counter = 1
   While WinWait("Old Version of Firefox Download - OldApps.com - Google Chrome","www.oldapps.com/firefox.php",5) = 0
	  addToLog("ERROR: Could not load download page - retrying")
	  WinActivate("New Tab - Google Chrome")
	  Send("{f5}")
	  
	  if $counter > 3 Then
		 addToLog("Done retrying to load the page - exiting")
		 MsgBox(48,"ERROR","Could not load the download page, please check your internet connection and run the script again")
		 Exit
	  EndIf
	  $counter = $counter + 1
   WEnd  
EndFunc

Func findVersion($version)
   WinActivate("Old Version of Firefox Download - OldApps.com - Google Chrome")
   WinWaitActive("Old Version of Firefox Download - OldApps.com - Google Chrome")
   Send("^f")
   Sleep(30)
   Send($version)
   Send("{Esc}")
EndFunc

Func pickSelectedVersion($version)
   WinActivate("Old Version of Firefox Download - OldApps.com - Google Chrome")
   WinWaitActive("Old Version of Firefox Download - OldApps.com - Google Chrome")
   Send("^{Enter}")
   Sleep(1000)
   Send("^{Tab}")
   WinWaitActive("Old Version of "&$version&" Download")
   Sleep(2000)
EndFunc

Func downloadOneVersion($version, $download_path)
   ceateDownloadFolder($version, $download_path)
   
   WinActivate("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   WinWaitActive("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   Send("^f")
   Sleep(30)
   send("screenshots")
   Send("{esc}")
   Send("{tab}{tab}")
   Send("{enter}")
   $counter = 1
   while WinWait("Save As", "", 10) = 0
	  WinActivate("Download")
	  Send("^f")
	  Send($version)
	  Send("{f3}")
	  Send("{Esc}")
	  send("{Enter}")		; direct download
	  if WinWaitActive("Save As", "", 10) = 0 Then
		 Send ("{f5}") 		; if still doesn't work, refresh the page
	  Else
		 ExitLoop			; if successfull, get out of loop and proceed
	  EndIf
	  $counter = $counter + 1
	  if $counter >= 4 Then
		 addToLog("Could not download "&$version&", skipping")
		 MsgBox(48,"","Could not download "&$version&", skipping",3)
		 WinActivate("Download")
		 Send("^w")
		 Return
	  EndIf
   WEnd
   WinActivate("Save As")
   send($version&".exe")
   Send("{F4}")
   Send("^a")
   Send($download_path&$version)
   Send("{Enter}")
   Sleep(30)
   Send("!s")
   Sleep(150)
   if WinActive("Confirm Save As") Then ;in case of an overwrite
	  Send("!y")
   EndIf
   addToLog("began downloading "&$version)
   WinActivate("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   Sleep(30)
   Send("^w")
   Sleep(50)
EndFunc

Func runDownloadedInstaller($version, $download_path)
   $done = 0
   $timer = 1
   While $done = 0
	  $done = Run($download_path&$version&"\"&$version&".exe")
	  Sleep(1000)
	  if $timer = 5 Then
		 MsgBox(0,"Wait","Don't worry, just waiting for the download to finish",3)
	  ElseIf $timer = 15 Then
		 MsgBox(0,"Wait","Still waiting",3)
	  ElseIf $timer = 30 Then ;TODO: change times
		 MsgBox(0,"Error","Well this is getting ridiculous, this download isn't going to finish. giving up", 5)
		 addToLog("ERROR: Could not download "&$version)
		 Return 0
	  EndIf
	  $timer = $timer + 1
   WEnd
   Return 1
EndFunc

Func installFirefox($version, $installation_path)
   addToLog("Installing "&$version)
   WinWait("Mozilla Firefox Setup")
   WinActivate("Mozilla Firefox Setup")
   WinWaitActive("Mozilla Firefox Setup")
   SendKeepActive("Mozilla Firefox Setup")
   Sleep(100)
   Send("!n") ;1st next
   Sleep(100)
   Send("!c") ;choose custom
   Sleep(100)
   Send("!n") ;next
   Send($installation_path&$version) ;insert installation path
   Sleep(100)
   Send("!n") ;next
   Sleep(100)
   Send("!ds") ;remove checkboxes (desktop and start menu)
   Sleep(100)
   Send("!n") ;next
   Sleep(200)
   if (winGetText("Mozilla Firefox Setup", "Install")) <> "0" Then
	  Send("!i") ;install
   ElseIf (winGetText("Mozilla Firefox Setup", "Upgrade")) <> "0" Then
	  Send("!u") ;upgrade
   EndIf
   Sleep(100)
   WinWait("Mozilla Firefox Setup","Completing the Mozilla Firefox Setup Wizard",200)
   Send("!l") ;don't launch
   Sleep(100)
   Send("!f") ;finish
   addToLog($version&" installed")
EndFunc
   
Func ceateDownloadFolder($version, $download_path)
   $created = DirCreate($download_path&$version)
   if $created = 0 Then
	  MsgBox(48, "failure", '"C:\FirefoxProject\Downloads\'&$version&'" could NOT be created')
   EndIf
EndFunc

Func getVersionsFile($file_name)
   $all_versions = FileOpen($file_name, 0)
   ; Check if file opened for reading OK
   If $all_versions = -1 Then
	  MsgBox(0, "Error", "Unable to open the versions file.")
	  Exit
   EndIf
   Return $all_versions
EndFunc

Func getVersion($all_versions, $line)
   $version = FileReadLine($all_versions, $line)
   return $version
EndFunc

Func bypassLogin($username, $password)
   ;TODO - read checkbox
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
   addToLog("Bypass login performed successfully")
EndFunc

Func reboot()
   if Run("shutdown -r -f -t 20") <> 0 Then
	  addToLog("rebooting")
	  sleep(2000)
	  Send("{Space}")
   Else 
	  addToLog("ERROR: can't reboot")
	  MsgBox(48,"ERROR","ERROR: can't reboot, please restart manually")
   EndIf
EndFunc

Func getUsername($defaultUsername)
   $username = InputBox("Username", "Please type your system username. This is required to login later", $defaultUsername,"",-1,-1,500,400,2)
   If $username = "" Then $username = $defaultUsername
   Return $username
EndFunc

Func getPassword($defaultPassword)
   $password = InputBox("Password", "Please type your system password. This is required to login later", $defaultPassword,"*",-1,-1,500,400,2)
   If $password = "" Then $password = $defaultPassword
   Return $password
EndFunc

Func getCredentials()
   getUsername($defaultUsername)
   getPassword($defaultPassword)
EndFunc

Func createStartupShortcut()
   if FileCreateShortcut(@workingdir&"\2 - secondPhase.exe",@StartupDir&"\firefoxStartup.lnk",@workingdir) = 1 Then
	  addToLog("startup shortcut was created successfully")
   Else
	  addToLog("ERROR: startup shortcut was NOT created")
	  MsgBox(48,"ERROR","startup shortcut was NOT created, you will have to start the second phase manually after the restart")
   EndIf
EndFunc
Func current_time()
   Return @MDAY&"\"&@MON&"\"&@YEAR&"_"&@HOUR&":"&@MIN&":"&@SEC
EndFunc

Func createLog($path)
   DirCreate($path)
   IniWrite(@WorkingDir&"\configuration.ini","Logs","last_log",$path&@MDAY&"."&@MON&"."&@YEAR&"_"&@HOUR&@MIN&".log")
   Return FileOpen($path&"\"&@MDAY&"."&@MON&"."&@YEAR&"_"&@HOUR&@MIN&".log",1)
EndFunc

Func addToLog($String)
   FileWriteLine($log,current_time()&" - "&$String)
EndFunc
   
Func Terminate()
    addToLog("Script was terminated manually")
	Exit 0
EndFunc