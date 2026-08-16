# Render 無料DB 再作成手順（plan_simulator）

無料PostgreSQLは **作成から30日で削除** される。期限が近づいたらこの手順でDBを作り直す。
seeds.rb に全データが入っているので、seed で復元できる。

- 本番URL: https://plan-simulator.onrender.com/
- GitHub: https://github.com/kazkaz9717/plan_simulator
- 前回作業日: 2026-07-15 / 次回期限: **2026-08-14**

---

## 事前メモ：URLは2種類ある

同じDBに対して接続URLが2つある。用途を間違えないこと。

- **Internal Database URL**（短い）… Webサービスに設定する用
- **External Database URL**（長い・`oregon-postgres.render.com` を含む）… ローカルPCから接続する用（バックアップ・seed）

URL・パスワードは秘密情報。人に見せたり公開リポジトリに置いたりしない。

---

## 手順

### 1. バックアップ（保険）

WSLのターミナルで：

```bash
cd ~/plan_simulator
pg_dump "古いDBのExternal Database URL" > backup_$(date +%Y%m%d).sql
ls -lh backup_*.sql   # サイズが0でなければ成功
```

### 2. 古いDBを削除

Renderダッシュボード → `plan-simulator-db` を開く → 下部の **Delete Database**
→ 確認欄に `sudo delete database plan-simulator-db` と入力して削除。
（無料DBは1つしか持てないので、新規作成の前に必ず削除する）

### 3. 新しい無料DBを作成

**New +** → **PostgreSQL**
- Name: `plan-simulator-db`
- Region: **Oregon**（毎回同じに）
- PostgreSQL Version: **18**（毎回同じに）
- Plan: **Free**
- **Create Database** → ステータスが Available になるまで待つ

### 4. WebサービスのDATABASE_URLを張り替え

`plan_simulator`（Webサービス, Ruby）→ 左メニュー **Environment** → **Edit**
→ `DATABASE_URL` の値を、**新DBのInternal Database URL** に置き換え → **Save Changes**
（保存すると自動で再デプロイが走る）

### 5. ローカルからテーブル作成＆データ投入

WSLのターミナルで（**新DBのExternal Database URL** を使う）：

```bash
cd ~/plan_simulator
DATABASE_URL="新DBのExternal Database URL" rails db:migrate RAILS_ENV=production
DATABASE_URL="新DBのExternal Database URL" rails db:seed    RAILS_ENV=production
```

seed成功時の出力例（件数の目安）：
```
ブランド:4 / プラン:9 / 割引:6 / サブスク:4 / オプション:6 / 手数料:3 / メーカー:3 / 機種:7 / ユーザー:5
```

### 6. 動作確認

https://plan-simulator.onrender.com/ を開いてデータが表示されればOK。
※無料プランはスリープするため、初回アクセスは起動に30〜60秒かかることがある。

---

## トラブル時

- seedで戻らなかった → バックアップから復元:
  ```bash
  psql "新DBのExternal Database URL" < backup_YYYYMMDD.sql
  ```
- `server version mismatch` → ローカルのpg_dump/psqlのバージョン差。エラー全文を確認。
- 接続できない → Internal と External を取り違えていないか確認。

---

## 補足：毎回作り直したくない場合

- **有料化**：DBを月7ドルのStarterにすると削除もスリープもなくなる（就活中だけ有料化→終わったら解約、が現実的）。
- **スリープだけ回避**：UptimeRobot等で5分ごとにpingするとWebサービスのスリープは防げる（DB削除は防げないので30日問題は別途対応が必要）。
