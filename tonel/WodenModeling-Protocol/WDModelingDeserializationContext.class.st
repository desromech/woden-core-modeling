"
I am an utility used for discovering some serialized resources.
"
Class {
	#name : 'WDModelingDeserializationContext',
	#superclass : 'Object',
	#instVars : [
		'objectTypeClassMap',
		'materialInfos'
	],
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'adding' }
WDModelingDeserializationContext >> addObjectTypeName: objectTypeName withClass: class [
	objectTypeClassMap at: objectTypeName put: class
]

{ #category : 'adding' }
WDModelingDeserializationContext >> addTypeClasses: typeClasses [
	typeClasses do: [ :each |
		self addObjectTypeName: each jsonObjectTypeName withClass: each
	]
]

{ #category : 'accessing' }
WDModelingDeserializationContext >> getMaterialInfoWithIndex: materialIndex [
	(materialIndex >= 0 and: [ materialIndex < materialInfos size ]) ifTrue: [ 
		^ materialInfos at: materialIndex + 1
	].

	^ nil
]

{ #category : 'initialization' }
WDModelingDeserializationContext >> initialize [
	super initialize.
	objectTypeClassMap := Dictionary new.
	materialInfos := #().
]

{ #category : 'accessing' }
WDModelingDeserializationContext >> materialInfos: newMaterialInfos [
	materialInfos := newMaterialInfos
]

{ #category : 'initialization' }
WDModelingDeserializationContext >> materializeObject: objectData [
	^ (objectTypeClassMap at: (objectData at: #__type__)) new
		loadFromJson: objectData withContext: self;
		yourself
]
