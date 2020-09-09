Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,135'
$Form.text                       = "GHS Login"
$Form.BackColor                  = "#ffffff"
$Form.TopMost                    = $false
# This base64 string holds the bytes that make up the orange 'G' icon (just an example for a 32x32 pixel image)
$iconBase64      = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAI2SURBVDhPbVJLaxNRFI4QtGlNpZYKLlwURSw+QCpStNhWkww27dDJOIIamtZuitCF6MI/IPhAEaxoixZFENy5Fly6ERE3iohgUVBEobZJzLzufJ5z52Yyg34Mcx6c893v3HNTiCMAdo/mkD6hoUsvoEbx65WfaC9p6DAK2GbkVWELEcGWsgHHcahQg09x3RX4AiFJPeGjuziMOuX/NBy0TRyVPQxJ8M218YNsWh+B7/tYVxyUKtpLOXSeHidbQGpsENkzRXSW8sjkD6PBjYRIQdrKITuhkSfQbRVhc5JOp0+iw9Sk30YEG6RP6ggRwQr/qILlMx5U9uCuuYNm+Y6l8i6VJQiBuuepIEaQoQtyAxERSAQuHk/1ka2qRIj1+rDyYgSM7XpOeXSQvSZtAJf+Lppnbh07prwQCYIgaE6s4Hyl3t/RPaixE0gSqN8mte9mI9seiy44MV+IkECEMzYEC6UtFPqplqQHSjjZ3tIQPFp3BFGTJnWpchxPb16QAa+HwQ+G992UwC/x3Ro1U5wxC/Crv7BQ2Yv5mUNIXZ0+ghtnB3B/diBUyHNS4fPFyxxJXJseoXx4Abz/xvIb3KocwJUZemAyK0GSV98ja7Q2UWVGryW766SBRxfH6fT9KhO7RKmWb732CXfODVH3Z9wu78TDyV4slvvgOS7mz5u4d4oeV2wdiS0wPr58hg+vXuDJ3EHYto2FqX4sTe7D6vJbXJ8z4XuOqgzxD0Ecmy0dG61RFf0PwF9M0mQalEsZ3QAAAABJRU5ErkJggg=='
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$Form.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())
$Form.FormBorderStyle = "FixedDialog"
$Form.TopMost = $True

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 120
$PictureBox1.height              = 120
$PictureBox1.location            = New-Object System.Drawing.Point(10,10)
$PictureBox1.imageLocation       = "D:\My Drive\Desktop\Projects\BYOD-Logon\PS2EXE-GUI (1)\Logo.jpg"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$userbox                         = New-Object system.Windows.Forms.TextBox
$userbox.multiline               = $false
$userbox.width                   = 100
$userbox.height                  = 20
$userbox.location                = New-Object System.Drawing.Point(220,18)
$userbox.Font                    = 'Microsoft Sans Serif,10'

$passbox                         = New-Object system.Windows.Forms.MaskedTextBox
$passbox.multiline               = $false
$passbox.width                   = 100
$passbox.height                  = 20
$passbox.PasswordChar            = "*"
$passbox.location                = New-Object System.Drawing.Point(242,54)
$passbox.Font                    = 'Microsoft Sans Serif,10'

$username                        = New-Object system.Windows.Forms.Label
$username.text                   = "Username:"
$username.AutoSize               = $true
$username.width                  = 27
$username.height                 = 10
$username.location               = New-Object System.Drawing.Point(140,22)
$username.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$detnsw                          = New-Object system.Windows.Forms.Label
$detnsw.text                     = "@detnsw"
$detnsw.AutoSize                 = $true
$detnsw.width                    = 25
$detnsw.height                   = 10
$detnsw.location                 = New-Object System.Drawing.Point(321,22)
$detnsw.Font                     = 'Microsoft Sans Serif,10'

$password                        = New-Object system.Windows.Forms.Label
$password.text                   = "password:"
$password.AutoSize               = $true
$password.width                  = 27
$password.height                 = 10
$password.location               = New-Object System.Drawing.Point(172,58)
$password.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$faculty                        = New-Object system.Windows.Forms.Label
$faculty.text                   = "Faculty:"
$faculty.width                    = 25
$faculty.height                   = 10
$faculty.AutoSize               = $true
$faculty.location               = New-Object System.Drawing.Point(140,52)
$faculty.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$checkbox1                       = New-Object system.Windows.Forms.CheckBox
$checkbox1.text                  = "Open detnsw.net"
$checkbox1.AutoSize              = $false
$checkbox1.width                 = 200
$checkbox1.height                = 20
$checkbox1.location              = New-Object System.Drawing.Point(285,85)
$checkbox1.Font                  = 'Microsoft Sans Serif,10'

