# angular.amo.module.translator

多言語対応のための翻訳フィルターを提供する

# インストール方法
```
bower install -S angular.amo.module.translator
```

# 使い方

## translatorCollectionProvider
翻訳フィルターは複数登録することが出来る。
これは、通常の翻訳とは別に、例えば font awesome などのアイコンに対してキーを割り当てるのに使うためである。
翻訳フィルターは config の段階で登録しておく必要がある。

## フィルターの登録
```coffee
angular.module "yourApp", ["amo.module.translator"]
.config ["amo.module.translator.translatorCollectionProvider", (provider) ->
  provider.registerTranslator "trans"
  provider.registerTranslator "icon"
]
```

## 翻訳情報の登録
フィルターを使用する前に、翻訳情報を登録する必要がある。

```coffee
angular.module "yourApp"
.run ["amo.module.translator.translatorCollection", (tc) ->
  transRule =
    "Hello %name% !": "こんにちは、%name% さん！"
    "This is sample text.": "これはサンプルテキストです。"
  translator = tc.getTranslator "trans"
  translator.setRule transRule

  iconRule =
    Home: '<i class="fa fa-home"></i>'
    Profile: '<i class="fa fa-star-o"></i>'
    Help: '<i class="fa fa-question"></i>'
  iconTranslator = tc.getTranslator "icon"
  iconTranslator.setRule iconRule
]
```

外部ファイルを使う場合は routeProvider の resolve を使うと良い。

## フィルターの使用
フィルターは以下のようにしてテンプレート上で使用できる。

```haml
.menu
  .button {{ "Home"|icon }}
  .button {{ "Profile"|icon }}
  .button {{ "Help"|icon }}
%ul
  %li {{ "Hello %name% !"|trans: {"name": "hoge" }}
  %li {{ "This is sample text."|trans }}
```

## controller 内などでの使用
getTranslator で取得した translator はそれ自身が関数となっており、
フィルターと同じように使うことが出来る。

```coffee
angular.module "yourApp"
.controller "someController", ["amo.module.translator.translatorCollection", (tc) ->
  translator = tc.getTranslator "trans"
  translatedText = translator "This is sample text"
]
```
