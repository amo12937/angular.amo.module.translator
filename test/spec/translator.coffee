"use strict"

do (moduleName = "amo.module.translator") ->
  describe "#{moduleName} の仕様", ->
    name = "trans"
    another =
      name: "icon"

    beforeEach ->
      module moduleName
      module ["#{moduleName}.translatorCollectionProvider", (provider) ->
        provider.registerTranslator name
        return
      ]
    afterEach ->
      inject()

    describe "translatorCollectionProvider は", ->
      it "registerTranslator で登録すると filter として使用できる", ->
        inject ["$filter", ($filter) ->
          func = $filter name
          expect($filter name).toBeDefined()
        ]
      it "registerTranslator で登録していないものは filter として使用できない", ->
        inject ["$filter", ($filter) ->
          expect(-> $filter another.name).toThrow()
        ]
      it "$filter が返すフィルターは translatorCollection.getTranslator が返すオブジェクトと同じである", ->
        inject ["$filter", "#{moduleName}.translatorCollection", ($filter, tc) ->
          expect($filter name).toBe tc.getTranslator name
        ]
    describe "translatorCollection は", ->
      tc = null
      beforeEach ->
        inject ["#{moduleName}.translatorCollection", (_tc) ->
          tc = _tc
        ]

      it "getTranslator 関数を持つ", ->
        expect(tc.getTranslator).toBeDefined()
      it "registerTranslator を使って登録していてもしていなくても、名前を渡すと translator を返す", ->
        expect(tc.getTranslator name).toBeDefined()
        expect(tc.getTranslator another.name).toBeDefined()
      it "同じ name には同じ値を返す", ->
        first = tc.getTranslator name
        second = tc.getTranslator name
        expect(second).toBe first
      it "異なる name には異なる値を返す", ->
        first = tc.getTranslator name
        second = tc.getTranslator another.name
        expect(second).not.toBe first
    describe "translator は", ->
      translator = null
      beforeEach ->
        inject ["#{moduleName}.translatorCollection", (tc) ->
          translator = tc.getTranslator name
        ]

      it "これ自身関数である", ->
        expect(translator instanceof Function).toBe true
      it "getName で name を取得できる", ->
        expect(translator.getName()).toBe name
      describe "setRule によってルールをセットすることができ、", ->
        rule =
          "Hello World": "こんにちワールド"
          "Hello %user%": "こんにちは、%user%"
          "switch %hoge% and %fuga%": "%fuga% と %hoge% が入れ替わっている"
          "%word% is same as %word%": "%word% と %word% は同じ値"
          "can use %filter%": "%filter% を使うことができる"
        another =
          rule:
            "Hello World": "[another] こんにちワールド"
            "Hello %user%": "[another] こんにちは、%user%"
            "switch %hoge% and %fuga%": "[another] %fuga% と %hoge% が入れ替わっている"
            "%word% is same as %word%": "[another] %word% と %word% は同じ値"
            "can use %filter%": "[another] %filter% を使うことができる"
         beforeEach ->
           translator.setRule rule
         it "固定文言を翻訳してくれる", ->
           expect(translator "Hello World").toBe "こんにちワールド"
         it "変数を代入することができる", ->
           context =
             user: "name"
           expect(translator "Hello %user%", context).toBe "こんにちは、name"
         it "変数の順番は自由に変えることができる", ->
           context =
             hoge: "A"
             fuga: "B"
           expect(translator "switch %hoge% and %fuga%", context).toBe "B と A が入れ替わっている"
         it "同じ値を 2 回以上使うことができる", ->
           context =
             word: "hoge"
           expect(translator "%word% is same as %word%", context).toBe "hoge と hoge は同じ値"
         it "フィルターを適用してくれる", ->
           context =
             filter: [100, ["currency", "hoge"], "uppercase"]
           expect(translator "can use %filter%", context).toBe "HOGE100.00 を使うことができる"
         it "ルールに無い場合はそのまま返される", ->
           expect(translator "this key is not in the rule").toBe "this key is not in the rule"
         it "ルールに無いキーにも変数を入れることができる", ->
           context =
             param: "hoge"
           expect(translator "this key with %param% is not in the rule", context).toBe "this key with hoge is not in the rule"
         it "別ルールに書き換えることができる", ->
           translator.setRule another.rule
           expect(translator "Hello World").toBe "[another] こんにちワールド"

