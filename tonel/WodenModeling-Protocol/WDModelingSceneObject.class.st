"
I am a generic modeling scene object that can be selected and has a transform that can be manipulated.
"
Class {
	#name : #WDModelingSceneObject,
	#superclass : #Object,
	#traits : 'TWDMModelingSceneObject',
	#classTraits : 'TWDMModelingSceneObject classTrait',
	#instVars : [
		'name',
		'transform',
		'editionViewColor'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
WDModelingSceneObject >> editionViewColor [
	^ editionViewColor
]

{ #category : #accessing }
WDModelingSceneObject >> editionViewColor: aColor [
	editionViewColor := aColor
]

{ #category : #memento }
WDModelingSceneObject >> initialize [
	super initialize.
	name := ''.
	transform := TRSTransform3D identity.
	editionViewColor := Color white.
]

{ #category : #accessing }
WDModelingSceneObject >> name [
	^ name
]

{ #category : #accessing }
WDModelingSceneObject >> name: aString [
	name := aString
]

{ #category : #accessing }
WDModelingSceneObject >> objectTypeName [
	^ 'Generic Object'
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
	"Event notification for the transform change."
]
