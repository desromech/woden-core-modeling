"
I am a specific property page.
"
Class {
	#name : 'WDMPropertyPage',
	#superclass : 'Object',
	#instVars : [
		'title',
		'properties'
	],
	#category : 'WodenModeling-Protocol-Properties',
	#package : 'WodenModeling-Protocol',
	#tag : 'Properties'
}

{ #category : 'initialization' }
WDMPropertyPage >> initialize [
	super initialize.
	title := 'Properties'.
	properties := #().
]

{ #category : 'accessing' }
WDMPropertyPage >> properties [

	^ properties
]

{ #category : 'accessing' }
WDMPropertyPage >> properties: anObject [

	properties := anObject
]

{ #category : 'accessing' }
WDMPropertyPage >> title [

	^ title
]

{ #category : 'accessing' }
WDMPropertyPage >> title: anObject [

	title := anObject
]
