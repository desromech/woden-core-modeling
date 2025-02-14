Class {
	#name : 'WDMBSPUnionOperation',
	#superclass : 'WDMBSPCombinerOperation',
	#instVars : [
		'operands'
	],
	#category : 'WodenModeling-BSPStyleCSG',
	#package : 'WodenModeling-BSPStyleCSG'
}

{ #category : 'accessing' }
WDMBSPUnionOperation >> operands [

	^ operands
]

{ #category : 'accessing' }
WDMBSPUnionOperation >> operands: anObject [

	operands := anObject
]
