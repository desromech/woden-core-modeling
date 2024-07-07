"
I am a ray picker that only selects the first intersection element.
"
Class {
	#name : 'WDMFirstRayPicker',
	#superclass : 'WDMAbstractRayPicker',
	#instVars : [
		'result',
		'resultDistance'
	],
	#category : 'WodenModeling-Protocol-Selection',
	#package : 'WodenModeling-Protocol',
	#tag : 'Selection'
}

{ #category : 'adding' }
WDMFirstRayPicker >> addResult: newResult withDistance: newResultDistance [
	(result isNil or: [newResultDistance < resultDistance]) ifTrue: [
		result := newResult.
		resultDistance := newResultDistance.
	]
]

{ #category : 'accessing' }
WDMFirstRayPicker >> result [
	^ result
]

{ #category : 'accessing' }
WDMFirstRayPicker >> resultDistance [
	^ resultDistance
]

{ #category : 'transformation' }
WDMFirstRayPicker >> withTransform: aTransform do: aBlock [
	| oldResult oldResultDistance oldRay newResult newResultDistance newRay |
	aTransform isIdentity ifTrue: [ ^ aBlock value ].
	oldResult := result.
	oldResultDistance := resultDistance.
	newResult := newResultDistance := nil.

	oldRay := ray.
	newRay := ray inverseTransformedWith: aTransform.
	[
		result := resultDistance := nil.
		ray := newRay.
		aBlock value
	] ensure: [
		newResult := result.
		newResultDistance := resultDistance.

		result := oldResult.
		resultDistance := oldResultDistance.
		ray := oldRay
	].

	newResult ifNotNil: [
		| convertedDistance |
		convertedDistance := ray distanceForPoint: (aTransform transformPosition: (newRay pointAtDistance: newResultDistance)).
		self addResult: newResult withDistance: convertedDistance
	]
]
