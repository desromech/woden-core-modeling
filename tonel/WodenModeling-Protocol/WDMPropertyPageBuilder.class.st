"
A builder for constructing properties pages.
"
Class {
	#name : #WDMPropertyPageBuilder,
	#superclass : #Object,
	#instVars : [
		'object',
		'properties',
		'page'
	],
	#category : #'WodenModeling-Protocol-Properties'
}

{ #category : #'as yet unclassified' }
WDMPropertyPageBuilder class >> for: anObject buildWith: aBlock [
	^ self new object: anObject; buildWith: aBlock
]

{ #category : #adding }
WDMPropertyPageBuilder >> addProperty: aProperty [
	aProperty object: object.
	properties add: aProperty
]

{ #category : #building }
WDMPropertyPageBuilder >> booleanPropertyNamed: name selector: selector [
	^ self addProperty: (WDMBooleanProperty name: name selector: selector)
]

{ #category : #building }
WDMPropertyPageBuilder >> buildWith: aBlock [
	properties := OrderedCollection new.
	page := WDMPropertyPage new.
	aBlock value: self.
	properties sort: [ :a :b | a name <= b name].
	^ page
		properties: properties;
		yourself
]

{ #category : #accessing }
WDMPropertyPageBuilder >> object [

	^ object
]

{ #category : #accessing }
WDMPropertyPageBuilder >> object: anObject [

	object := anObject
]

{ #category : #building }
WDMPropertyPageBuilder >> stringPropertyNamed: name selector: selector [
	^ self addProperty: (WDMStringProperty name: name selector: selector)
]

{ #category : #accessing }
WDMPropertyPageBuilder >> title: newTitle [
	page title: newTitle
]
