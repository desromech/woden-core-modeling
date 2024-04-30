"
I am a reference to a 3D model.
"
Class {
	#name : #WDModelingModelReference,
	#superclass : #WDModelingSceneObject,
	#instVars : [
		'path',
		'solvedModel',
		'solvedSceneNode'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingModelReference class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : #'property pages' }
WDModelingModelReference >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		stringPropertyNamed: 'Path' selector: #path
]

{ #category : #serialization }
WDModelingModelReference >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#path . path.
	}
]

{ #category : #initialization }
WDModelingModelReference >> initialize [
	super initialize.
	path := ''.
]

{ #category : #accessing }
WDModelingModelReference >> invalidateModelPresentation [
	solvedModel := nil.
	solvedSceneNode := nil.
	self invalidateScenePresentations
]

{ #category : #testing }
WDModelingModelReference >> isPointPlacedElement [
	^ true
]

{ #category : #serialization }
WDModelingModelReference >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	path := (jsonData at: #path ifAbsent: [ nil ]) ifNil: [ path ].
]

{ #category : #accessing }
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

{ #category : #accessing }
WDModelingModelReference >> objectTypeName [
	^ 'ModelReference'
]

{ #category : #accessing }
WDModelingModelReference >> path [

	^ path
]

{ #category : #accessing }
WDModelingModelReference >> path: aModelPath [
	path := aModelPath.
	self invalidateModelPresentation
]

{ #category : #'scene presentation' }
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

{ #category : #'as yet unclassified' }
WDModelingModelReference >> validSolvedModel [
	^ solvedModel ifNil: [
		solvedModel := self findModelResolver ifNotNil: [:resolver |
			resolver loadModelWithPath: path
		]
	]
]

{ #category : #'as yet unclassified' }
WDModelingModelReference >> validSolvedSceneNode [
	^ solvedSceneNode ifNil: [
		solvedSceneNode := self validSolvedModel ifNotNil: [ :validSolvedModel |
			validSolvedModel instanceDefaultSceneNode
		]
	]
]
