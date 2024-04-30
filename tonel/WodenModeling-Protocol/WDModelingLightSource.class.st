"
I am a modeling light source.
"
Class {
	#name : #WDModelingLightSource,
	#superclass : #WDModelingSceneObject,
	#instVars : [
		'color',
		'intensity',
		'castShadows'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #testing }
WDModelingLightSource class >> isAbstract [
	^ self == WDModelingLightSource
]

{ #category : #serialization }
WDModelingLightSource class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : #'property pages' }
WDModelingLightSource >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		linearColor3PropertyNamed: 'Color' selector: #color;
		scalarPropertyNamed: 'Intensity' selector: #intensity minimum: 1.0;
		booleanPropertyNamed: 'Cast Shadows' selector: #castShadows
]

{ #category : #accessing }
WDModelingLightSource >> castShadows [

	^ castShadows
]

{ #category : #accessing }
WDModelingLightSource >> castShadows: aBoolean [
	castShadows := aBoolean.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingLightSource >> color [

	^ color
]

{ #category : #accessing }
WDModelingLightSource >> color: aColor [
	color := aColor asVector3.
	self invalidateScenePresentations.
]

{ #category : #serialization }
WDModelingLightSource >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#castShadows . castShadows.
		#color . color encodeForJSON .
		#intensity . intensity.
	}
]

{ #category : #initialization }
WDModelingLightSource >> initialize [
	super initialize.
	color := Vector3 ones.
	intensity := 1.0.
	transform := TRSTransform3D identity.
	castShadows := false.
	localBoundingBox := AABox halfExtent: (Vector3 withAll: WDModelingCommonMeshes uniqueInstance lightSourceDisplayRadius)
]

{ #category : #accessing }
WDModelingLightSource >> intensity [

	^ intensity
]

{ #category : #accessing }
WDModelingLightSource >> intensity: anObject [
	intensity := anObject.
	self invalidateScenePresentations.
]

{ #category : #accessing }
WDModelingLightSource >> intensityWithColor [
	^ color asVector3 * intensity
]

{ #category : #testing }
WDModelingLightSource >> isPointModelingElement [
	^ true
]

{ #category : #testing }
WDModelingLightSource >> isPointPlacedElement [
	^ true
]

{ #category : #serialization }
WDModelingLightSource >> loadFromJson: jsonData withContext: level [
	super loadFromJson: jsonData withContext: level.
	jsonData at: #color ifPresent: [ :data |
		color := Vector3 loadFromJson: data
	].
	castShadows := (jsonData at: #castShadows ifAbsent: [ nil ]) ifNil: [ false ].
	intensity := (jsonData at: #intensity ifAbsent: [ nil ]) ifNil: [ intensity ]
]

{ #category : #'scene presentation' }
WDModelingLightSource >> presentationLightSource [
	^ self subclassResponsibility
]

{ #category : #'scene presentation' }
WDModelingLightSource >> presentationMesh [
	self subclassResponsibility
]

{ #category : #accessing }
WDModelingLightSource >> transform: newTransform [
	super transform: newTransform withoutScale
]

{ #category : #'scene presentation' }
WDModelingLightSource >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	aHandle sceneNode
		castShadows: false;
		renderables: { self presentationMesh };
		lights: { self presentationLightSource }
]
