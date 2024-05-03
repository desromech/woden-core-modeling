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
		'fogDensity',
		'hdri',
		'useHDRIAsSkybox',
		'hdriLightProbePath',
		'hdriLightProbe',
		'assetResolver',
		'ambientLighting',
		'modelResolver'
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
WDModelingTree >> ambientLighting [

	^ ambientLighting
]

{ #category : #accessing }
WDModelingTree >> ambientLighting: anAmbientLightColor [
	ambientLighting := anAmbientLightColor asVector3.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingTree >> assetResolver [
	^ assetResolver
]

{ #category : #accessing }
WDModelingTree >> assetResolver: anAssetResolver [
	assetResolver := anAssetResolver
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
		linearColor3PropertyNamed: 'Ambient Lighting' selector: #ambientLighting;
		linearColor4PropertyNamed: 'Background Color' selector: #backgroundColor;
		optionPropertyNamed: 'Fog Mode' selector: #fogMode options: #(NONE LINEAR EXP EXP2);
		linearColor4PropertyNamed: 'Fog Color' selector: #fogColor;
		scalarPropertyNamed: 'Fog Start Distance' selector: #fogStartDistance;
		scalarPropertyNamed: 'Fog End Distance' selector: #fogEndDistance;
		scalarPropertyNamed: 'Fog Density' selector: #fogDensity;
		stringPropertyNamed: 'HDRI' selector: #hdri;
		booleanPropertyNamed: 'Use HDRI as Sky Box' selector: #useHDRIAsSkybox
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
		#ambientLighting . ambientLighting encodeForJSON .
		#backgroundColor . backgroundColor encodeForJSON .
		#fogMode . fogMode .
		#fogColor . fogColor encodeForJSON .
		#fogStartDistance . fogStartDistance.
		#fogEndDistance . fogEndDistance.
		#fogDensity . fogDensity.
		#hdri . hdri.
		#useHDRIAsSkybox. useHDRIAsSkybox.
		#children . self children collect: [ :each | each encodeForJSONWithContext: serializationContext ] as: Array
	}
]

{ #category : #accessing }
WDModelingTree >> fogColor [

	^ fogColor
]

{ #category : #accessing }
WDModelingTree >> fogColor: anObject [
	fogColor := anObject.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingTree >> fogDensity [

	^ fogDensity
]

{ #category : #accessing }
WDModelingTree >> fogDensity: anObject [

	fogDensity := anObject.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingTree >> fogEndDistance [

	^ fogEndDistance
]

{ #category : #accessing }
WDModelingTree >> fogEndDistance: anObject [

	fogEndDistance := anObject.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingTree >> fogMode [

	^ fogMode
]

{ #category : #accessing }
WDModelingTree >> fogMode: aFogModeName [
	fogMode := aFogModeName asSymbol.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingTree >> fogStartDistance [

	^ fogStartDistance
]

{ #category : #accessing }
WDModelingTree >> fogStartDistance: anObject [

	fogStartDistance := anObject.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingTree >> hdri [

	^ hdri
]

{ #category : #accessing }
WDModelingTree >> hdri: anObject [
	hdri := anObject.
	self invalidateScenePresentations.
]

{ #category : #initialization }
WDModelingTree >> initialize [
	super initialize.
	backgroundColor := Color veryDarkGray asVector4.
	ambientLighting := 0.2 asVector3.
	fogMode := #NONE.
	fogColor := Vector4 zeros.
	fogStartDistance := 0.0.
	fogEndDistance := 0.0.
	fogDensity := 0.0.
	useHDRIAsSkybox := true.
	
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

	jsonData at: #ambientLighting ifPresent: [ :json |
		backgroundColor := Vector3 loadFromJson: json
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
	hdri := (jsonData at: #hdri ifAbsent: [nil]) ifNil: [ hdri ].
	useHDRIAsSkybox := (jsonData at: #useHDRIAsSkybox ifAbsent: [nil]) ifNil: [ useHDRIAsSkybox ].
	
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
WDModelingTree >> modelResolver [
	^ modelResolver
]

{ #category : #accessing }
WDModelingTree >> modelResolver: aModelResolver [
	modelResolver := aModelResolver
]

{ #category : #accessing }
WDModelingTree >> objectTypeName [
	^ 'Modeling Tree'
]

{ #category : #copying }
WDModelingTree >> postCopy [
	super postCopy.
	hdriLightProbe := nil.
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
	self validateHdriLightProbe.
	aHandle scene
		ambientLighting: ambientLighting;
		ambientLightProbe: hdriLightProbe.
		
	(useHDRIAsSkybox and: [hdriLightProbe notNil]) ifTrue: [
		aHandle extraNodes ifEmpty: [
			| backgroundNode environmentMaterial environmentMesh |
			environmentMaterial := (WDEnvironmentMapMaterial new
				background: true;
				yourself).
			
			environmentMesh := WDMeshBuilder new
				currentMaterial: environmentMaterial;
				addInteriorCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
				mesh.
			backgroundNode := (WDRenderableWithViewModeAlternatives new
				defaultAlternativeIsEmpty: true;
				flatColorShaded: environmentMesh;
				fullShaded: environmentMesh;
				yourself
			) asSceneNode.
			aHandle extraNodes: {backgroundNode}.
			aHandle material: environmentMaterial.
			aHandle scene addBackground: backgroundNode
		].
	
		aHandle material colorTexture: hdriLightProbe environment
	] ifFalse: [
		aHandle extraNodes do: [ :each | each removeFromScene ].
		aHandle extraNodes: #().
		aHandle material: nil.
	]
]

{ #category : #accessing }
WDModelingTree >> useHDRIAsSkybox [

	^ useHDRIAsSkybox
]

{ #category : #accessing }
WDModelingTree >> useHDRIAsSkybox: anObject [

	useHDRIAsSkybox := anObject.
	self invalidateScenePresentations.
]

{ #category : #'as yet unclassified' }
WDModelingTree >> validateHdriLightProbe [
	| resolvedHdriLocation |
	hdri = hdriLightProbePath ifTrue: [ ^ hdriLightProbe ].
	
	resolvedHdriLocation := assetResolver ifNotNil: [ assetResolver resolveAssetPath: hdri ].
	hdriLightProbe := resolvedHdriLocation exists
		ifTrue: [ WDLightProbe forHDRIFileReference: resolvedHdriLocation ]
		ifFalse: [ nil ].
	
	hdriLightProbePath := hdri.
	hdriLightProbe
]

{ #category : #enumerating }
WDModelingTree >> whenAddedOrRemovedElementDo: aBlock [
	self treeTopologyChangeListeners add: aBlock
]
