# RLogCounter
Railsで出力されるログをカウントする
## 前提
- log tagsが表示されている

## 使用方法
1. `/usr/bin`などパスが通っているディレクトリにrlogcファイルのリンクを貼る
```
# ln -fs ~/github/RLogCounter/rlogc /usr/bin/
```
2-a. 実行
```
$ rlogc [Railsのログファイル]
```
2-b. 対話モード
```
$ rails s | rlogc
```
