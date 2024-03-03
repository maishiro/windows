Write-Host($env:Tmp)

$logFilePath = $env:Tmp+"\hoge2.txt"

$textfile = $env:Tmp+"\hoge.txt"
$file = New-Object System.IO.StreamWriter($textfile, $true, [System.Text.Encoding]::GetEncoding("UTF-8"))
$file.WriteLine("test1")
$file.WriteLine("test2")
$file.WriteLine("test3")
Write-Host("test4")



$logText = "ProgramData:"+$env:ProgramData
Add-Content -Path $logFilePath -Value $logText -PassThru
Write-Host $logText
$file.WriteLine($logText)

$logText = "ProgramFiles:"+$env:ProgramFiles
Add-Content -Path $logFilePath -Value $logText -PassThru
Write-Host $logText
$file.WriteLine($logText)



$file.Close()
