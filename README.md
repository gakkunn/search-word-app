## The-View
  登録した複数のurlに対してテキストのスクレイピングを行い、検索したワードの数を表示します。
  0.ログイン画面です(名前とパスワードでログインできるようにしています。)
  ![スクリーンショット 2023-09-23 10 52 07](https://github.com/gakkunn/search-word-app/assets/130534378/ceafbabe-9dc4-4e02-97d7-9e9ee4e3ceda)
  1.ホーム画面です
  ![スクリーンショット 2023-09-23 10 55 07](https://github.com/gakkunn/search-word-app/assets/130534378/a984e294-55b8-4a4c-b5eb-65623484b20a)
  2.まずはテキストスクレイピングを行いたいURLを複数入力します。
  ![スクリーンショット 2023-09-21 9 00 25](https://github.com/gakkunn/search-word-app/assets/130534378/b41d52b3-801b-4a02-a049-799ab628f62d)
  エラーが起きると以下のようになります。(URL入力フォームの制限は強くしています)
  ![スクリーンショット 2023-09-21 9 00 11](https://github.com/gakkunn/search-word-app/assets/130534378/44eca9e1-400e-4a0f-98a8-c8401f5f97ea)
  3.次に検索画面から探したいワードを検索します。(マッチした場合だけURLリンクを表示しています。)
  ![スクリーンショット 2023-09-23 10 59 07](https://github.com/gakkunn/search-word-app/assets/130534378/9b6c5e1e-4d57-4f91-9d75-333095ec4b24">
8/a984e294-55b8-4a4c-b5eb-65623484b20a)

## URL
  https://search-word.com <br >
  Basic認証が必要です。

## 使用技術
- Ruby 2.5.7
- Ruby on Rails 5.2.7
- MySQL 8.0
- Puma
- AWS
  - ALB
  - Route53
  - ECR
  - ECS
  - Fargate
  - RDS
- Docker/Docker-compose
- CircleCI CI/CD
- Minitest

## なぜこのような使用技術にしたのか？
- Puma
NginxなどのWebサーバーを置くべきだったかもしれないが、Puma、Nginxの構成の記事はたくさんあったため、あえてPumaだけを配置するインフラ構成にしてみた。
- CircleCI CI/CD
JenkinsやGitHubActionsも興味があったが、CI/CDツールで一番記事の多いCircleCIにした。
- AWS
RailsチュートリアルではRender,Udemy(Dokcer講座 かめさん)ではHerokuでデプロイした経験があり、
かつUdemy（AWS 山浦さん）でEC2の経験があったため、勉強になると思いECS(Fargate)で構築した。


## AWS構成図
<img width="558" alt="スクリーンショット 2023-09-10 13 14 08" src="https://github.com/gakkunn/search-word-app/assets/130534378/858c166c-f877-49ed-83a2-0eb89b8d0f76">

## 機能一覧
- ユーザー登録、ログイン機能(devise)
- スクレイピング機能

## テスト
- Minitest
  - 単体テスト(model)
  - 機能テスト(request)

## 作ろうと思ったきっかけ
  railsチュートリアルでrailsを学んでいる時に、ふと探したいワードが見つかった。どこかの章でやったけどどの章かわからずに1つ1つリンクに飛んではCtrl+Fで探したいワードを検索した。
  この時に思いついた。urlを複数登録して、そのテキストに対して一気に検索できればWebテキスト等で学んでいるときに役に立つじゃん！！と。。

## 失敗したこと
  そもそもスクレイピングをユーザーに提供するサイトを公開することがあまり良くなかった。スクレイピングを許可していないサイトに対してのアクセスはこちらでは対処できないため、法的な問題が絡んだりする。そのためBasic認証を設けることにした。

## 頑張ったこと
  　　インフラ構築。NginxとPumaでインフラ構築をする方法に関してはたくさんの記事があったが、Pumaだけで構築する記事はなかったため苦労した。ただその分、全体像や流れを理解することができたためよかったと思う。

## 今後したいこと
  　　Reactの導入。インフラから、ファイル構成、Dockerfile、config.yml等を1から変える必要があり大変だが、フロントエンドの勉強になると思うため導入したい。
