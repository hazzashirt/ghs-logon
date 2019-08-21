Dim x, iCounter, sCommand, sHost, WshShell, sProcess
On Error Resume Next

Set WshShell = wscript.createObject("wscript.shell")

iCounter = 0
iAttempts = 60
sHost = "8385hr0002sf001"
sProcess = "powershell.exe -executionpolicy bypass -NoLogo -NonInteractive -file ""\\8385HR0002SF001\NETLOGON\logon.ps1"""

'Let's loop through the attempts
Do While iCounter < iAttempts
	'Ping command line and switches
	sCommand = "ping -n 1 -w 300 " & sHost

	'Run ping and get results
	ReturnCode = WshShell.Run(sCommand, 0, True)
	'0 = pingable, 1 = no response
	If ReturnCode = 0 Then
		'Start Process
		WshShell.run sProcess,0
		wscript.quit
	Else
		'Delay - 1000 = 1 second
		wscript.sleep 2000
	End If
	iCounter = iCounter + 1
Loop
