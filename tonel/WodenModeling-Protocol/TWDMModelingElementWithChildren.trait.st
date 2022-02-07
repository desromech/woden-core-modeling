"
I provide the implementation for a modeling element with children.
"
Trait {
	#name : #TWDMModelingElementWithChildren,
	#instVars : [
		'children'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #'add/remove' }
TWDMModelingElementWithChildren >> add: aChild [
	self children add: aChild.
	aChild parent: self.
	self scenePresentationHandles do: [ :eachHandle |
		| childHandle |
		childHandle := aChild makeScenePresentationHandleFor: eachHandle scene.
		childHandle addOntoSceneNode: eachHandle sceneNode.
		eachHandle addChild: childHandle.
	].
	self modelingTreeRoot treeTopologyChanged.
]

{ #category : #testing }
TWDMModelingElementWithChildren >> canAddOrRemoveChildren [
	^ true
]

{ #category : #accessing }
TWDMModelingElementWithChildren >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #initialization }
TWDMModelingElementWithChildren >> initializeScenePresentationHandle: aPresentationHandle [
	self children do: [ :each |
		| childHandle |
		childHandle := each makeScenePresentationHandleFor: aPresentationHandle scene.
		childHandle addOntoSceneNode: aPresentationHandle sceneNode.
		aPresentationHandle addChild: childHandle.
	].

]

{ #category : #selection }
TWDMModelingElementWithChildren >> rayPickElements: picker [
	picker withTransform: self transform do: [ 
		children do: [ :each | each rayPickElements: picker ]
	].

]

{ #category : #'add/remove' }
TWDMModelingElementWithChildren >> remove: aChild [
	self children remove: aChild.
	self modelingTreeRoot treeTopologyChanged.
	aChild removedFromScene.
]
