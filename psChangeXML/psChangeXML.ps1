# XMLファイルを読み込む
$xmlPath = "./config.xml"
$xml = [xml](Get-Content $xmlPath)

# ユーザーに質問する
$question = "WebAPIのポート番号は？"
$answer = Read-Host -Prompt $question

# XPathを使って該当のノードを選択し、値を更新する
$node = $xml.SelectSingleNode("/config/port")
if ($node) {
    $node.InnerText = $answer
    Write-Host "ポート番号を $answer に更新しました。"
} else {
    Write-Host "指定されたXPathに該当するノードが見つかりませんでした。"
}

# 変更を保存する
$xml.Save($xmlPath)
Write-Host "XMLファイルを保存しました。"
