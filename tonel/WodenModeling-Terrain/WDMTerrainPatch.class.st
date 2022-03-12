"
I am a patch in a height field based terrains.
"
Class {
	#name : #WDMTerrainPatch,
	#superclass : #WDModelingElement,
	#traits : 'TWDMModelingElementWithEditionViewColor + TWDMModelingElementWithTextureMappingSettings',
	#classTraits : 'TWDMModelingElementWithEditionViewColor classTrait + TWDMModelingElementWithTextureMappingSettings classTrait',
	#instVars : [
		'patchSize',
		'row',
		'column',
		'heights',
		'textureScale',
		'textureOffset',
		'textureRotation',
		'localBoundingBox',
		'meshWithAlternatives',
		'wireframeMesh',
		'texturedMesh',
		'solidMesh',
		'material'
	],
	#category : #'WodenModeling-Terrain'
}

{ #category : #serialization }
WDMTerrainPatch class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDM'
]

{ #category : #accessing }
WDMTerrainPatch >> boundingBox [
	^ self localBoundingBox translatedBy: self position
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> buildPatchSolidWith: builder [
	| vx sourceIndex vz |
	builder
		beginTriangles.
	sourceIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)).
		0 to: patchSize - 1 do: [ :x |
			|b t l r c|
			vx := (x / (patchSize - 1)).
			t := b := l := r := c := heights at: sourceIndex.
			y > 0 ifTrue: [ b := heights at: sourceIndex - patchSize ].
			y + 1 < patchSize ifTrue: [ t := heights at: sourceIndex + patchSize ].
			x > 0 ifTrue: [ l := heights at: sourceIndex - 1 ].
			x + 1 < patchSize ifTrue: [ r := heights at: sourceIndex + 1 ].
			
			builder
				addPx: vx y: c z: vz;
				addN: (self computeNormalWithDx: r - l dz: t - b).
			sourceIndex := sourceIndex + 1.
		]
	].

	0 to: patchSize - 2 do: [ :y |
		| rowStart |
		rowStart := patchSize * y.
		0 to: patchSize - 2 do: [ :x |
			builder
				addTriangleI0: rowStart + x + patchSize + 1 i1: rowStart + x + 1 i2: rowStart + x;
				addTriangleI0: rowStart + x i1: rowStart + x + patchSize i2: rowStart + x + patchSize + 1.
			sourceIndex := sourceIndex + 1.
		].
	].
	
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> buildPatchTexturedWith: builder [
	| vx sourceIndex vz textureMatrix terrainScale |
	builder
		currentMaterial: ((material ifNotNil: [ material validMaterialWithResolver: self findMaterialResolver ])
			ifNil: [WDMetallicRoughnessMaterial default]);
		beginTriangles.
	terrainScale := parent ifNotNil: [parent transform scale] ifNil: [Vector3 withAll: 1].
	sourceIndex := 1.
	textureMatrix := self computeTextureMatrix.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)).
		0 to: patchSize - 1 do: [ :x |
			| t b l r c tc |
			vx := (x / (patchSize - 1)).
			t := b := l := r := c := heights at: sourceIndex.
			y > 0 ifTrue: [ b := heights at: sourceIndex - patchSize ].
			y + 1 < patchSize ifTrue: [ t := heights at: sourceIndex + patchSize ].
			x > 0 ifTrue: [ l := heights at: sourceIndex - 1 ].
			x + 1 < patchSize ifTrue: [ r := heights at: sourceIndex + 1 ].
			tc := textureMatrix transformVector2: (Vector2 x: vx * terrainScale x y: vz * terrainScale z).
			
			builder
				addPx: vx y: c z: vz;
				addT0: tc;
				addN: (self computeNormalWithDx: r - l dz: t - b).
			sourceIndex := sourceIndex + 1.
		]
	].

	0 to: patchSize - 2 do: [ :y |
		| rowStart |
		rowStart := patchSize * y.
		0 to: patchSize - 2 do: [ :x |
			builder
				addTriangleI0: rowStart + x + patchSize + 1 i1: rowStart + x + 1 i2: rowStart + x;
				addTriangleI0: rowStart + x i1: rowStart + x + patchSize i2: rowStart + x + patchSize + 1.
			sourceIndex := sourceIndex + 1.
		].
	].
	
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> buildPatchWireframeWith: builder [
	| vx sourceIndex vz |
	builder
		beginLines.
	sourceIndex := 1.
	0 to: patchSize - 1 do: [ :y |
		vz := (y / (patchSize - 1)).
		0 to: patchSize - 1 do: [ :x |
			vx := (x / (patchSize - 1)).
			builder addPx: vx y: (heights at: sourceIndex) z: vz.
			sourceIndex := sourceIndex + 1.
		]
	].

	0 to: patchSize - 1 do: [ :y |
		| rowStart |
		rowStart := patchSize * y.
		0 to: patchSize - 1 do: [ :x |
			x + 1 < patchSize ifTrue: [ 
				builder addLineI0: rowStart + x i1: rowStart + x + 1.
			].
			y + 1 < patchSize  ifTrue: [ 
				builder addLineI0: rowStart + x i1: rowStart + x + patchSize.
			].
			sourceIndex := sourceIndex + 1.
		].
	].
	
]

