"
I am a string property.
"
Class {
	#name : #WDMStringProperty,
	#superclass : #WDMProperty,
	#category : #'WodenModeling-Protocol-Properties'
}

{ #category : #conversions }
WDMStringProperty >> formatValue: value [
	^ value asString
]

{ #category : #conversions }
WDMStringProperty >> getFormattedValue [
	^ self formatValue: self getValue
]

{ #category : #conversions }
WDMStringProperty >> parseText: text [
	^ text
]

{ #category : #conversions }
WDMStringProperty >> parseTextAndSetValue: text [
	| parsedValue |
	parsedValue :=  [
		self parseText: text
	] on: Error do: [ ^ self ].
	
	self setValue: parsedValue.
]
