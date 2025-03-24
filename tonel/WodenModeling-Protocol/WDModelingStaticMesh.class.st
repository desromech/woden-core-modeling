"
I hold a static mesh.
"
Class {
	#name : 'WDModelingStaticMesh',
	#superclass : 'WDModelingSceneObject',
	#instVars : [
		'mesh'
	],
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'serialization' }
WDModelingStaticMesh class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : 'accessing' }
WDModelingStaticMesh >> localBoundingBox [
	^ mesh boundingBox
]

{ #category : 'accessing' }
WDModelingStaticMesh >> mesh [

	^ mesh
]

{ #category : 'accessing' }
WDModelingStaticMesh >> mesh: anObject [

	mesh := anObject
]

{ #category : 'accessing' }
WDModelingStaticMesh >> objectTypeName [
	^ 'StaticMesh'
]

{ #category : 'scene presentation' }
WDModelingStaticMesh >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	
	aHandle sceneNode
		castShadows: true;
		renderables: {mesh};
		removeAllChildren.
]
