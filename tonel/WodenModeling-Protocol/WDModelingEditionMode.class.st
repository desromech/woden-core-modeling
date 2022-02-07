"
I represent a specific edition mode in the modeling protocol.
"
Class {
	#name : #WDModelingEditionMode,
	#superclass : #WDAbstractEnumClass,
	#category : #'WodenModeling-Protocol-EditionMode'
}

{ #category : #converting }
WDModelingEditionMode class >> asModelingEditionMode [
	^ self uniqueInstance
]

{ #category : #testing }
WDModelingEditionMode class >> isAbstract [
	^ self == WDModelingEditionMode
]

{ #category : #converting }
WDModelingEditionMode >> asModelingEditionMode [
	^ self
]

{ #category : #testing }
WDModelingEditionMode >> isObjectEditionMode [
	^ false
]

{ #category : #testing }
WDModelingEditionMode >> isSculptEditionMode [
	^ false
]

{ #category : #testing }
WDModelingEditionMode >> isTopologyEditionMode [
	^ false
]
