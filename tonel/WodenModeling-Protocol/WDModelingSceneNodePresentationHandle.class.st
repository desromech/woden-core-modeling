"
I am a presentation handle that is used for displaying a scene node.
"
Class {
	#name : #WDModelingSceneNodePresentationHandle,
	#superclass : #WDModelingScenePresentationHandle,
	#instVars : [
		'sceneNode'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #adding }
WDModelingSceneNodePresentationHandle >> addOntoSceneNode: parentSceneNode [
	parentSceneNode add: sceneNode
]

{ #category : #initialization }
WDModelingSceneNodePresentationHandle >> initializeWithModel: aModel scene: aScene [
	super initializeWithModel: aModel scene: aScene.
	sceneNode := WDSceneNode new.
]

{ #category : #'scene presentation' }
WDModelingSceneNodePresentationHandle >> removedFromScene [
	sceneNode removeFromScene.
	super removedFromScene.
]

{ #category : #accessing }
WDModelingSceneNodePresentationHandle >> sceneNode [
	^ sceneNode
]
