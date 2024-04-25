"
I am a modeling directional light source.
"
Class {
	#name : #WDModelingDirectionalLightSource,
	#superclass : #WDModelingLightSource,
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
WDModelingDirectionalLightSource >> objectTypeName [
	^ 'DirectionalLightSource'
]

{ #category : #'scene presentation' }
WDModelingDirectionalLightSource >> presentationLightSource [
	^ WDDirectionalLightSource new
		intensity: self intensityWithColor;
		castShadows: castShadows;
		yourself
]

{ #category : #'scene presentation' }
WDModelingDirectionalLightSource >> presentationMesh [
	^ WDModelingCommonMeshes uniqueInstance lightSourceWithDirection
]
