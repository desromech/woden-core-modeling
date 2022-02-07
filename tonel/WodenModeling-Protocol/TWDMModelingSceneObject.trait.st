"
I provide the protocol that is required to be implemented by a modeling tree element that is displayed as a scene object.
"
Trait {
	#name : #TWDMModelingSceneObject,
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
TWDMModelingSceneObject >> boundingBox [
	^ self localBoundingBox transformedWith: self transform
]

{ #category : #testing }
TWDMModelingSceneObject >> canBeDuplicatedAndPlaced [
	^ true
]

{ #category : #accessing }
TWDMModelingSceneObject >> globalBoundingBox [
	^ self localBoundingBox transformedWith: self globalTransform
]

{ #category : #testing }
TWDMModelingSceneObject >> isSceneSelectableObject [
	^ true
]

{ #category : #accessing }
TWDMModelingSceneObject >> localBoundingBox [
	^ AABox new
]

{ #category : #accessing }
TWDMModelingSceneObject >> position [
	^ self transform translation
]

{ #category : #accessing }
TWDMModelingSceneObject >> position: aPosition [
	self transform: (self transform copy translation: aPosition)
]

{ #category : #memento }
TWDMModelingSceneObject >> positionStateMemento [
	^ self position
]

{ #category : #selection }
TWDMModelingSceneObject >> rayPickElements: picker [
	| distance |
	distance := self boundingBox intersectionWithRay: picker ray.
	distance ifNotNil: [ 
		picker addResult: self withDistance: distance
	].
]

{ #category : #memento }
TWDMModelingSceneObject >> restorePositionStateMemento: aMemento [
	self position: aMemento
]

{ #category : #memento }
TWDMModelingSceneObject >> restoreTransformStateMemento: aMemento [
	self transform: aMemento
]

{ #category : #accessing }
TWDMModelingSceneObject >> selectableGlobalBoundingBox [
	^ self globalBoundingBox
]

{ #category : #'constructive solid geometry' }
TWDMModelingSceneObject >> subtract: otherElement withTransform: otherElementTransform [
	^ { self }
]

{ #category : #accessing }
TWDMModelingSceneObject >> transform: aTransform [
]

{ #category : #memento }
TWDMModelingSceneObject >> transformStateMemento [
	^ self transform copy
]

{ #category : #transforming }
TWDMModelingSceneObject >> transformWith: aTransform [
	^ self transform: (aTransform transformTransform: self transform)
]

{ #category : #transforming }
TWDMModelingSceneObject >> translateBy: aTranslation [
	self position: self position + aTranslation
]
