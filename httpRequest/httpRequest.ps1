# 実行中のパス取得
$path = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $path

$prev = ""

# ファイル読み込み
$fileName = $path + "\timestamp.dat"
try {
    $file = New-Object System.IO.StreamReader($fileName, [System.Text.Encoding]::GetEncoding("UTF-8"))
    while (($line = $file.ReadLine()) -ne $null)
    {
        $prev = $line
        # Write-Host($line)
    }
    $file.Close()
}
catch {
}

# 現在時刻取得
$now = Get-Date
# 処理タイムラグを考慮するための実行オフセット時間
$now = $now.AddSeconds(-10)
# 実行インターバル 3分刻みに丸める
$timestamp = $now.AddMinutes( -($now.Minute % 3) ).AddSeconds(-$now.Second).ToString("yyyy/MM/dd HH:mm:ss")

if ($prev -ne $timestamp) {
    try {
        # HTTPリクエスト
        $response = Invoke-WebRequest -Uri "http://localhost:8080/v2/user/username1" -Method GET -ContentType 'application/json'
        # コンソール出力
        Write-Host($response)

        # 実行時刻を更新
        Set-Content -Path $fileName -Value $timestamp
    }
    catch {
    }
}
