"
I am a presentation handle that is used for displaying a scene node.
"
Class {
	#name : 'WDModelingSceneNodePresentationHandle',
	#superclass : 'WDModelingScenePresentationHandle',
	#instVars : [
		'sceneNode',
		'extraNodes',
		'material'
	],
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'adding' }
WDModelingSceneNodePresentationHandle >> addOntoSceneNode: parentSceneNode [
	parentSceneNode add: sceneNode
]

{ #category : 'accessing' }
WDModelingSceneNodePresentationHandle >> extraNodes [

	^ extraNodes
]

{ #category : 'accessing' }
WDModelingSceneNodePresentationHandle >> extraNodes: anObject [

	extraNodes := anObject
]

{ #category : 'initialization' }
WDModelingSceneNodePresentationHandle >> initializeWithModel: aModel scene: aScene [
	super initializeWithModel: aModel scene: aScene.
	sceneNode := WDSceneNode new.
	extraNodes := #()
]

{ #category : 'accessing' }
WDModelingSceneNodePresentationHandle >> material [

	^ material
]

{ #category : 'accessing' }
WDModelingSceneNodePresentationHandle >> material: anObject [

	material := anObject
]

{ #category : 'scene presentation' }
WDModelingSceneNodePresentationHandle >> removedFromModelTree [
	sceneNode removeFromScene.
	super removedFromModelTree.
]

{ #category : 'accessing' }
WDModelingSceneNodePresentationHandle >> sceneNode [
	^ sceneNode
]
