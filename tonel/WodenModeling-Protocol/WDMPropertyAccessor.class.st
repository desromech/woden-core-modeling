"
I am an accessor for getting and setting a specific property.
"
Class {
	#name : #WDMPropertyAccessor,
	#superclass : #Object,
	#instVars : [
		'getter',
		'setter'
	],
	#category : #'WodenModeling-Protocol-Properties'
}

{ #category : #'instance creation' }
WDMPropertyAccessor class >> forSelector: propertySelector [
	| setterSelector |
	setterSelector := (propertySelector , ':') asSymbol.
	^ self new
		getter: [ :receiver | receiver perform: propertySelector ];
		setter: [ :receiver :newValue | receiver perform: setterSelector with: newValue ];
		yourself
]

{ #category : #accessing }
WDMPropertyAccessor >> getFrom: object [
	^ getter value: object
]

{ #category : #accessing }
WDMPropertyAccessor >> getter [

	^ getter
]

{ #category : #accessing }
WDMPropertyAccessor >> getter: anObject [

	getter := anObject
]

{ #category : #accessing }
WDMPropertyAccessor >> set: newValue in: object [
	^ setter value: object value: newValue
]

{ #category : #accessing }
WDMPropertyAccessor >> setter [

	^ setter
]

{ #category : #accessing }
WDMPropertyAccessor >> setter: anObject [

	setter := anObject
]
