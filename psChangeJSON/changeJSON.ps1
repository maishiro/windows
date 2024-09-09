# JSONファイルを読み込む
$pathJSON = "./config.json"
$json = Get-Content $pathJSON -Raw | ConvertFrom-Json

# ユーザーに質問する
$question = "WebAPIのポート番号は？"
$answer = Read-Host -Prompt $question

# 入力値を数値に変換
$portNumber = [int]$answer

# JSONPathを使用して該当の値を更新する
$jsonPath = "$.config.port"
$json | Add-Member -Force -NotePropertyName "config" -NotePropertyValue @{port = $portNumber}

# 変更を保存する
$json | ConvertTo-Json -Depth 10 | Set-Content $pathJSON
Write-Host "JSONファイルを保存しました。"
