# Windows環境でdigdagを使う

## 1. digdagサーバーを立てる

### 1.1. digdagをインストールする
公式サイトにあるように、次のコマンドを実行
```cmd
PowerShell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12; mkdir -Force $env:USERPROFILE\bin; Invoke-WebRequest http://dl.digdag.io/digdag-latest.jar -OutFile $env:USERPROFILE\bin\digdag.bat}"
```

'C:\Users\YOUR_NAME\bin'のようなフォルダにバッチファイルができているので、パスを通して実行できるようにする。  
管理者権限でコマンドプロンプトを開いて
```cmd
setx PATH "%PATH%;%USERPROFILE%\bin"
```


### 1.2. サーバデータをPostgreSQLに保存する場合
例えば、ユーザー名 'postgres'、パスワード 'postgres'、データベース名 'digdag'でデータベースを作成して保存するとき、次のように設定ファイルに記述しておく。  

server.properties ファイル
```
database.type = postgresql
database.user = postgres
database.password= postgres
database.host = 127.0.0.1
database.port = 5432
database.database = digdag
database.maximumPoolSize = 32
```

### 1.3. digdagサーバを起動
ポート番号を8081に変更したい場合、設定ファイルに次の記述を追加

server.properties ファイル
```
server.port = 8081
```

ワークフローでPostgreSQLのデータベースを使用したい。  
パスワードログインできるようにsecrets利用の記述を追加  

digdag.secret-encryption-keyは、適当な文字列をBASE64変換して設定する

server.properties ファイル
```
digdag.secret-access-policy-file = secret-access-policy.yaml
digdag.secret-encryption-key = MDEyMzQ1Njc4OTAxMjM0NQ==
```

secret-access-policy.yaml ファイル
```
operators:
  pg:
    secrets:
      - pg.*
```

digdagサーバを起動
```cmd
digdag server -o ./digdag-server --config .\server.properties
```

digdagサーバをブラウザで確認
```url
http://localhost:8081/
```


## 2. ローカルでワークフローを作成する

作業フォルダ名'mydag'を指定して、ワークフロープロジェクトを作成する。
```cmd
cd C:\work\digdag
digdag init mydag
```

mydag.digファイルを記述する。

ワークフローでPostgreSQLにアクセスできるようにパスワード設定する。  
ローカル実行の設定は次のようにコマンド実行すると、値の入力が促されてくる。
```
digdag secrets --local --set pg.password
```

実行してみる
```
digdag run .\mydag.dig --rerun
```


## 3. ローカルのワークフロー プロジェクトをサーバに登録する
サーバのポート番号を変えているので、'-e'の設定を付け、プロジェクト名'mydag'でフォルダの内容を登録する
```cmd
cd C:\work\digdag\mydag
digdag push mydag -e localhost:8081
```

サーバにこのプロジェクト'mydag'で使用するPostgreSQLへのアクセスパスワードを設定する
```
digdag secrets --project mydag --set pg.password -e localhost:8081
```

<hr>  

（設定ファイルを使用する場合のコマンド）
```cmd
cd C:\work\digdag\mydag
digdag push mydag -c ../client.properties

digdag secrets --project mydag --set pg.password -c ../client.properties
```

このときの、client.propertiesファイル
```
client.http.endpoint = http://localhost:8081
```
