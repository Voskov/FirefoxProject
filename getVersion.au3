Local $configuration_file = FileOpen("configuration.properties", 0)
Local $line = 1

; Check if file opened for reading OK
If $configuration_file = -1 Then
   MsgBox(0, "Error", "Unable to open the configuration file.")
   Exit
EndIf
 
$a = getVersion($configuration_file, $line)
MsgBox(0,"",$a)

FileClose("configuration.properties")

Func getVersion($configuration_file, $line)
   $version = FileReadLine($configuration_file, $line)
   return $version
EndFunc
