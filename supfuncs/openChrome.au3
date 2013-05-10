;open chrome
openChrome()

Func openChrome()
   Run("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
   WinWait("New Tab - Google Chrome")
   WinActivate("New Tab - Google Chrome")
   WinWaitActive("New Tab - Google Chrome")
   Send("#{up}")
EndFunc
