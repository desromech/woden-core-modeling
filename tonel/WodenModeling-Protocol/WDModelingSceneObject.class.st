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
