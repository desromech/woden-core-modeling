Class {
	#name : #WDMBSPBrush,
	#superclass : #WDModelingSceneObject,
	#instVars : [
		'faces'
	],
	#category : #'WodenModeling-BSPStyleCSG'
}

{ #category : #initialization }
WDMBSPBrush >> initialize [
	super initialize.
	faces := #()
	
]
