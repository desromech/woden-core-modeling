Class {
	#name : 'WDMBSPSubtractOperation',
	#superclass : 'WDMBSPCombinerOperation',
	#instVars : [
		'left',
		'right'
	],
	#category : 'WodenModeling-BSPStyleCSG',
	#package : 'WodenModeling-BSPStyleCSG'
}

{ #category : 'accessing' }
WDMBSPSubtractOperation >> left [

	^ left
]

{ #category : 'accessing' }
WDMBSPSubtractOperation >> left: anObject [

	left := anObject
]

{ #category : 'as yet unclassified' }
WDMBSPSubtractOperation >> operands [
	^ { left . right }
]

{ #category : 'accessing' }
WDMBSPSubtractOperation >> right [

	^ right
]

{ #category : 'accessing' }
WDMBSPSubtractOperation >> right: anObject [

	right := anObject
]
