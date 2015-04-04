Ginger = require('../lib/ginger')

describe "Ginger", ->
  [workspaceElement, gingerMain] = []

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('ginger')

    runs ->
      workspaceElement = atom.views.getView(atom.workspace)
      pack = atom.packages.loadPackage('ginger')
      gingerMain = pack.mainModule
      spyOn(gingerMain, 'correct').andCallThrough()

  afterEach ->
    expect(gingerMain.correct).toHaveBeenCalled()
    expect(gingerMain.correct).toBeDefined()
    jasmine.unspy(gingerMain, 'correct')

  describe "when no text at cursor", ->
    it "shows a message that there is no text to be gingerd", ->
      runs ->
        expect(workspaceElement.querySelector('.am-panel .panel-body .text-warning')).not.toExist()
        atom.workspace.open('nothing-to-correct.txt').then (editor) ->
          atom.commands.dispatch workspaceElement, 'ginger:correct'

      waitsFor ->
        gingerMain.correct.calls.length is 1

      runs ->
        gingerElement = workspaceElement.querySelector('.am-panel .panel-body .text-warning')
        expect(gingerElement).toExist()
        expect(gingerElement.innerHTML).toBe('<b>NOTHING TO GINGER</b>')
