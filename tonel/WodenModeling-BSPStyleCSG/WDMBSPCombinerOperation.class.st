Class {
	#name : 'WDMBSPCombinerOperation',
	#superclass : 'WDModelingSceneObject',
	#category : 'WodenModeling-BSPStyleCSG',
	#package : 'WodenModeling-BSPStyleCSG'
}

{ #category : 'accessing' }
WDMBSPCombinerOperation >> children [
	^ self operands
]

{ #category : 'as yet unclassified' }
WDMBSPCombinerOperation >> operands [
	^ self subclassResponsibility 
]
