' VBScript for silently running the powershell script
Dim shell,command


Dim x
On Error Resume Next

x = 0
Do Until x = 1
Err.Clear
command = "powershell.exe -executionpolicy bypass -NoLogo -NonInteractive -file ""\\8385HR0002SA001\NETLOGON\logon.ps1"""

set shell = CreateObject("WScript.Shell")

shell.Run command,0

If Err.Number = 0 Then
  command = "powershell.exe -executionpolicy bypass -NoLogo -NonInteractive -file ""\\8385HR0002SF001\NETLOGON\logon.ps1"""

set shell = CreateObject("WScript.Shell")

shell.Run command,0
  a = MsgBox("Do you like red color?",3,"Choose options")
  x = 1
End If
WScript.Sleep(3000)
Loop
