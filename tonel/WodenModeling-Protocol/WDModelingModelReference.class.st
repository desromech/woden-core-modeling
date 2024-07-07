"
I am a reference to a 3D model.
"
Class {
	#name : 'WDModelingModelReference',
	#superclass : 'WDModelingSceneObject',
	#instVars : [
		'path',
		'elementName',
		'hasCollisions',
		'collisionElementName',
		'solvedModel',
		'solvedSceneNode'
	],
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'serialization' }
WDModelingModelReference class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : 'property pages' }
WDModelingModelReference >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		stringPropertyNamed: 'Path' selector: #path;
		stringPropertyNamed: 'Element Name' selector: #elementName;
		booleanPropertyNamed: 'Has Collisions' selector: #hasCollisions;
		stringPropertyNamed: 'Collision Element Name' selector: #collisionElementName
]

{ #category : 'accessing' }
WDModelingModelReference >> collisionElementName [

	^ collisionElementName
]

{ #category : 'accessing' }
WDModelingModelReference >> collisionElementName: anObject [

	collisionElementName := anObject
]

{ #category : 'accessing' }
WDModelingModelReference >> elementName [

	^ elementName
]

{ #category : 'accessing' }
WDModelingModelReference >> elementName: anObject [
	elementName := anObject.
	solvedSceneNode := nil.
	self invalidateScenePresentations
]

{ #category : 'serialization' }
WDModelingModelReference >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#path. path.
		#elementName. elementName.
		#hasCollisions. hasCollisions.
		#collisionElementName. collisionElementName.
	}
]

{ #category : 'accessing' }
WDModelingModelReference >> hasCollisions [

	^ hasCollisions
]

{ #category : 'accessing' }
WDModelingModelReference >> hasCollisions: anObject [

	hasCollisions := anObject
]

{ #category : 'initialization' }
WDModelingModelReference >> initialize [
	super initialize.
	path := ''.
	elementName := ''.
	collisionElementName := ''.
	hasCollisions := true.
	
]

{ #category : 'accessing' }
WDModelingModelReference >> invalidateModelPresentation [
	solvedModel := nil.
	solvedSceneNode := nil.
	self invalidateScenePresentations
]

{ #category : 'testing' }
WDModelingModelReference >> isPointPlacedElement [
	^ true
]

{ #category : 'serialization' }
WDModelingModelReference >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	path := (jsonData at: #path ifAbsent: [ nil ]) ifNil: [ path ].
	elementName := (jsonData at: #elementName ifAbsent: [ nil ]) ifNil: [ elementName ].
	hasCollisions := (jsonData at: #hasCollisions ifAbsent: [ nil ]) ifNil: [ hasCollisions ].
	collisionElementName := (jsonData at: #collisionElementName ifAbsent: [ nil ]) ifNil: [ collisionElementName ].
	
]

{ #category : 'accessing' }
WDModelingModelReference >> localBoundingBox [
	self validSolvedSceneNode ifNotNil: [ :validSolvedSceneNode |
		| sceneNodeBoundingBox |
		sceneNodeBoundingBox := validSolvedSceneNode localBoundingBox.
		sceneNodeBoundingBox isEmpty ifFalse: [ 
			^ sceneNodeBoundingBox
		]
	].

	^ WDModelingCommonMeshes uniqueInstance pointObjectBoundingBox
]

{ #category : 'accessing' }
WDModelingModelReference >> objectTypeName [
	^ 'ModelReference'
]

{ #category : 'accessing' }
WDModelingModelReference >> path [

	^ path
]

{ #category : 'accessing' }
WDModelingModelReference >> path: aModelPath [
	path := aModelPath.
	self invalidateModelPresentation
]

{ #category : 'copying' }
WDModelingModelReference >> postCopy [
	super postCopy.
	solvedModel := nil.
	solvedSceneNode := nil.
	
]

{ #category : 'scene presentation' }
WDModelingModelReference >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	
	aHandle sceneNode
		castShadows: true;
		renderables: #();
		removeAllChildren.
	
	self validSolvedSceneNode ifNotNil: [ :validSolvedSceneNode |
		aHandle sceneNode add: validSolvedSceneNode
	] ifNil: [
		aHandle sceneNode
			castShadows: false;
			renderables: {
			WDModelingCommonMeshes uniqueInstance pointObjectDisplayBox copyWithMaterial: WDModelingCommonMeshes uniqueInstance orangePointObjectDisplayMaterial
		}
	]

]

{ #category : 'as yet unclassified' }
WDModelingModelReference >> validSolvedModel [
	^ solvedModel ifNil: [
		solvedModel := self findModelResolver ifNotNil: [:resolver |
			resolver loadModelWithPath: path
		]
	]
]

{ #category : 'as yet unclassified' }
WDModelingModelReference >> validSolvedSceneNode [
	^ solvedSceneNode ifNil: [
		solvedSceneNode := self validSolvedModel ifNotNil: [ :validSolvedModel |
			validSolvedModel instanceSceneNodeForElementNamed: elementName
		]
	]
]
