"
I am a handle that is used for presenting the modeling elements onto a woden scene.
"
Class {
	#name : #WDModelingScenePresentationHandle,
	#superclass : #Object,
	#instVars : [
		'scene',
		'parent',
		'children',
		'model'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #'as yet unclassified' }
WDModelingScenePresentationHandle class >> for: aModel scene: aScene [
	^ self basicNew initializeWithModel: aModel scene: aScene; yourself
]

{ #category : #adding }
WDModelingScenePresentationHandle >> addChild: aChild [
	self children add: aChild.
	aChild parent: self.
]

{ #category : #adding }
WDModelingScenePresentationHandle >> addOntoScene [
	self addOntoSceneNode: scene normalLayer
]

{ #category : #adding }
WDModelingScenePresentationHandle >> addOntoSceneNode: aSceneNode [
]

{ #category : #adding }
WDModelingScenePresentationHandle >> children [
	^ children ifNil: [ children := Set new ]
]

{ #category : #initialization }
WDModelingScenePresentationHandle >> initializeWithModel: aModel scene: aScene [
	model := aModel.
	scene := aScene
]

{ #category : #scrolling }
WDModelingScenePresentationHandle >> invalidate [
	self flag: 'TODO: Attempt to defer this onto rendering time'.
	model ifNotNil: [ model updateScenePresentationHandle: self ]
]

{ #category : #accessing }
WDModelingScenePresentationHandle >> parent [

	^ parent
]

{ #category : #accessing }
WDModelingScenePresentationHandle >> parent: anObject [

	parent := anObject
]

{ #category : #removing }
WDModelingScenePresentationHandle >> removeChild: aChild [
	self children remove: aChild
]

{ #category : #'scene presentation' }
WDModelingScenePresentationHandle >> removedFromScene [
	parent ifNotNil: [ parent removeChild: self ].
	scene := nil.
	parent := nil.
]

{ #category : #accessing }
WDModelingScenePresentationHandle >> scene [
	^ scene
]
