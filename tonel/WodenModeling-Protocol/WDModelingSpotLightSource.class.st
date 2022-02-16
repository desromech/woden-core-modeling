"
I am a modeling spot light source.
"
Class {
	#name : #WDModelingSpotLightSource,
	#superclass : #WDModelingLightSource,
	#instVars : [
		'influenceRadius',
		'innerCutoff',
		'outerCutoff'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingSpotLightSource >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#influenceRadius . influenceRadius .
		#innerCutoff . innerCutoff.
		#outerCutoff . outerCutoff.
	}
]

{ #category : #accessing }
WDModelingSpotLightSource >> influenceRadius [

	^ influenceRadius
]

{ #category : #accessing }
WDModelingSpotLightSource >> influenceRadius: anObject [
	influenceRadius := anObject.
	self invalidateScenePresentations.
]

{ #category : #initialization }
WDModelingSpotLightSource >> initialize [
	super initialize.
	influenceRadius := 1.0.
	innerCutoff := 45.0.
	outerCutoff := 60.0.
]

{ #category : #accessing }
WDModelingSpotLightSource >> innerCutoff [

	^ innerCutoff
]

{ #category : #accessing }
WDModelingSpotLightSource >> innerCutoff: anObject [

	innerCutoff := anObject
]

{ #category : #serialization }
WDModelingSpotLightSource >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	influenceRadius := (jsonData at: #influenceRadius ifAbsent: [ nil ]) ifNil: [ influenceRadius ].
	innerCutoff := (jsonData at: #innerCutoff ifAbsent: [ nil ]) ifNil: [ innerCutoff ].
	outerCutoff := (jsonData at: #outerCutoff ifAbsent: [ nil ]) ifNil: [ outerCutoff ].
]

{ #category : #accessing }
WDModelingSpotLightSource >> objectTypeName [
	^ 'SpotLightSource'
]

{ #category : #accessing }
WDModelingSpotLightSource >> outerCutoff [

	^ outerCutoff
]

{ #category : #accessing }
WDModelingSpotLightSource >> outerCutoff: anObject [

	outerCutoff := anObject
]

{ #category : #'scene presentation' }
WDModelingSpotLightSource >> presentationLightSource [
	^ WDSpotLightSource new
		intensity: self intensityWithColor;
		influenceRadius: self influenceRadius;
		innerCutoff: innerCutoff;
		outerCutoff: outerCutoff;
		yourself
]

{ #category : #'scene presentation' }
WDModelingSpotLightSource >> presentationMesh [
	^ WDModelingCommonMeshes uniqueInstance lightSourceWithDirection
]
