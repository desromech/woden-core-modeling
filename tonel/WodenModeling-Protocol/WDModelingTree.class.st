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
		'backgroundColor',
		'fogMode',
		'fogColor',
		'fogStartDistance',
		'fogEndDistance',
		'fogDensity'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingTree class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #serialization }
WDModelingTree class >> loadFromJsonString: jsonString [
	^ self loadFromJson: (STONJSON fromString: jsonString)
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
		linearColor4PropertyNamed: 'Background Color' selector: #backgroundColor;
		optionPropertyNamed: 'Fog Mode' selector: #fogMode options: #(NONE LINEAR EXP EXP2);
		linearColor4PropertyNamed: 'Fog Color' selector: #fogColor;
		scalarPropertyNamed: 'Fog Start Distance' selector: #fogStartDistance;
		scalarPropertyNamed: 'Fog End Distance' selector: #fogEndDistance;
		scalarPropertyNamed: 'Fog Density' selector: #fogDensity
]

{ #category : #serialization }
WDModelingTree >> encodeAsJSONString [
	^ (STONJSON toStringPretty: self encodeForJSON) withUnixLineEndings
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
		#materials . serializationContext materialInfos collect: [ :each | each encodeForJSON ] as: Array
	 } ,
	(super encodeJsonKeyValuesWithContext: serializationContext) , {
		#backgroundColor . backgroundColor encodeForJSON .
		#fogMode . fogMode .
		#fogColor . fogColor encodeForJSON .
		#fogStartDistance . fogStartDistance.
		#fogEndDistance . fogEndDistance.
		#fogDensity . fogDensity.
		#children . self children collect: [ :each | each encodeForJSONWithContext: serializationContext ] as: Array
	}
]

{ #category : #accessing }
WDModelingTree >> fogColor [

	^ fogColor
]

{ #category : #accessing }
WDModelingTree >> fogColor: anObject [

	fogColor := anObject
]

{ #category : #accessing }
WDModelingTree >> fogDensity [

	^ fogDensity
]

{ #category : #accessing }
WDModelingTree >> fogDensity: anObject [

	fogDensity := anObject
]

{ #category : #accessing }
WDModelingTree >> fogEndDistance [

	^ fogEndDistance
]

{ #category : #accessing }
WDModelingTree >> fogEndDistance: anObject [

	fogEndDistance := anObject
]

{ #category : #accessing }
WDModelingTree >> fogMode [

	^ fogMode
]

{ #category : #accessing }
WDModelingTree >> fogMode: aFogModeName [
	fogMode := aFogModeName asSymbol
]

{ #category : #accessing }
WDModelingTree >> fogStartDistance [

	^ fogStartDistance
]

{ #category : #accessing }
WDModelingTree >> fogStartDistance: anObject [

	fogStartDistance := anObject
]

{ #category : #initialization }
WDModelingTree >> initialize [
	super initialize.
	backgroundColor := Color veryDarkGray asVector4.
	fogMode := #NONE.
	fogColor := Vector4 zeros.
	fogStartDistance := 0.0.
	fogEndDistance := 0.0.
	fogDensity := 0.0.
	
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

	jsonData at: #fogColor ifPresent: [ :json |
		fogColor := Vector4 loadFromJson: json
	].

	self fogMode: ((jsonData at: #fogMode ifAbsent: [nil]) ifNil: [ fogMode ]).
	fogStartDistance := (jsonData at: #fogStartDistance ifAbsent: [nil]) ifNil: [ fogStartDistance ].
	fogEndDistance := (jsonData at: #fogEndDistance ifAbsent: [nil]) ifNil: [ fogEndDistance ].
	fogDensity := (jsonData at: #fogDensity ifAbsent: [nil]) ifNil: [ fogDensity ].
	
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