$ProgressBar1                    = New-Object system.Windows.Forms.ProgressBar
$ProgressBar1.width              = 170
$ProgressBar1.height             = 20
$ProgressBar1.location           = New-Object System.Drawing.Point(140,100)


$ProgressBarLabel                = New-Object system.Windows.Forms.Label
$ProgressBarLabel.location       = New-Object System.Drawing.Point(150,85)
$ProgressBarLabel.width          = 200
$ProgressBarLabel.height         = 20
$ProgressBarLabel.text           = ""
$ProgressBarLabel.Font           = 'Microsoft Sans Serif,8'

$loginbutton                     = New-Object system.Windows.Forms.Button
$loginbutton.text                = "Login"
$loginbutton.width               = 60
$loginbutton.height              = 25
$loginbutton.location            = New-Object System.Drawing.Point(330,50)
$loginbutton.Font                = 'Microsoft Sans Serif,10'

$closebutton                     = New-Object system.Windows.Forms.Button
$closebutton.text                = "Cancel"
$closebutton.width               = 60
$closebutton.height              = 25
$closebutton.location            = New-Object System.Drawing.Point(330,95)
$closebutton.Font                = 'Microsoft Sans Serif,10'


$comboBox                         = New-Object System.Windows.Forms.ComboBox
$comboBox.DropDownStyle           = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$comboBox.Size                    = New-Object System.Drawing.Size(100,20)
$comboBox.Height                  = 80
$comboBox.Location                = New-Object System.Drawing.Point(220,51)


[void] $comboBox.Items.Add('Library')
[void] $comboBox.Items.Add('Maths')
[void] $comboBox.Items.Add('English')
[void] $comboBox.Items.Add('Science')
[void] $comboBox.Items.Add('CAPA')
[void] $comboBox.Items.Add('HSIE')
[void] $comboBox.Items.Add('TAS')
[void] $comboBox.Items.Add('PE')
[void] $comboBox.Items.Add('Support')
[void] $comboBox.Items.Add('Learning Support')
$comboBox.SelectedIndex           = 0


$Form.controls.AddRange(@($PictureBox1,$loginbutton,$closebutton,$userbox,$username,$detnsw,$faculty,$ProgressBar1,$comboBox,$ProgressBarLabel)) #$passbox, $password, $checkbox1

#$loginbutton.Add_Click({processLogin})

$loginbutton.Add_MouseUp({processLogin})
$closebutton.Add_MouseUp({$Form.Close()})
$loginbutton.Add_Keydown({if ($_.KeyCode -eq "Enter"){processLogin}})
$userbox.Add_Keydown({if ($_.KeyCode -eq "Enter"){processLogin}})
$comboBox.Add_Keydown({if ($_.KeyCode -eq "Enter"){processLogin}})
$Form.Add_Keydown({if ($_.KeyCode -eq "Enter"){processLogin}})
function processLogin ()
{
    if ($userbox.Text -eq ""){
        [System.Windows.Forms.MessageBox]::Show("Please enter a username","Error",[System.Windows.Forms.MessageBoxButtons]::OK)
        return
    }
    $user = $($userbox.Text+"@det.nsw.edu.au")
    $pass = $passbox.text
    $ProgressBar1.Value = 10
    $ProgressBarLabel.Text = "Mapping Faculty"
    mapDrive "T:" "\\8385dip000sf001\Faculty" $user $pass
    $ProgressBar1.Value = 20
    $ProgressBarLabel.Text = "Mapping Collaboration"
    mapDrive "P:" "\\8385dip000sf001\Collaboration" $user $pass
    $ProgressBar1.Value = 30
    $ProgressBarLabel.Text = "Mapping Network_Applications"
    mapDrive "S:" "\\8385dip000sf003\Network_Applications" $user $pass
    $ProgressBar1.Value = 40
    $ProgressBarLabel.Text = "Mapping Data_8385"
    mapDrive "F:" "\\8385hr0002sf001\Data_8385" $user $pass
    $ProgressBar1.Value = 50
    $ProgressBarLabel.Text = "Mapping iPad"
    mapDrive "I:" "\\8385hr0002sf001\iPad" $user $pass
    $ProgressBar1.Value = 60
    $ProgressBarLabel.Text = "Mapping Apps_8385"
    mapDrive "Q:" "\\8385dip000sf003\Apps_8385" $user $pass
    
    $homepath = $("\\8385dip000sf001\Staff\_"+$userbox.Text)
    try{
        $ProgressBar1.Value = 70
        $ProgressBarLabel.Text = "Mapping Home"
        mapDrive "U:" $homepath $user $pass
        if ($LASTEXITCODE -eq 0){
            Write-Host "Successfully mapped drive"
        } else {
            Write-Error "Failed to map drive"
            throw $error[0].Exception
        }
    }
    catch [System.Exception] {
        [System.Windows.Forms.MessageBox]::Show("Failed to map U: drive","Error",[System.Windows.Forms.MessageBoxButtons]::OK)
        #$ProgressBar1.value = 0
        #$ProgressBarLabel.Text = ""
        #return
    }
    DelOSCNetworkPrinters
    mapPrinter($comboBox.text)
    [System.Windows.Forms.MessageBox]::Show("Finished mapping printers and drivers!","Completed",[System.Windows.Forms.MessageBoxButtons]::OK)
    #if ($checkbox1.checked -eq $True) {
        
    #}
    Start-Process "http://detnsw.net"
    $Form.Close()

}

