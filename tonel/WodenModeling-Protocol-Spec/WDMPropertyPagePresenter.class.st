"
I am a modeling property page presenter.
"
Class {
	#name : #WDMPropertyPagePresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'treeView'
	],
	#category : #'WodenModeling-Protocol-Spec'
}

{ #category : #specs }
WDMPropertyPagePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		beNotHomogeneous;
		yourself
]

{ #category : #initialization }
WDMPropertyPagePresenter >> modelChanged [
	| grid |
	grid := SpGridLayout new
		beColumnHomogeneous;
		beRowNotHomogeneous;
		borderWidth: 0;
		yourself.
	self model properties doWithIndex: [ :each :row |
		| eachPresenter |
		eachPresenter := each buildSpecPresenter.
		eachPresenter ifNotNil: [ 
			grid
				add: (self newLabel label: each name) at: 1@row;
				add: eachPresenter at: 2@row
		].
	].
	self layout: grid
]
