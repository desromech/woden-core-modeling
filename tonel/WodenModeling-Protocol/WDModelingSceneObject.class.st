"
I am a generic modeling scene object that can be selected and has a transform that can be manipulated.
"
Class {
	#name : #WDModelingSceneObject,
	#superclass : #WDModelingElement,
	#traits : 'TWDMModelingSceneObject',
	#classTraits : 'TWDMModelingSceneObject classTrait',
	#instVars : [
		'transform',
		'editionViewColor',
		'editionViewColorMaterial',
		'localBoundingBox'
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
WDModelingSceneObject class >> generateEditionViewColor [
	| newColor |
	[
		newColor := EditionColorPalette atRandom: EditionColorPaletteRandomGenerator
	] doWhileTrue: [ EditionColorPaletteLastGeneratedColor = newColor ].
	^ (EditionColorPaletteLastGeneratedColor := newColor) asVector4
]

{ #category : #initialization }
WDModelingSceneObject class >> initialize [
	Epsilon := 0.00001.
	EditionColorPalette := Color wheel: 13.
	EditionColorPaletteRandomGenerator := Random seed: 1.
	EditionColorPaletteLastGeneratedColor := nil.
]

{ #category : #accessing }
WDModelingSceneObject >> editionViewColor [
	^ editionViewColor
]

{ #category : #accessing }
WDModelingSceneObject >> editionViewColor: aColor [
	editionViewColor := aColor
]

{ #category : #accessing }
WDModelingSceneObject >> editionViewColorMaterial [
	^ editionViewColorMaterial ifNil: [
		editionViewColorMaterial := WDMetallicRoughnessMaterial default copy
			baseColorFactor: self editionViewColor;
			yourself
	]
]

{ #category : #'as yet unclassified' }
WDModelingSceneObject >> generateEditionViewColor [
	self editionViewColor: self class generateEditionViewColor
]

{ #category : #initialization }
WDModelingSceneObject >> initialize [
	super initialize.
	editionViewColor := Color white.
	transform := TRSTransform3D identity.
	localBoundingBox := AABox new.
]

{ #category : #'as yet unclassified' }
WDModelingSceneObject >> instantiateForPlacingIn: owner box: placementBox [
	| instance |
	instance := self copy setupForNewInstance.
	instance transformWith: (placementBox trsTransformToConvertToMe: instance boundingBox).
	owner add: instance.
	^ instance
]

{ #category : #accessing }
WDModelingSceneObject >> localBoundingBox [
	^ localBoundingBox
]

{ #category : #copying }
WDModelingSceneObject >> postCopy [
	super postCopy.
	
	parent := nil.
	transform := transform copy.
	localBoundingBox := localBoundingBox copy.
	editionViewColorMaterial := nil.
]

{ #category : #'as yet unclassified' }
WDModelingSceneObject >> setupForNewInstance [
	self generateEditionViewColor
]

{ #category : #accessing }
WDModelingSceneObject >> transform [
	^ transform
]

{ #category : #accessing }
WDModelingSceneObject >> transform: aTransform [
	transform := aTransform asTRSTransform3D copy.
	self transformChanged.
]

{ #category : #accessing }
WDModelingSceneObject >> transformChanged [
	self invalidateScenePresentations
]

{ #category : #'scene presentation' }
WDModelingSceneObject >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	aHandle sceneNode transform: transform.
]
