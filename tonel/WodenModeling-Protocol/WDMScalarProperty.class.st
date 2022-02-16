"
I am a scalar property.
"
Class {
	#name : #WDMScalarProperty,
	#superclass : #WDMProperty,
	#instVars : [
		'minimum',
		'maximum'
	],
	#category : #'WodenModeling-Protocol-Properties'
}

{ #category : #accessing }
WDMScalarProperty >> maximum [

	^ maximum
]

{ #category : #accessing }
WDMScalarProperty >> maximum: anObject [

	maximum := anObject
]

{ #category : #accessing }
WDMScalarProperty >> minimum [

	^ minimum
]

{ #category : #accessing }
WDMScalarProperty >> minimum: anObject [

	minimum := anObject
]
