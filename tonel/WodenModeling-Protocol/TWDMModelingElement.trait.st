"
I provide the protocol that is required to be implemented by a modeling tree element.
"
Trait {
	#name : #TWDMModelingElement,
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #adding }
TWDMModelingElement >> add: anElement [
	self error: 'Children cannot be added to me'
]

{ #category : #'scene presentation' }
TWDMModelingElement >> addChildOntoScenePresentations: aChild [
	self scenePresentationHandles do: [ :eachHandle |
		| childHandle |
		childHandle := aChild makeScenePresentationHandleFor: eachHandle scene.
		childHandle addOntoSceneNode: eachHandle sceneNode.
		eachHandle addChild: childHandle.
	].
]

{ #category : #'scene presentation' }
TWDMModelingElement >> addChildrenOntoScenePresentationHandle: aPresentationHandle [
	self children do: [ :each |
		| childHandle |
		childHandle := each makeScenePresentationHandleFor: aPresentationHandle scene.
		childHandle addOntoSceneNode: aPresentationHandle sceneNode.
		aPresentationHandle addChild: childHandle.
	].

]

{ #category : #'scene presentation' }
TWDMModelingElement >> addChildrenOntoScenePresentations [
	self scenePresentationHandles do: [ :each | self addChildrenOntoScenePresentationHandle: each ]
]

{ #category : #testing }
TWDMModelingElement >> canAddOrRemoveChildren [
	^ false
]

{ #category : #testing }
TWDMModelingElement >> canBeDuplicatedAndPlaced [
	^ false
]

{ #category : #testing }
TWDMModelingElement >> canBeSubtracted [
	^ false
]

{ #category : #accessing }
TWDMModelingElement >> children [
	^ #()
]

{ #category : #accessing }
TWDMModelingElement >> editionViewColor [
	^ Color white
]

{ #category : #accessing }
TWDMModelingElement >> editionViewColor: aColor [
]

{ #category : #'scene presentation' }
TWDMModelingElement >> findMaterialResolver [
	^ self modelingTreeRoot ifNotNil: [ :root | root materialResolver ]
]

{ #category : #queries }
TWDMModelingElement >> findVolumeElementsThatIntersectElements: volumesToTest [
	| result |
	result := OrderedCollection new.
	self findVolumeElementsThatIntersectElements: volumesToTest into: result.
	^ result
]

{ #category : #queries }
TWDMModelingElement >> findVolumeElementsThatIntersectElements: volumesToTest into: result [
]

{ #category : #accessing }
TWDMModelingElement >> globalTransform [
	^ self parent
		ifNil: [ self transform ]
		ifNotNil: [ :p | p globalTransform transformTransform: self transform ]
]

{ #category : #'scene presentation' }
TWDMModelingElement >> initializeScenePresentationHandle: presentationHandle [
]

{ #category : #inspector }
TWDMModelingElement >> inspectionScene [
	<inspectorPresentationOrder: 20 title: 'Scene'>

	| scene |
	scene := WDScene new.
	self presentInScene: scene.
	
	^ WDSpInteractiveScenePresenter new 
		scene: scene;
		camera: (WDCamera new asSceneNode position: (Vector3 x: 0 y: 0 z: 3));
		yourself
]

{ #category : #inspector }
TWDMModelingElement >> inspectionTree [
	<inspectorPresentationOrder: 10 title: 'Tree'>

	^ SpTreePresenter new 
		roots: { self };
		children: [ :aNode | aNode children ];
		display: [ :each | each treeDisplayName ];
		yourself
]

{ #category : #testing }
TWDMModelingElement >> isSceneSelectableObject [
	^ false
]

{ #category : #'scene presentation' }
TWDMModelingElement >> makeScenePresentationHandleFor: aScene [
	^ self explicitRequirement 
]

{ #category : #'scene presentation' }
TWDMModelingElement >> materialResolver [
	^ nil
]

{ #category : #memento }
TWDMModelingElement >> materialStateMemento [
	^ nil
]

{ #category : #accessing }
TWDMModelingElement >> modelingTreeRoot [
	^ self parent ifNil: [ self ] ifNotNil: [ :p | p modelingTreeRoot ]
]

{ #category : #accessing }
TWDMModelingElement >> name [
	^ self explicitRequirement
]

{ #category : #accessing }
TWDMModelingElement >> name: theName [
	^ self explicitRequirement
]

{ #category : #accessing }
TWDMModelingElement >> objectTypeName [
	self explicitRequirement
]

{ #category : #accessing }
TWDMModelingElement >> parent [
	^ nil
]

{ #category : #accessing }
TWDMModelingElement >> parent: aParent [

]

{ #category : #memento }
TWDMModelingElement >> positionStateMemento [
	^ nil
]

{ #category : #'scene presentation' }
TWDMModelingElement >> presentInScene: aScene [
	^ (self makeScenePresentationHandleFor: aScene)
		addOntoScene;
		yourself
]

{ #category : #selection }
TWDMModelingElement >> rayPickElements: picker [
]

{ #category : #adding }
TWDMModelingElement >> remove: anElement [
	self error: 'Children cannot be removed from me'
]

{ #category : #adding }
TWDMModelingElement >> removeFromParent [
	^ self parent ifNotNil: [:p | p remove: self ]
]

{ #category : #'scene presentation' }
TWDMModelingElement >> removedFromModelTree [
]

{ #category : #memento }
TWDMModelingElement >> restoreMaterialStateMemento: aMemento [
]

{ #category : #memento }
TWDMModelingElement >> restorePositionStateMemento: aMemento [
]

{ #category : #memento }
TWDMModelingElement >> restoreTransformStateMemento: aMemento [
]

{ #category : #'scene presentation' }
TWDMModelingElement >> scenePresentationHandles [
	^ #()
]

{ #category : #accessing }
TWDMModelingElement >> transform [
	^ TRSTransform3D identity
]

{ #category : #memento }
TWDMModelingElement >> transformStateMemento [
	^ nil
]

{ #category : #inspector }
TWDMModelingElement >> treeDisplayName [
	^ String streamContents: [ :stream | 
		stream
			nextPut: $[; nextPutAll: self objectTypeName; nextPut: $];
			space; nextPutAll: self name
	]
]

{ #category : #enumerating }
TWDMModelingElement >> treeTopologyChanged [
]

{ #category : #'scene presentation' }
TWDMModelingElement >> updateScenePresentationHandle: presentationHandle [
]

{ #category : #accessing }
TWDMModelingElement >> visible [
	^ true
]

{ #category : #accessing }
TWDMModelingElement >> visible: aBoolean [
	
]
