Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '454,170'
$Form.text                       = "GHS Login"
$Form.BackColor                  = "#ffffff"
$Form.TopMost                    = $false

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 137
$PictureBox1.height              = 136
$PictureBox1.location            = New-Object System.Drawing.Point(16,13)
$PictureBox1.imageLocation       = "\\8385dip000sf001\Staff\_harry.thang1\Desktop\Logo.jpg"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$userbox                         = New-Object system.Windows.Forms.TextBox
$userbox.multiline               = $false
$userbox.width                   = 100
$userbox.height                  = 20
$userbox.location                = New-Object System.Drawing.Point(242,18)
$userbox.Font                    = 'Microsoft Sans Serif,10'

$passbox                         = New-Object system.Windows.Forms.MaskedTextBox
$passbox.multiline               = $false
$passbox.width                   = 100
$passbox.height                  = 20
$passbox.PasswordChar            = "*"
$passbox.location                = New-Object System.Drawing.Point(242,54)
$passbox.Font                    = 'Microsoft Sans Serif,10'

$username                        = New-Object system.Windows.Forms.Label
$username.text                   = "username:"
$username.AutoSize               = $true
$username.width                  = 27
$username.height                 = 10
$username.location               = New-Object System.Drawing.Point(170,22)
$username.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$detnsw                          = New-Object system.Windows.Forms.Label
$detnsw.text                     = "@detnsw"
$detnsw.AutoSize                 = $true
$detnsw.width                    = 25
$detnsw.height                   = 10
$detnsw.location                 = New-Object System.Drawing.Point(341,22)
$detnsw.Font                     = 'Microsoft Sans Serif,10'

$password                        = New-Object system.Windows.Forms.Label
$password.text                   = "password:"
$password.AutoSize               = $true
$password.width                  = 27
$password.height                 = 10
$password.location               = New-Object System.Drawing.Point(172,58)
$password.Font                   = 'Microsoft Sans Serif,10,style=Bold'

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
$ProgressBar1.location           = New-Object System.Drawing.Point(170,120)

$loginbutton                     = New-Object system.Windows.Forms.Button
$loginbutton.text                = "Login"
$loginbutton.width               = 60
$loginbutton.height              = 30
$loginbutton.location            = New-Object System.Drawing.Point(359,120)
$loginbutton.Font                = 'Microsoft Sans Serif,10'

$comboBox                         = New-Object System.Windows.Forms.ComboBox
$comboBox.SelectedIndex           = 0
$comboBox.DropDownStyle           = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$comboBox.Size                    = New-Object System.Drawing.Size(100,20)
$comboBox.Height                  = 80
$comboBox.Location                = New-Object System.Drawing.Point(175,85)


[void] $comboBox.Items.Add('Maths')
[void] $comboBox.Items.Add('English')
[void] $comboBox.Items.Add('Science')
[void] $comboBox.Items.Add('CAPA')
[void] $comboBox.Items.Add('HSIE')
[void] $comboBox.Items.Add('TAS')
[void] $comboBox.Items.Add('Support')
[void] $comboBox.Items.Add('Learning Support')


$Form.controls.AddRange(@($PictureBox1,$loginbutton,$userbox,$passbox,$username,$detnsw,$password,$checkbox1,$ProgressBar1,$comboBox))

#$loginbutton.Add_Click({processLogin})

$loginbutton.Add_MouseUp({processLogin})



function processLogin ()
{
    $user = $($userbox.Text+"@detnsw")
    $pass = $passbox.text
    $homepath = $("\\8385dip000sf001\Staff\_"+$userbox.Text)
    try{
        Write-Progress -Activity "Mapping" -Status "Mapping Home Drive" -PercentComplete 10
        mapDrive "U:" $homepath $user $pass
        if ($LASTEXITCODE -eq 0){
            Write-Host "Successfully mapped drive"
        } else {
            Write-Error "Failed to map drive"
            throw $error[0].Exception
        }
    }
    catch [System.Exception] {
        [System.Windows.Forms.MessageBox]::Show("test","test1",[System.Windows.Forms.MessageBoxButtons]::OK)
        return
    }    
    Write-Progress -Activity "Mapping" -Status "Mapping Home Drive" -PercentComplete 20
    mapDrive "T:" "\\8385dip000sf001\Faculty" $user $pass
    Write-Progress -Activity "Mapping" -Status "Mapping Home Drive" -PercentComplete 30
    mapDrive "P:" "\\8385dip000sf001\Collaboration" $user $pass
    Write-Progress -Activity "Mapping" -Status "Mapping Home Drive" -PercentComplete 40
    mapDrive "S:" "\\8385dip000sf003\Network_Applications" $user $pass
    Write-Progress -Activity "Mapping" -Status "Mapping Home Drive" -PercentComplete 50
    mapDrive "F:" "\\8385hr0002sf001\Data_8385" $user $pass
    Write-Progress -Activity "Mapping" -Status "Mapping Home Drive" -PercentComplete 60
    mapDrive "I:" "\8385hr0002sf001\iPad" $user $pass
    Write-Progress -Activity "Mapping" -Status "Mapping Home Drive" -PercentComplete 70
    mapDrive "Q:" "\\8385dip000sf003\Apps_8385" $user $pass
    DelOSCNetworkPrinters
    mapPrinter($comboBox.text)
    if ($checkbox1) {
        Start-Process -Path "http://detnsw.net"
    }
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
    net use $letter /delete /y
    net use $letter $path /user:$user $pass /persistent:yes
    <#$pass = ConvertTo-SecureString $passbox.Text -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PsCredential($user,$pass)
    
    New-PSDrive -Name "U" -Root $("\\8385dip000sf001\Staff\_"+$userbox.Text) -Persist -PSProvider fileSystem -Credential $Cred#>
}

function mapPrinter
{
    param([string]$faculty)
    switch ($faculty) {
        'Maths' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\GR0039 - Maths") ; break}
        'English' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\ER1010 - English") ; break}
        'Science' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\AR0027 - Science Staff") ; break}
        'CAPA' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\GR0036 - CAPA") ; break}
        'HSIE' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\DR1017 - HSIE")
        (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\DR1017 - HSIE 2") ; break}
        'TAS' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\CR0026 - TAS") ; break}
        'Support' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\GR1043 - Support") ; break}
        'Learning Support' { (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\8385hr0002sp001\ER0007 - Learning Support") ; break}
        Default { break; }
    }
}

$Form.ShowDialog()
