## よくある構成をterraformで作る

### CloudWatchAlarm + SNS + Chatbot

手作業における手順

1, ec2を建てる
2, SNSを作成する。一旦自分のメールアドレスを設定する。
3, CloudWatchAlarmを作成する。その際にSNSトピックを設定する。
4, AWSChatbotのワークスペースを作成し、チャンネルと紐付ける

## 環境構築

terraformはインストールしておく

s3バケットを作成する

aws configure　コマンドで環境変数をセットしておく

terraform init

terraform plan

terraform apply

