getConfigurationFile("configuration.properties")

Func getConfigurationFile($file_name)
   $configuration_file = FileOpen($file_name, 0)
   ; Check if file opened for reading OK
   If $configuration_file = -1 Then
	  MsgBox(0, "Error", "Unable to open the configuration file.")
	  Exit
   EndIf
EndFunc