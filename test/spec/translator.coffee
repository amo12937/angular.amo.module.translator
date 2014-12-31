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

