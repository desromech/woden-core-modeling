Extension { #name : 'WDPointLightSource' }

{ #category : '*WodenModeling-Protocol' }
WDPointLightSource >> asModelingLightSource [
	^ WDModelingPointLightSource new
		color: color;
		intensity: intensity;
		castShadows: castShadows;
		influenceRadius: influenceRadius;
		yourself
]
