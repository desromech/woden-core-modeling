"
I encapsulate the information required for assigning a particular material into a model facet.
"
Class {
	#name : #WDModelingMaterialInfo,
	#superclass : #Object,
	#instVars : [
		'index',
		'definition',
		'path',
		'material'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #comparing }
WDModelingMaterialInfo >> = other [
	^ self class == other class and: [ path = other path and: [ definition = other definition ] ]
]

{ #category : #converting }
WDModelingMaterialInfo >> asWDModelingMaterialInfo [
	^ self
]

{ #category : #accessing }
WDModelingMaterialInfo >> definition [

	^ definition
]

{ #category : #accessing }
WDModelingMaterialInfo >> definition: anObject [

	definition := anObject
]

{ #category : #serialization }
WDModelingMaterialInfo >> encodeForJSON [
	^ OrderedDictionary newFromPairs: self encodeJsonKeyValues
]

{ #category : #accessing }
WDModelingMaterialInfo >> encodeJsonKeyValues [
	path ifNotNil: [ ^ { #path . path } ].
	definition ifNotNil: [ ^ definition encodeJsonKeyValues ].	
	^ #()
]

{ #category : #comparing }
WDModelingMaterialInfo >> hash [
	^ self class identityHash bitXor: (path hash bitXor: definition hash)
]

{ #category : #accessing }
WDModelingMaterialInfo >> index [

	^ index
]

{ #category : #accessing }
WDModelingMaterialInfo >> index: anObject [

	index := anObject
]

{ #category : #serialization }
WDModelingMaterialInfo >> loadFromJson: jsonData [
	jsonData at: #path ifPresent: [ :found |
		path := found.
		^ self
	].

	jsonData at: #type ifPresent: [ :found |
		definition := WDMaterial loadFromJson: jsonData.
		^ self
	].
]

{ #category : #accessing }
WDModelingMaterialInfo >> material [

	^ material
]

{ #category : #accessing }
WDModelingMaterialInfo >> material: anObject [

	material := anObject
]

{ #category : #accessing }
WDModelingMaterialInfo >> path [

	^ path
]

{ #category : #accessing }
WDModelingMaterialInfo >> path: anObject [

	path := anObject
]

{ #category : #'as yet unclassified' }
WDModelingMaterialInfo >> thumbnailFor: levelEditorSession [
	^ (self validMaterialWithResolver: levelEditorSession gameSettings) ifNotNil: [ :mat | mat makeThumbnail ]
]

{ #category : #accessing }
WDModelingMaterialInfo >> validMaterialWithResolver: materialInfoSolver [
	definition ifNotNil: [ ^ definition ].
	material ifNil: [
		materialInfoSolver ifNotNil: [
			material := materialInfoSolver loadValidMaterialForInfo: self
		]
	].
	^ material
]
