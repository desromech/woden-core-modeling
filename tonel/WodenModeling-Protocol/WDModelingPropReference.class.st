Class {
	#name : #WDModelingPropReference,
	#superclass : #WDModelingSceneObject,
	#instVars : [
		'path',
		'solvedModel',
		'solvedSceneNode'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingPropReference class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : #'property pages' }
WDModelingPropReference >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		stringPropertyNamed: 'Path' selector: #path
]

{ #category : #serialization }
WDModelingPropReference >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#path. path.
	}
]

{ #category : #initialization }
WDModelingPropReference >> initialize [
	super initialize.
	path := ''.
]

{ #category : #accessing }
WDModelingPropReference >> invalidateModelPresentation [
	solvedModel := nil.
	solvedSceneNode := nil.
	self invalidateScenePresentations
]

{ #category : #testing }
WDModelingPropReference >> isPointPlacedElement [
	^ true
]

{ #category : #serialization }
WDModelingPropReference >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	path := (jsonData at: #path ifAbsent: [ nil ]) ifNil: [ path ].
]

{ #category : #accessing }
WDModelingPropReference >> localBoundingBox [
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
WDModelingPropReference >> objectTypeName [
	^ 'PropReference'
]

{ #category : #accessing }
WDModelingPropReference >> path [

	^ path
]

{ #category : #accessing }
WDModelingPropReference >> path: anObject [

	path := anObject
]

{ #category : #serialization }
WDModelingPropReference >> updateScenePresentationHandle: aHandle [
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

{ #category : #serialization }
WDModelingPropReference >> validSolvedModel [
	^ solvedModel ifNil: [
		solvedModel := self findModelResolver ifNotNil: [:resolver |
			resolver loadPropModelWithPath: path
		]
	]
]

{ #category : #serialization }
WDModelingPropReference >> validSolvedSceneNode [
	^ solvedSceneNode ifNil: [
		solvedSceneNode := self validSolvedModel ifNotNil: [ :validSolvedModel |
			validSolvedModel instanceDefaultSceneNode
		]
	]
]
