"
I am a specific object property.
"
Class {
	#name : #WDMProperty,
	#superclass : #Object,
	#instVars : [
		'object',
		'name',
		'accessor'
	],
	#category : #'WodenModeling-Protocol-Properties'
}

{ #category : #constructing }
WDMProperty class >> name: propertyName accessor: propertyAccessor [
	^ self new name: propertyName; accessor: propertyAccessor; yourself
]

{ #category : #constructing }
WDMProperty class >> name: propertyName selector: propertySelector [
	^ self name: propertyName accessor: (WDMPropertyAccessor forSelector: propertySelector)
]

{ #category : #accessing }
WDMProperty >> accessor [

	^ accessor
]

{ #category : #accessing }
WDMProperty >> accessor: anObject [

	accessor := anObject
]

{ #category : #accessing }
WDMProperty >> getValue [
	^ accessor getFrom: object
]

{ #category : #accessing }
WDMProperty >> name [

	^ name
]

{ #category : #accessing }
WDMProperty >> name: anObject [

	name := anObject
]

{ #category : #accessing }
WDMProperty >> object [

	^ object
]

{ #category : #accessing }
WDMProperty >> object: anObject [

	object := anObject
]

{ #category : #accessing }
WDMProperty >> setValue: newValue [
	^ accessor set: newValue in: object
]