Function DelOSCNetworkPrinters
{
	$NetworkPrinters = Get-WmiObject -Class Win32_Printer | Where-Object{$_.Network}
	If ($null -ne $NetworkPrinters)
	{
		Try
		{
			Foreach($NetworkPrinter in $NetworkPrinters)
			{
				$NetworkPrinter.Delete()
				Write-Host "Successfully deleted the network printer:" + $NetworkPrinter.Name -ForegroundColor Green	
			}
		}
		Catch
		{
			Write-Host $_
		}
	}
	Else
	{
		Write-Warning "Cannot find network printer in the currently environment."
	}
}


function mapDrive
{
    param([string]$letter, [string]$path, [string]$user, [string]$pass)
    Write-Host $letter, $user, $path, $pass
    Start-Job -ScriptBlock { net use $letter /delete /y}
    Start-Job -ScriptBlock { net use $letter $path /persistent:yes }
    $Timeout = 5
    $jobs = Get-Job
    $Condition = {param($jobs) 'Running' -notin $jobs.State }
    $ConditionArgs = $jobs
    $RetryInterval = 5 ## seconds
    $timer = [Diagnostics.Stopwatch]::StartNew()
    while (($timer.Elapsed.TotalSeconds -lt $Timeout) -and (& $Condition $ConditionArgs)) {
 
         ## Wait a specific interval
         Start-Sleep -Seconds $RetryInterval
 
         ## Check the time
         $totalSecs = [math]::Round($timer.Elapsed.TotalSeconds,0)
         Write-Verbose -Message "Still waiting for action to complete after [$totalSecs] seconds..."
     }
    $timer.Stop()
    if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
         throw 'Action did not complete before timeout period.'
     } else {
         Write-Verbose -Message 'Action completed before the timeout period.'
     }
    
    <#$pass = ConvertTo-SecureString $passbox.Text -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PsCredential($user,$pass)
    
    New-PSDrive -Name "U" -Root $("\\8385dip000sf001\Staff\_"+$userbox.Text) -Persist -PSProvider fileSystem -Credential $Cred#>
}

function mapPrinter
{
    param([string]$faculty)
    $ProgressBar1.Value = 80
    $ProgressBarLabel.Text = "Mapping Faculty printer"
    switch ($faculty) {
        'Maths' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\GR0039 - Maths") ; break}
        'English' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\ER1010 - English") ; break}
        'Science' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\AR0027 - Science Staff") ; break}
        'CAPA' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\GR0036 - CAPA") ; break}
        'HSIE' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\DR1017 - HSIE")
        (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\DR1017 - HSIE 2") ; break}
        'TAS' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\CR0026 - TAS") ; break}
        'PE' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\AR1025 - PE") ; break}
        'Support' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\GR1043 - Support") ; break}
        'Learning Support' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\ER0007 - Learning Support") ; break}
        Default { break; }
    }
    $ProgressBar1.Value = 90
    $ProgressBarLabel.Text = "Mapping Library printer"
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\HR0015 - Library Students")
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\HR0015 - Library Students (Colour)")
    $ProgressBar1.Value = 100
    $ProgressBarLabel.Text = "Completed!"
}

$Form.ShowDialog()
