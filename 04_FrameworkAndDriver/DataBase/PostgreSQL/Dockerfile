# ベースイメージとして公式のPostgreSQLイメージを使用
FROM postgres:latest

# 環境変数を設定
ENV POSTGRES_DB=mydatabase
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword

# 初期化スクリプトをコピー
COPY init.sql /docker-entrypoint-initdb.d/

# ポートを公開
EXPOSE 5432