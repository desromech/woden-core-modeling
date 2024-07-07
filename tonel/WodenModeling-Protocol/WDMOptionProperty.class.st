"
I am a property where an option is selected.
"
Class {
	#name : 'WDMOptionProperty',
	#superclass : 'WDMProperty',
	#instVars : [
		'options'
	],
	#category : 'WodenModeling-Protocol-Properties',
	#package : 'WodenModeling-Protocol',
	#tag : 'Properties'
}

{ #category : 'accessing' }
WDMOptionProperty >> options [

	^ options
]

{ #category : 'accessing' }
WDMOptionProperty >> options: anObject [

	options := anObject
]
