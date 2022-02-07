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

{ #category : #inspector }
TWDMModelingElement >> inspectionTree [
	<inspectorPresentationOrder: 10 title: 'Tree'>

	^ SpTreePresenter new 
		roots: { self };
		children: [ :aNode | aNode children ];
		display: [ :each | each treeDisplayName ];
		yourself
]

{ #category : #memento }
TWDMModelingElement >> materialStateMemento [
	^ nil
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

{ #category : #memento }
TWDMModelingElement >> positionStateMemento [
	^ nil
]

{ #category : #adding }
TWDMModelingElement >> remove: anElement [
	self error: 'Children cannot be removed from me'
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
