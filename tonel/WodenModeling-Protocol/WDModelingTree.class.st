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
		'treeTopologyChangeListeners'
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
		#children . self children collect: [ :each | each encodeForJSONWithContext: serializationContext ]
	}
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

{ #category : #enumerating }
WDModelingTree >> whenAddedOrRemovedElementDo: aBlock [
	self treeTopologyChangeListeners add: aBlock
]
