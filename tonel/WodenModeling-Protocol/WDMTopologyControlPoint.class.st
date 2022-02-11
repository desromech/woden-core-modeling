"
I am a control point that is used for modifying the topology of a specific object.
"
Class {
	#name : #WDMTopologyControlPoint,
	#superclass : #Object,
	#instVars : [
		'position'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #initialization }
WDMTopologyControlPoint >> initialize [
	super initialize.
	position := Vector3 zeros asValueHolder
]

{ #category : #accessing }
WDMTopologyControlPoint >> position [

	^ position value
]

{ #category : #accessing }
WDMTopologyControlPoint >> position: newPosition [
	position value: newPosition
]

{ #category : #accessing }
WDMTopologyControlPoint >> transform [
	^ TRSTransform3D translation: self position
]

{ #category : #accessing }
WDMTopologyControlPoint >> transform: newTransform [
	^ self position: newTransform
]

{ #category : #transforming }
WDMTopologyControlPoint >> transformWith: aTransform [
	self position: (aTransform transformPosition: self position)
]

{ #category : #transforming }
WDMTopologyControlPoint >> translateBy: aTranslation [
	self position: (self position + aTranslation)
]

{ #category : #enumerating }
WDMTopologyControlPoint >> whenChangedDo: aBlock [
	position whenChangedDo: aBlock
]
