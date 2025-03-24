"
I am a modeling point light source.
"
Class {
	#name : 'WDModelingPointLightSource',
	#superclass : 'WDModelingLightSource',
	#instVars : [
		'influenceRadius'
	],
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'property pages' }
WDModelingPointLightSource >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		scalarPropertyNamed: 'Influence Radius' selector: #influenceRadius minimum: 1.0
]

{ #category : 'serialization' }
WDModelingPointLightSource >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#influenceRadius . influenceRadius .
	}
]

{ #category : 'as yet unclassified' }
WDModelingPointLightSource >> exportToGltfLightWith: builder [
	^ (super exportToGltfLightWith: builder)
		type: 'point';
		range: influenceRadius;
		yourself
]

{ #category : 'accessing' }
WDModelingPointLightSource >> influenceRadius [

	^ influenceRadius
]

{ #category : 'accessing' }
WDModelingPointLightSource >> influenceRadius: anObject [
	influenceRadius := anObject.
	self invalidateScenePresentations.
]

{ #category : 'initialization' }
WDModelingPointLightSource >> initialize [
	super initialize.
	influenceRadius := 1.0.
]

{ #category : 'serialization' }
WDModelingPointLightSource >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	influenceRadius := (jsonData at: #influenceRadius ifAbsent: [ nil ]) ifNil: [ influenceRadius ]
]

{ #category : 'accessing' }
WDModelingPointLightSource >> objectTypeName [
	^ 'PointLightSource'
]

{ #category : 'scene presentation' }
WDModelingPointLightSource >> presentationLightSource [
	^ WDPointLightSource new
		intensity: self intensityWithColor;
		influenceRadius: self influenceRadius;
		castShadows: castShadows;
		yourself
]

{ #category : 'scene presentation' }
WDModelingPointLightSource >> presentationMesh [
	^ WDModelingCommonMeshes uniqueInstance lightSourceWithoutDirection
]
