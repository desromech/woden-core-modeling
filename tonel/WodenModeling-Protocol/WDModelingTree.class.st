"
I am a modeling tree where all of its elements respect the Woden modeling protocol.
"
Class {
	#name : #WDModelingTree,
	#superclass : #WDModelingElement,
	#traits : 'TWDMModelingElementWithChildren',
	#classTraits : 'TWDMModelingElementWithChildren classTrait',
	#instVars : [
		'materialResolver',
		'treeTopologyChangeListeners',
		'backgroundColor'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingTree class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #serialization }
WDModelingTree class >> loadFromJsonString: jsonString [
	^ self loadFromJson: (NeoJSONReader fromString: jsonString)
]

{ #category : #accessing }
WDModelingTree >> backgroundColor [

	^ backgroundColor
]

{ #category : #accessing }
WDModelingTree >> backgroundColor: aColor [
	backgroundColor := aColor asVector4.
	self invalidateScenePresentations.
]

{ #category : #'property pages' }
WDModelingTree >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		linearColor3PropertyNamed: 'Background Color' selector: #backgroundColor
	
]

{ #category : #serialization }
WDModelingTree >> encodeAsJSONString [
	^ (NeoJSONWriter toStringPretty: self encodeForJSON) withUnixLineEndings
]

{ #category : #serialization }
WDModelingTree >> encodeForJSON [
	^ OrderedDictionary newFromPairs: self encodeJsonKeyValues
]

{ #category : #serialization }
WDModelingTree >> encodeJsonKeyValues [
	| context |
	context := WDModelingSerializationContext new.
	self prepareForSerializationWithContext: context.
	^ self encodeJsonKeyValuesWithContext: context
]

{ #category : #serialization }
WDModelingTree >> encodeJsonKeyValuesWithContext: serializationContext [
	^ {
		#materials . serializationContext materialInfos collect: [ :each | each encodeForJSON ]
	 } ,
	(super encodeJsonKeyValuesWithContext: serializationContext) , {
		#backgroundColor . backgroundColor encodeForJSON .
		#children . self children collect: [ :each | each encodeForJSONWithContext: serializationContext ]
	}
]

{ #category : #initialization }
WDModelingTree >> initialize [
	super initialize.
	backgroundColor := Color veryDarkGray asVector4.
]

{ #category : #serialization }
WDModelingTree >> loadFromJson: jsonData [
	| context |
	context := WDModelingDeserializationContext new.
	context addTypeClasses: WDModelingElement withAllSubclasses.
	
	(jsonData at: #materials ifAbsent: [ nil ]) ifNotNil: [ :mats |
		context materialInfos: (
			mats collect: [ :each | WDModelingMaterialInfo new loadFromJson: each ]
		)
	].

	jsonData at: #backgroundColor ifPresent: [ :json |
		backgroundColor := Vector4 loadFromJson: json
	].
	
	self loadFromJson: jsonData withContext: context
	
]

{ #category : #accessing }
WDModelingTree >> materialResolver [
	^ materialResolver
]

{ #category : #accessing }
WDModelingTree >> materialResolver: aMaterialResolver [
	materialResolver := aMaterialResolver
]

{ #category : #accessing }
WDModelingTree >> objectTypeName [
	^ 'Modeling Tree'
]

{ #category : #accessing }
WDModelingTree >> treeTopologyChangeListeners [
	^ treeTopologyChangeListeners ifNil: [treeTopologyChangeListeners := Set new]
]

{ #category : #enumerating }
WDModelingTree >> treeTopologyChanged [
	self treeTopologyChangeListeners do: [ :each | each value ]
]

{ #category : #'scene presentation' }
WDModelingTree >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.

]

{ #category : #enumerating }
WDModelingTree >> whenAddedOrRemovedElementDo: aBlock [
	self treeTopologyChangeListeners add: aBlock
]
