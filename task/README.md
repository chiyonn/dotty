# TaskWarrior 3.x 同期設定

## サーバー情報
- **サーバー**: vp-tw-svr-01.voxon.lan
- **IPアドレス**: 192.168.40.214
- **ポート**: 8443
- **プロトコル**: HTTP（現在TLS未設定）
- **同期サーバー**: TaskChampion Sync-Server

## 初回設定

### 1. 認証情報の生成

#### client_id（デバイスごとに一意）
```bash
# UUID形式で生成
uuidgen
# 例: A3CF2BE4-3214-450A-A5B1-7FD40C751E96
```

#### encryption_secret（全デバイスで共通）
```bash
# ランダムな文字列を生成（この値を安全に保管すること）
openssl rand -base64 32
# 例: SWcyrJ5FhWZop4zxHyh7KTbZuh4Hje2leZJwrZbbWys=
```

### 2. TaskWarriorの設定

```bash
# サーバーURL（現在はHTTP接続）
task config sync.server.url http://vp-tw-svr-01.voxon.lan:8443

# クライアントID（デバイスごとに異なる値を設定）
task config sync.server.client_id <生成したUUID>

# 暗号化シークレット（全デバイスで同じ値を設定）
# 注意: 両方の設定が必要
task config sync.server.encryption_secret <生成したシークレット>
task config sync.encryption_secret <同じシークレット>
```

### 3. 同期の初期化
```bash
# 初回のみ実行
task sync init
```

## 通常の使用方法

```bash
# タスクの同期
task sync
```

## 重要な注意事項

1. **client_id**: 
   - 各デバイスで異なるIDを使用する
   - 同じIDを複数デバイスで使用しない

2. **encryption_secret**: 
   - 同じタスクを共有する全デバイスで同じ値を使用する
   - この値を紛失するとタスクにアクセスできなくなる
   - 安全な場所に保管すること

3. **セキュリティ**:
   - 現在HTTP接続のため、通信は暗号化されていない
   - 本番環境ではTLS/SSL証明書の設定を推奨

## トラブルシューティング

### 同期エラーが発生する場合
1. サーバーの稼働状態を確認: `ping vp-tw-svr-01.voxon.lan`
2. ポートの開放を確認: `nc -zv vp-tw-svr-01.voxon.lan 8443`
3. 設定を確認: `task config | grep sync`

### 設定をリセットする場合
```bash
# 同期設定を削除
task config sync.server.url
task config sync.server.client_id
task config sync.server.encryption_secret
task config sync.encryption_secret
```