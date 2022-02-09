"
I provide the abstract ray picker interface.
"
Class {
	#name : #WDMAbstractRayPicker,
	#superclass : #Object,
	#instVars : [
		'ray',
		'editionMode'
	],
	#category : #'WodenModeling-Protocol-Selection'
}

{ #category : #'as yet unclassified' }
WDMAbstractRayPicker class >> ray: aRay [
	^ self new ray: aRay; yourself
]

{ #category : #'as yet unclassified' }
WDMAbstractRayPicker class >> ray: aRay editionMode: aMode [
	^ self new ray: aRay; editionMode: aMode; yourself
]

{ #category : #adding }
WDMAbstractRayPicker >> addResult: result withDistance: distance [
	self subclassResponsibility
]

{ #category : #accessing }
WDMAbstractRayPicker >> editionMode [

	^ editionMode
]

{ #category : #accessing }
WDMAbstractRayPicker >> editionMode: anEditionMode [
	editionMode := anEditionMode asModelingEditionMode
]

{ #category : #initialize }
WDMAbstractRayPicker >> initialize [
	super initialize.
	self editionMode: WDObjectEditionMode.
]

{ #category : #accessing }
WDMAbstractRayPicker >> ray [

	^ ray
]

{ #category : #accessing }
WDMAbstractRayPicker >> ray: anObject [

	ray := anObject
]

{ #category : #transformation }
WDMAbstractRayPicker >> withTransform: aTransform do: aBlock [
	self subclassResponsibility
]
