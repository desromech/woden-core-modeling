"
I provide the protocol that is required to be implemented by a modeling tree element that is displayed as a scene object.
"
Trait {
	#name : #TWDMModelingSceneObject,
	#traits : 'TWDMModelingElement',
	#classTraits : 'TWDMModelingElement classTrait',
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
TWDMModelingSceneObject >> editionViewColor [
	^ Color white
]

{ #category : #accessing }
TWDMModelingSceneObject >> editionViewColor: aColor [
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

{ #category : #memento }
TWDMModelingSceneObject >> restorePositionStateMemento: aMemento [
	self position: aMemento
]

{ #category : #memento }
TWDMModelingSceneObject >> restoreTransformStateMemento: aMemento [
	self transform: aMemento
]

{ #category : #'constructive solid geometry' }
TWDMModelingSceneObject >> subtract: otherElement withTransform: otherElementTransform [
	^ { self }
]

{ #category : #accessing }
TWDMModelingSceneObject >> transform [
	^ TRSTransform3D identity
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
