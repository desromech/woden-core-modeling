"
I am an utility that is used for picking elements by using a ray.
"
Class {
	#name : #WDMRayPicker,
	#superclass : #Object,
	#instVars : [
		'ray',
		'editionMode',
		'results'
	],
	#category : #'WodenModeling-Protocol-Selection'
}

{ #category : #'as yet unclassified' }
WDMRayPicker class >> ray: aRay [
	^ self new ray: aRay; yourself
]

{ #category : #adding }
WDMRayPicker >> addResult: result withDistance: distance [
	results add: distance -> result
]

{ #category : #accessing }
WDMRayPicker >> editionMode [

	^ editionMode
]

{ #category : #accessing }
WDMRayPicker >> editionMode: anEditionMode [
	editionMode := anEditionMode asModelingEditionMode
]

{ #category : #initialize }
WDMRayPicker >> initialize [
	results := OrderedCollection new.
	self editionMode: WDObjectEditionMode.
]

{ #category : #accessing }
WDMRayPicker >> ray [

	^ ray
]

{ #category : #accessing }
WDMRayPicker >> ray: anObject [

	ray := anObject
]

{ #category : #accessing }
WDMRayPicker >> results [

	^ results
]

{ #category : #enumerating }
WDMRayPicker >> sortedDistancesWithResults [
	^ results sorted
]

{ #category : #enumerating }
WDMRayPicker >> sortedResults [
	^ self sortedDistancesWithResults collect: [ :each | each value ]
]

{ #category : #transformation }
WDMRayPicker >> withTransform: aTransform do: aBlock [
	| oldResults oldRay newResults newRay |
	aTransform isIdentity ifTrue: [ ^ aBlock value ].
	oldResults := results.
	oldRay := ray.
	newResults := OrderedCollection new.
	newRay := ray inverseTransformedWith: aTransform.
	[
		results := newResults.
		ray := newRay.
		aBlock value
	] ensure: [
		results := oldResults.
		ray := oldRay
	].

	newResults do: [ :each |
		| convertedDistance |
		convertedDistance := ray distanceForPoint: (aTransform transformPosition: (newRay pointAtDistance: each key)).
		self addResult: each value withDistance: convertedDistance
	].
]
