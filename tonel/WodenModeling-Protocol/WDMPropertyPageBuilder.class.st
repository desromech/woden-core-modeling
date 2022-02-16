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
	^ page
		properties: properties;
		yourself
]

{ #category : #building }
WDMPropertyPageBuilder >> linearColor3PropertyNamed: name selector: selector [
	^ self addProperty: (WDMVector3Property name: name selector: selector)
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
WDMPropertyPageBuilder >> quaternionPropertyNamed: name selector: selector [
	^ self addProperty: (WDMQuaternionProperty name: name selector: selector)
]

{ #category : #building }
WDMPropertyPageBuilder >> scalarPropertyNamed: name selector: selector [
	^ self addProperty: (WDMScalarProperty name: name selector: selector)
]

{ #category : #building }
WDMPropertyPageBuilder >> scalarPropertyNamed: name selector: selector maximum: maximum [
	^ self addProperty: ((WDMScalarProperty name: name selector: selector)
		maximum: maximum;
		yourself)
]

{ #category : #building }
WDMPropertyPageBuilder >> scalarPropertyNamed: name selector: selector minimum: minimum [
	^ self addProperty: ((WDMScalarProperty name: name selector: selector)
		minimum: minimum;
		yourself)
]

{ #category : #building }
WDMPropertyPageBuilder >> scalarPropertyNamed: name selector: selector minimum: minimum maximum: maximum [
	^ self addProperty: ((WDMScalarProperty name: name selector: selector)
		minimum: minimum;
		maximum: maximum;
		yourself)
]

{ #category : #building }
WDMPropertyPageBuilder >> stringPropertyNamed: name selector: selector [
	^ self addProperty: (WDMStringProperty name: name selector: selector)
]

{ #category : #accessing }
WDMPropertyPageBuilder >> title: newTitle [
	page title: newTitle
]

{ #category : #building }
WDMPropertyPageBuilder >> vector2PropertyNamed: name selector: selector [
	^ self addProperty: (WDMVector2Property name: name selector: selector)
]

{ #category : #building }
WDMPropertyPageBuilder >> vector3PropertyNamed: name selector: selector [
	^ self addProperty: (WDMVector3Property name: name selector: selector)
]

{ #category : #building }
WDMPropertyPageBuilder >> vector4PropertyNamed: name selector: selector [
	^ self addProperty: (WDMVector4Property name: name selector: selector)
]
