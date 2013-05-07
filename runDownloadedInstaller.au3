#RequireAdmin

$version = "Firefox 21.0 (Beta 6)"
$download_path = "C:\FirefoxProject\downloads\"

runDownloadedInstaller($version, $download_path)

Func runDownloadedInstaller($version, $download_path)
   $done = 0
   While $done = 0
	  $done = Run($download_path&$version&"\"&$version&".exe")
	  MsgBox(0,"",$download_path&$version&".exe")
   WEnd
EndFunc