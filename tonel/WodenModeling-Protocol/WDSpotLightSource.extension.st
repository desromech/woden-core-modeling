Extension { #name : 'WDSpotLightSource' }

{ #category : '*WodenModeling-Protocol' }
WDSpotLightSource >> asModelingLightSource [
	^ WDModelingSpotLightSource new
		color: color;
		intensity: intensity;
		castShadows: castShadows;
		influenceRadius: influenceRadius;
		innerCutoff: innerCutoff;
		outerCutoff: outerCutoff;
		yourself
]
