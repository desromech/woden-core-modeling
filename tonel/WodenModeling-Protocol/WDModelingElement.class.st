"
I am a modeling element.
"
Class {
	#name : #WDModelingElement,
	#superclass : #Object,
	#traits : 'TWDMModelingElement + TWDMJsonSerializableModelingElement',
	#classTraits : 'TWDMModelingElement classTrait + TWDMJsonSerializableModelingElement classTrait',
	#instVars : [
		'name',
		'visible',
		'parent',
		'scenePresentationHandles'
	],
	#classVars : [
		'EditionColorPalette',
		'EditionColorPaletteLastGeneratedColor',
		'EditionColorPaletteRandomGenerator',
		'Epsilon'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #initialization }
WDModelingElement class >> generateEditionViewColor [
	| newColor |
	[
		newColor := EditionColorPalette atRandom: EditionColorPaletteRandomGenerator
	] doWhileTrue: [ EditionColorPaletteLastGeneratedColor = newColor ].
	^ (EditionColorPaletteLastGeneratedColor := newColor) asVector4
]

{ #category : #initialization }
WDModelingElement class >> initialize [
	Epsilon := 0.00001.
	EditionColorPalette := Color wheel: 13.
	EditionColorPaletteRandomGenerator := Random seed: 1.
	EditionColorPaletteLastGeneratedColor := nil.
]

{ #category : #serialization }
WDModelingElement class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WD'
]

{ #category : #'instance creation' }
WDModelingElement class >> named: aName [
	^ self new name: aName; yourself
]

{ #category : #serialization }
WDModelingElement >> encodeJsonKeyValuesWithContext: serializationContext [
	^ {
		#__type__ . self jsonObjectTypeName.
		#name . self name.
		#visible . self visible.
	}
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

{ #category : #serialization }
WDModelingElement >> loadFromJson: jsonData withContext: deserializationContext [
	name := (jsonData at: #name ifAbsent: [ nil ]) ifNil: [ name].
	visible := (jsonData at: #visible ifAbsent: [ nil ]) ifNil: [visible].

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
WDModelingElement >> removedFromModelTree [
	parent := nil.
	scenePresentationHandles do: [ :each | each removedFromModelTree ].
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
