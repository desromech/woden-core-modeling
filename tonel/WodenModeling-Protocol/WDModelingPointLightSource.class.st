"
I am a modeling point light source.
"
Class {
	#name : #WDModelingPointLightSource,
	#superclass : #WDModelingLightSource,
	#instVars : [
		'influenceRadius'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingPointLightSource >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#influenceRadius . influenceRadius .
	}
]

{ #category : #accessing }
WDModelingPointLightSource >> influenceRadius [

	^ influenceRadius
]

{ #category : #accessing }
WDModelingPointLightSource >> influenceRadius: anObject [
	influenceRadius := anObject.
	self invalidateScenePresentations.
]

{ #category : #serialization }
WDModelingPointLightSource >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	influenceRadius := (jsonData at: #influenceRadius ifAbsent: [ nil ]) ifNil: [ influenceRadius ]
]

{ #category : #accessing }
WDModelingPointLightSource >> objectTypeName [
	^ 'PointLightSource'
]

{ #category : #'scene presentation' }
WDModelingPointLightSource >> presentationLightSource [
	^ WDPointLightSource new
		intensity: self intensityWithColor;
		influenceRadius: self influenceRadius;
		yourself
]

{ #category : #'scene presentation' }
WDModelingPointLightSource >> presentationMesh [
	^ WDModelingCommonMeshes uniqueInstance lightSourceWithoutDirection
]
