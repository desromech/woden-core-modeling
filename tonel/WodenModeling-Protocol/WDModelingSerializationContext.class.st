Class {
	#name : #WDModelingSerializationContext,
	#superclass : #Object,
	#instVars : [
		'materialInfos',
		'materialInfoDictionary'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #initialization }
WDModelingSerializationContext >> initialize [
	super initialize.
	materialInfos := OrderedCollection new.
	materialInfoDictionary := Dictionary new.
]

{ #category : #'as yet unclassified' }
WDModelingSerializationContext >> materialInfoIndexFor: materialInfo [
	materialInfo ifNil: [ ^ nil ].
	^ materialInfoDictionary at: materialInfo
]

{ #category : #accessing }
WDModelingSerializationContext >> materialInfos [
	^ materialInfos
]

{ #category : #materials }
WDModelingSerializationContext >> recordMaterialInfo: materialInfo [
	(materialInfo isNil or: [materialInfoDictionary includesKey: materialInfo]) ifTrue: [ ^ self ].
	
	materialInfoDictionary at: materialInfo put: materialInfos size.
	materialInfos add: materialInfo.
]