{ #category : #accessing }
WDMTerrainPatch >> column [

	^ column
]

{ #category : #accessing }
WDMTerrainPatch >> column: anObject [

	column := anObject
]

{ #category : #accessing }
WDMTerrainPatch >> columns [
	^ parent ifNil: [ 1 ] ifNotNil: [ parent columns ]
]

{ #category : #'topology edition mode' }
WDMTerrainPatch >> commitSculptingChanges [
	self invalidateMeshes
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> computeNormalWithDx: dx dz: dz [
	| tangent bitangent |
	tangent := Vector3 x: 1 y: dx z: 0.
	bitangent := Vector3 x: 0 y: dz z: -1.
	^ (tangent cross: bitangent) normalized
]

{ #category : #serialization }
WDMTerrainPatch >> encodeJsonKeyValuesWithContext: serializationContext [
	| heightBytes encodedHeights |
	heightBytes := heights shallowCopy.
	ByteArray adoptInstance: heightBytes.
	encodedHeights := heightBytes base64Encoded.
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#editionViewColor . self editionViewColor asVector4 encodeForJSON.
		#heights . encodedHeights.
		#material . serializationContext materialInfoIndexFor: material.
		#textureScale . textureScale encodeForJSON .
		#textureOffset . textureOffset encodeForJSON .
		#textureRotation . textureRotation.
	}
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> generateLocalHeightWith: aBlock [
	| newHeights destIndex columnOffset rowOffset |
	newHeights := FloatArray new: patchSize * patchSize.
	destIndex := 1.
	columnOffset := column.
	rowOffset := row.
	
	0 to: patchSize - 1 do: [ :y |
		0 to: patchSize - 1 do: [ :x |
			newHeights at: destIndex put: (aBlock value: x / (patchSize - 1) + columnOffset value: y / (patchSize - 1) + rowOffset).
			destIndex := destIndex + 1
		]
	].
	self heights: newHeights
]

{ #category : #accessing }
WDMTerrainPatch >> heights [

	^ heights
]

{ #category : #accessing }
WDMTerrainPatch >> heights: newHeight [
	heights := newHeight.
	self heightsChanged
	
]

{ #category : #accessing }
WDMTerrainPatch >> heightsChanged [
	self invalidateMeshes.
	localBoundingBox := nil.
	parent ifNotNil: [ parent invalidateLocalBoundingBox ]
	
]

{ #category : #initialization }
WDMTerrainPatch >> initialize [
	super initialize.
	patchSize := 32.
	row := 0.
	column := 0.
	heights := FloatArray new: patchSize*patchSize.
	textureScale := Vector2 withAll: 1.0.
	textureOffset := Vector2 withAll: 0.0.
	textureRotation := 0.0
]

{ #category : #'scene presentation' }
WDMTerrainPatch >> initializeScenePresentationHandle: aHandle [
	super initializeScenePresentationHandle: aHandle.
	aHandle sceneNode transform: self transform
]

{ #category : #caching }
WDMTerrainPatch >> invalidateMeshes [
	wireframeMesh := nil.
	solidMesh := nil.
	self invalidateTexturedMeshes
]

{ #category : #caching }
WDMTerrainPatch >> invalidateTexturedMeshes [
	texturedMesh := nil.
	meshWithAlternatives := nil.
	self invalidateScenePresentations
]

{ #category : #serialization }
WDMTerrainPatch >> loadFromJson: jsonData withContext: deserializationContext [
	| encodedHeights |
	super loadFromJson: jsonData withContext: deserializationContext.
	encodedHeights := jsonData at: #heights.
	(jsonData at: #editionViewColor ifAbsent: [ nil ]) ifNotNil: [ :c |
		self editionViewColor: (Vector4 loadFromJson: c) asColor
	].
	heights := encodedHeights base64Decoded shallowCopy.
	FloatArray adoptInstance: heights.

	(jsonData at: #material ifAbsent: [nil]) ifNotNil: [ :materialIndex |
		material := deserializationContext getMaterialInfoWithIndex: materialIndex
	].

	(jsonData at: #textureScale ifAbsent: [ nil ]) ifNotNil: [ :d |
		textureScale := Vector2 loadFromJson: d
	].
	(jsonData at: #textureOffset ifAbsent: [ nil ]) ifNotNil: [ :d |
		textureOffset := Vector2 loadFromJson: d
	].

	textureRotation := (jsonData at: #textureRotation ifAbsent: [nil]) ifNil: [textureRotation].
]

{ #category : #accessing }
WDMTerrainPatch >> localBoundingBox [
	localBoundingBox ifNil: [ 
		localBoundingBox := AABox min: (Vector3 x: 0 y: heights min z: 0) max: (Vector3 x: 1 y: heights max z: 1)
	].
	^ localBoundingBox
]

{ #category : #accessing }
WDMTerrainPatch >> material [
	^ material
]

{ #category : #accessing }
WDMTerrainPatch >> material: aMaterial [
	| changed newMaterial |
	newMaterial := aMaterial asWDModelingMaterialInfo.
	changed := material ~~ newMaterial.
	material := newMaterial.
	changed ifTrue: [ self textureMappingChanged ].
]

{ #category : #accessing }
WDMTerrainPatch >> objectTypeName [
	^ 'Terrain Patch'
]

{ #category : #accessing }
WDMTerrainPatch >> patchSize: newPatchSize [
	patchSize := newPatchSize.
	heights := FloatArray new: patchSize*patchSize
]

{ #category : #accessing }
WDMTerrainPatch >> position [
	^ Vector3 x: column - (self columns / 2) y: 0 z: row - (self rows / 2)
]

{ #category : #copying }
WDMTerrainPatch >> postCopy [
	super postCopy.
	meshWithAlternatives := nil.
	wireframeMesh := nil.
	solidMesh := nil.
	texturedMesh := nil.
	editionViewColorMaterial := nil.
]

{ #category : #serialization }
WDMTerrainPatch >> prepareForSerializationWithContext: serializationContext [
	super prepareForSerializationWithContext: serializationContext.
	serializationContext recordMaterialInfo: material
]

{ #category : #accessing }
WDMTerrainPatch >> rayCast: ray [
	| position bbox boxHit entryPoint exitPoint previousPointHeight previousHeightSample |
	position := self position.
	bbox := self boundingBox.
	boxHit := bbox intersectionsWithRay: ray.
	boxHit ifNil: [ ^ nil ].
	
	entryPoint := (ray pointAtDistance: boxHit first) - position.
	exitPoint := (ray pointAtDistance: boxHit second) - position.

	previousPointHeight := entryPoint y.
	previousHeightSample := self sampleHeightAtX: entryPoint x z: entryPoint z.
	0 to: 1 by: (1 / patchSize) do: [ :alpha |
		| testPoint heightSample testPointHeight minHeightSample maxHeightSample minPointHeight maxPointHeight |
		testPoint := entryPoint interpolateTo: exitPoint at: alpha.
		heightSample := self sampleHeightAtX: testPoint x z: testPoint z.
		testPointHeight := testPoint y.
		
		minHeightSample := previousHeightSample min: heightSample.
		maxHeightSample := previousHeightSample max: heightSample.

		minPointHeight := previousPointHeight min: testPointHeight.
		maxPointHeight := previousPointHeight max: testPointHeight.
		
		(maxPointHeight < minHeightSample or: [ maxHeightSample < minPointHeight ]) ifFalse: [
			^ boxHit first interpolateTo: boxHit second at: alpha
		].
		
		previousPointHeight := testPointHeight.
		previousHeightSample := heightSample.
	].
	
	^ nil
]

{ #category : #accessing }
WDMTerrainPatch >> row [

	^ row
]

{ #category : #accessing }
WDMTerrainPatch >> row: anObject [

	row := anObject
]

{ #category : #accessing }
WDMTerrainPatch >> rows [
	^ parent ifNil: [ 1 ] ifNotNil: [ parent rows ]
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> sampleHeightAtX: x z: z [
	| sampleColumn sampleRow |
	sampleColumn := (x * patchSize) floor min: patchSize - 1 max: 0.
	sampleRow := (z * patchSize) floor min: patchSize - 1 max: 0.
	^ heights at: sampleRow*patchSize + sampleColumn + 1
]

{ #category : #'topology edition mode' }
WDMTerrainPatch >> sculptWithLocalRay: ray drawIntensity: drawIntensity drawRadius: drawRadius [
	| hitDistance hitPoint hu hv affectedIndices |
	hitDistance := self rayCast: ray.
	hitDistance ifNil: [ ^ nil ].
	
	hitPoint := (ray pointAtDistance: hitDistance) - self position.
	hu := hitPoint x * patchSize + 0.5.
	hv := hitPoint z * patchSize + 0.5.

	affectedIndices := OrderedCollection new.
	drawRadius negated to: drawRadius by: 1 do: [:cv |
		| v dv |
		v := hv + cv.
		dv := v - hv floor.
		v := v floor.
		
		(0 <= v and: [v < patchSize]) ifTrue: [
			drawRadius negated to: drawRadius by: 1 do: [:cu |
				| u du heightIndex|
				u := hu + cv.
				du := u - hu floor.
				u := u floor.

				(0 <= u and: [u < patchSize]) ifTrue: [
					| r falloff |
					r := ((du*du) + (dv*dv)) sqrt.
					falloff := 1.0 - (r / (drawRadius max: 1)) max: 0.0.
					falloff > 0 ifTrue: [ 
						heightIndex := v*patchSize + u.
						heights at: heightIndex put: (heights at: heightIndex) + (drawIntensity*falloff).
						affectedIndices add: heightIndex.
					].
				].
			]
		].
	].

	affectedIndices ifNotEmpty: [ 
		self updateMeshesHeightIndices: affectedIndices.
		self invalidateScenePresentations.
	].

]

{ #category : #initialization }
WDMTerrainPatch >> setMaterialInfoRecursively: newMaterial [
	self material: newMaterial
]

{ #category : #accessing }
WDMTerrainPatch >> textureMappingChanged [
	self invalidateTexturedMeshes
]

{ #category : #transforming }
WDMTerrainPatch >> transform [
	^ TRSTransform3D translation: self position
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> updateMesh: mesh heightIndices: heightIndicesToUpdate [
	| positionsAccessor buffer bufferData offset |
	positionsAccessor := mesh primitives first vertexBinding attributes first accessor.
	buffer := positionsAccessor bufferView buffer.
	bufferData := buffer data.
	offset := positionsAccessor bufferView byteOffset + positionsAccessor byteOffset.
	heightIndicesToUpdate do: [ :index |
		| height heightOffset |
		heightOffset := offset + (index*12) + 4 + 1.
		height := heights at: index.
		bufferData floatAt: heightOffset put: height
	].

	buffer changed

]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> updateMeshesHeightIndex: heightIndexToUpdate [
	self updateMeshesHeightIndices: { heightIndexToUpdate }
]

{ #category : #'as yet unclassified' }
WDMTerrainPatch >> updateMeshesHeightIndices: heightIndicesToUpdate [
	wireframeMesh ifNotNil: [ 
		self updateMesh: wireframeMesh heightIndices: heightIndicesToUpdate
	].
	solidMesh ifNotNil: [ 
		self updateMesh: solidMesh heightIndices: heightIndicesToUpdate
	].
	texturedMesh ifNotNil: [ 
		self updateMesh: texturedMesh heightIndices: heightIndicesToUpdate
	].
]

{ #category : #'scene presentation' }
WDMTerrainPatch >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	aHandle sceneNode renderables: { self validMeshWithAlternatives }
]

{ #category : #caching }
WDMTerrainPatch >> validMeshWithAlternatives [
	^ meshWithAlternatives ifNil: [ meshWithAlternatives := WDRenderableWithViewModeAlternatives new
		wireframe: self validWireframeMesh;
		flatColor: self validSolidMesh;
		flatColorShaded: self validSolidMesh;
		flatTextured: self validTexturedMesh;
		fullShaded: self validTexturedMesh;
		yourself
	]
]

{ #category : #caching }
WDMTerrainPatch >> validSolidMesh [
	| builder |
	solidMesh ifNotNil: [ ^ solidMesh ].
	builder := WDMeshBuilder new.
	builder
		currentMaterial: self editionViewColorMaterial.
	self buildPatchSolidWith: builder.

	^ solidMesh := builder mesh
]

{ #category : #caching }
WDMTerrainPatch >> validTexturedMesh [
	| builder |
	texturedMesh ifNotNil: [ ^ texturedMesh ].
	builder := WDMeshBuilder new.
	builder
		currentMaterial: WDMetallicRoughnessMaterial default.
	self buildPatchTexturedWith: builder.

	builder generateTangentSpaceFrame.
	^ texturedMesh := builder mesh
]

{ #category : #caching }
WDMTerrainPatch >> validWireframeMesh [
	| builder |
	wireframeMesh ifNotNil: [ ^ wireframeMesh ].
	builder := WDMeshBuilder new.
	builder currentMaterial: self editionViewColorMaterial.
	self buildPatchWireframeWith: builder.
	^ wireframeMesh := builder mesh
]
