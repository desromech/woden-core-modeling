"
I am a modeling element.
"
Class {
	#name : #WDModelingElement,
	#superclass : #Object,
	#traits : 'TWDMModelingElement',
	#classTraits : 'TWDMModelingElement classTrait',
	#instVars : [
		'name',
		'parent',
		'visible',
		'scenePresentationHandles'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #'instance creation' }
WDModelingElement class >> named: aName [
	^ self new name: aName; yourself
]

{ #category : #initialization }
WDModelingElement >> initialize [
	super initialize.
	name := ''.
	visible := true.
	scenePresentationHandles := WeakSet new.
]

{ #category : #'scene presentation' }
WDModelingElement >> initializeScenePresentationHandle: aHandle [
]

{ #category : #'scene presentation' }
WDModelingElement >> invalidateScenePresentations [
	scenePresentationHandles do: [ :each | each invalidate ]
]

{ #category : #'scene presentation' }
WDModelingElement >> makeScenePresentationHandleFor: aScene [
	| newHandle |
	newHandle := self scenePresentationHandleClass for: self scene: aScene.
	scenePresentationHandles add: newHandle.
	self
		initializeScenePresentationHandle: newHandle;
		updateScenePresentationHandle: newHandle.
	^ newHandle
]

{ #category : #accessing }
WDModelingElement >> name [
	^ name
]

{ #category : #accessing }
WDModelingElement >> name: aString [
	name := aString
]

{ #category : #accessing }
WDModelingElement >> objectTypeName [
	self subclassResponsibility
]

{ #category : #accessing }
WDModelingElement >> parent [
	^ parent
]

{ #category : #accessing }
WDModelingElement >> parent: newParent [
	parent := newParent
]

{ #category : #copying }
WDModelingElement >> postCopy [
	super postCopy.
	scenePresentationHandles := WeakSet new.
]

{ #category : #'scene presentation' }
WDModelingElement >> removedFromScene [
	scenePresentationHandles do: [ :each | each removedFromScene ].
	scenePresentationHandles := WeakSet new.
]

{ #category : #'scene presentation' }
WDModelingElement >> scenePresentationHandleClass [
	^ WDModelingSceneNodePresentationHandle
]

{ #category : #accessing }
WDModelingElement >> scenePresentationHandles [
	^ scenePresentationHandles
]

{ #category : #'scene presentation' }
WDModelingElement >> updateScenePresentationHandle: aHandle [
	aHandle sceneNode visible: self visible
]

{ #category : #accessing }
WDModelingElement >> visible [
	^ visible
]

{ #category : #accessing }
WDModelingElement >> visible: aBoolean [
	visible := aBoolean.
	self invalidateScenePresentations.
]
