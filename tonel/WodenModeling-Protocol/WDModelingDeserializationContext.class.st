Class {
	#name : #WDModelingDeserializationContext,
	#superclass : #Object,
	#instVars : [
		'objectTypeClassMap',
		'materialInfos'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #adding }
WDModelingDeserializationContext >> addObjectTypeName: objectTypeName withClass: class [
	objectTypeClassMap at: objectTypeName put: class
]

{ #category : #adding }
WDModelingDeserializationContext >> addTypeClasses: typeClasses [
	typeClasses do: [ :each |
		self addObjectTypeName: each jsonObjectTypeName withClass: each
	]
]

{ #category : #'as yet unclassified' }
WDModelingDeserializationContext >> getMaterialInfoWithIndex: materialIndex [
	(materialIndex >= 0 and: [ materialIndex < materialInfos size ]) ifTrue: [ 
		^ materialInfos at: materialIndex + 1
	].

	^ nil
]

{ #category : #'as yet unclassified' }
WDModelingDeserializationContext >> initialize [
	super initialize.
	objectTypeClassMap := Dictionary new.
	materialInfos := #().
]

{ #category : #accessing }
WDModelingDeserializationContext >> materialInfos: newMaterialInfos [
	materialInfos := newMaterialInfos
]

{ #category : #'as yet unclassified' }
WDModelingDeserializationContext >> materializeObject: objectData [
	^ (objectTypeClassMap at: (objectData at: #__type__)) new
		loadFromJson: objectData withContext: self;
		yourself
]
