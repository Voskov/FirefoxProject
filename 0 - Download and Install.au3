#RequireAdmin

$version_counter = 1
$configuration_file = getConfigurationFile("configuration.properties")
$download_path = "C:\FirefoxProject\downloads\"
$installation_path = "C:\FirefoxProject\installs\"
;$version = getVersion($configuration_file, $version_counter)


;~ MsgBox(0,"","open chrome",1)
openChrome()
;~ MsgBox(0,"","go to download",1)
goToDownloadPage()
While 1
   $version = getVersion($configuration_file, $version_counter)
   If $version = "" Then ExitLoop
   WinWaitActive("Old Version of Firefox Download - OldApps.com - Google Chrome")
;~    If $version_counter = 1 Then MsgBox(0,"","find version "&$version,1)
   findVersion($version)
;~    If $version_counter = 1 Then MsgBox(0,"","select it",1)
   pickSelectedVersion($version)
;~    If $version_counter = 1 Then MsgBox(0,"","Download it",1)
   downloadOneVersion($version, $download_path)
   $version_counter = $version_counter + 1
WEnd
MsgBox(0,"Done","Done downloading",2)
$version_counter = 1
While 1
   $version = getVersion($configuration_file, $version_counter)
   If $version = "" Then ExitLoop
   If $version_counter = 1 Then MsgBox(0,"","Run once download is finished",1)
   runDownloadedInstaller($version, $download_path)
   If $version_counter = 1 Then MsgBox(0,"","install",1)
   installFirefox($version, $installation_path)
   $version_counter = $version_counter + 1
WEnd   
MsgBox(0,"Done","Done installing",2)
FileClose("configuration.properties")

;ProcessClose("chrome.exe")

Func openChrome()
   Run("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
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
   Sleep(5000)
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
   WinWaitActive("Save As")
   sleep(50)
   send($version&".exe")
   Send("{tab}{tab}{tab}{tab}{tab}")
   Send("{Enter}")
   Send($download_path&$version)
   Send("{Enter}")
   Sleep(30)
   Send("!s")
   Sleep(50)
   if WinActive("Confirm Save As") Then ;in case of an overwrite
	  Send("!y")
   EndIf
   WinActivate("Old Version of "&$version&" Download - OldApps.com - Google Chrome")
   Sleep(30)
   Send("^w")
EndFunc

Func runDownloadedInstaller($version, $download_path)
   $done = 0
   While $done = 0
	  $done = Run($download_path&$version&"\"&$version&".exe")
   WEnd
EndFunc

Func installFirefox($version, $installation_path)
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
   Sleep(100)
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
EndFunc
   
Func ceateDownloadFolder($version, $download_path)
   $created = DirCreate($download_path&$version)
   if $created = 0 Then
	  MsgBox(48, "failure", '"C:\FirefoxProject\Downloads\'&$version&'" could NOT be created')
   EndIf
EndFunc

Func getConfigurationFile($file_name)
   $configuration_file = FileOpen($file_name, 0)
   ; Check if file opened for reading OK
   If $configuration_file = -1 Then
	  MsgBox(0, "Error", "Unable to open the configuration file.")
	  Exit
   EndIf
   Return $configuration_file
EndFunc

Func getVersion($configuration_file, $line)
   $version = FileReadLine($configuration_file, $line)
   return $version
EndFunc

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

