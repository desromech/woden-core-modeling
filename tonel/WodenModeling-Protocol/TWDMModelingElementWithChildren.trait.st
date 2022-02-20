"
I provide the implementation for a modeling element with children.
"
Trait {
	#name : #TWDMModelingElementWithChildren,
	#instVars : [
		'children'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #'add/remove' }
TWDMModelingElementWithChildren >> add: aChild [
	self children add: aChild.
	self childrenChanged.
	aChild parent: self.
	self addChildOntoScenePresentations: aChild.
	self parent ifNotNil: [ :p | p childrenChanged ].
	self modelingTreeRoot treeTopologyChanged.
]

{ #category : #testing }
TWDMModelingElementWithChildren >> canAddOrRemoveChildren [
	^ true
]

{ #category : #accessing }
TWDMModelingElementWithChildren >> children [
	^ children ifNil: [ children := OrderedCollection new ]
]

{ #category : #serialization }
TWDMModelingElementWithChildren >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#children . self children collect: [ :each | each encodeForJSONWithContext: serializationContext ]
	}
]

{ #category : #'as yet unclassified' }
TWDMModelingElementWithChildren >> findVolumeElementsThatIntersectElements: volumesToTest into: result [
	self children do: [ :each |
		each findVolumeElementsThatIntersectElements: volumesToTest into: result
	]
]

{ #category : #'as yet unclassified' }
TWDMModelingElementWithChildren >> findVolumeElementsThatIntersectFrustum: frustumToTest into: result [
	self children do: [ :each |
		each findVolumeElementsThatIntersectFrustum: frustumToTest into: result
	]
]

{ #category : #'as yet unclassified' }
TWDMModelingElementWithChildren >> highlightingOrSelectionStatusChanged [
	self children do: [ :each | each highlightingOrSelectionStatusChanged ]
]

{ #category : #initialization }
TWDMModelingElementWithChildren >> initializeScenePresentationHandle: aPresentationHandle [
	self addChildrenOntoScenePresentationHandle: aPresentationHandle

]

{ #category : #serialization }
TWDMModelingElementWithChildren >> loadFromJson: jsonData withContext: deserializationContext [
	super loadFromJson: jsonData withContext: deserializationContext.
	(jsonData at: #children ifAbsent: [ nil ]) ifNotNil: [ :childrenData |
		childrenData do: [ :childData |
			self add: (deserializationContext materializeObject: childData)
		]
	].
]

{ #category : #'as yet unclassified' }
TWDMModelingElementWithChildren >> prepareForSerializationWithContext: serializationContext [
	self children do: [ :each | each prepareForSerializationWithContext: serializationContext ]
]

{ #category : #selection }
TWDMModelingElementWithChildren >> rayPickElements: picker [
	picker withTransform: self transform do: [ 
		children do: [ :each | each rayPickElements: picker ]
	].

]

{ #category : #'add/remove' }
TWDMModelingElementWithChildren >> remove: aChild [
	self children remove: aChild.
	self childrenChanged.
	self modelingTreeRoot treeTopologyChanged.
	aChild removedFromModelTree.
	self parent ifNotNil: [ :p | p childrenChanged ].
	self modelingTreeRoot treeTopologyChanged.
]

{ #category : #initialization }
TWDMModelingElementWithChildren >> setMaterialInfoRecursively: newMaterial [
	self children do: [ :each | each setMaterialInfoRecursively: newMaterial ].
]
