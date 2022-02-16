"
I am a generic modeling scene object that can be selected and has a transform that can be manipulated.
"
Class {
	#name : #WDModelingSceneObject,
	#superclass : #WDModelingElement,
	#traits : 'TWDMModelingSceneObject + TWDMModelingElementWithEditionViewColor',
	#classTraits : 'TWDMModelingSceneObject classTrait + TWDMModelingElementWithEditionViewColor classTrait',
	#instVars : [
		'transform',
		'localBoundingBox'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #'property pages' }
WDModelingSceneObject >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		vector3PropertyNamed: 'Scale' selector: #scale;
		quaternionPropertyNamed: 'Orientation' selector: #orientation;
		vector3PropertyNamed: 'Position' selector: #position
]

{ #category : #serialization }
WDModelingSceneObject >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#transform . self transform encodeForJSON.
		#editionViewColor . self editionViewColor asVector4 encodeForJSON.
	}
]

{ #category : #initialization }
WDModelingSceneObject >> initialize [
	super initialize.
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

{ #category : #serialization }
WDModelingSceneObject >> loadFromJson: jsonData withContext: deserializationContext [
	super loadFromJson: jsonData withContext: deserializationContext.
	(jsonData at: #transform ifAbsent: [ nil ]) ifNotNil: [ :t |
		self transform: (TRSTransform3D loadFromJson: t)
	].
	(jsonData at: #editionViewColor ifAbsent: [ nil ]) ifNotNil: [ :c |
		self editionViewColor: (Vector4 loadFromJson: c) asColor
	].
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

{ #category : #'as yet unclassified' }
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
