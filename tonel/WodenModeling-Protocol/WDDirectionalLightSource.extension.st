Extension { #name : 'WDDirectionalLightSource' }

{ #category : '*WodenModeling-Protocol' }
WDDirectionalLightSource >> asModelingLightSource [
	^ WDModelingDirectionalLightSource new
		color: color;
		intensity: intensity;
		castShadows: castShadows;
		yourself
]
