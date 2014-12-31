"use strict"

do (moduleName = "amo.module.translator") ->
  describe "#{moduleName} の仕様", ->
    beforeEach module moduleName

    describe "translatorCollectionProvider は", ->
      name = "trans"
      another =
        name: "icon"
      provider = null
      beforeEach ->
        module ["#{moduleName}.translatorCollectionProvider", (_provider) ->
          provider = _provider
          return
        ]
      afterEach ->
        inject()

      it "registarTranslator で登録すると filter として使用できる", ->
        module ["$filterProvider", ($filterProvider) ->
          spyOn($filterProvider, "register").and.callThrough()
          provider.registerTranslator name
          expect($filterProvider.register).toHaveBeenCalledWith name, jasmine.any Array
        ]
        inject ["$filter", "#{moduleName}.translatorCollection", ($filter, tc) ->
          func = $filter name
          expect(func).toBeDefined()
          expect(-> $filter another.name).toThrow()
        ]
