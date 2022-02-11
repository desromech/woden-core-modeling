"
I represent a single face in a old-school bsp brush.
"
Class {
	#name : #WDMBSPBrushFace,
	#superclass : #WDModelingElement,
	#instVars : [
		'plane',
		'indices',
		'vertices',
		'textureScale',
		'textureOffset',
		'textureRotation',
		'material'
	],
	#classVars : [
		'BitangentAxis',
		'NormalAxis',
		'TangentAxis'
	],
	#category : #'WodenModeling-BSPStyleCSG'
}

{ #category : #'as yet unclassified' }
WDMBSPBrushFace class >> findAxisForNormal: normal [
	| bestAmount best |
	bestAmount := Float infinity negated.
	best := 1.
	1 to: 6 do: [ :i |
		| axis amount |
		axis := NormalAxis at: i.
		amount := normal dot: axis.
		amount > bestAmount ifTrue: [ 
			best := i.
			bestAmount := amount
		].
	].
	^ best
]

{ #category : #'as yet unclassified' }
WDMBSPBrushFace class >> getBitangentForNormalAxis: axis [
	^ BitangentAxis at: axis
]

{ #category : #'as yet unclassified' }
WDMBSPBrushFace class >> getTangentForNormalAxis: axis [
	^ TangentAxis at: axis
]

{ #category : #initialization }
WDMBSPBrushFace class >> initialize [
	NormalAxis := { 
		Vector3 x: 1.
		Vector3 x: -1.
		Vector3 y: 1.
		Vector3 y: -1.
		Vector3 z: 1.
		Vector3 z: -1.
	}.
	
	TangentAxis := { 
		Vector3 z: -1.
		Vector3 z: 1.
		Vector3 x: 1.
		Vector3 x: 1.
		Vector3 x: 1.
		Vector3 x: -1.
	}.
	
	BitangentAxis := {
		Vector3 y: -1.
		Vector3 y: -1.
		Vector3 z: 1.
		Vector3 z: -1.
		Vector3 y: -1.
		Vector3 y: -1.
	}.
]

{ #category : #serialization }
WDMBSPBrushFace class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDM'
]

{ #category : #accessing }
WDMBSPBrushFace class >> plane: aPlane [
	^ self new plane: aPlane; yourself
]

{ #category : #'mesh building' }
WDMBSPBrushFace >> addIndex: index [
	indices add: index.
	vertices := nil.
]

{ #category : #'mesh building' }
WDMBSPBrushFace >> buildSolidFaceMeshWith: builder [
	| normal brushVertices |
	builder
		currentMaterial: (parent editionViewColorMaterial withHighlightedStatus: self highlightedStatus selectedStatus: self selectedStatus );
		beginTriangles.
	normal := plane normal.
	brushVertices := parent vertices.
	indices do: [ :i |
		| v |
		v := brushVertices at: i + 1.
		builder addP: v; addN: normal
	].
	2 to: indices size - 1 do: [ :i |
		builder addTriangleI0: 0 i1: i - 1 i2: i
	].
]

{ #category : #'mesh building' }
WDMBSPBrushFace >> buildTexturedFaceMeshWith: builder transform: globalTransform [
	| normal brushVertices textureMatrix normalAxis tangent bitangent solvedMaterial |
	solvedMaterial := (material ifNotNil: [ material validMaterialWithResolver: self findMaterialResolver ])
			ifNil: [WDMetallicRoughnessMaterial default].
			
	builder
		currentMaterial: (solvedMaterial withHighlightedStatus: self highlightedStatus selectedStatus: self selectedStatus );
		beginTriangles.
	textureMatrix := self computeTextureMatrix.
		
	normal := plane normal.
	normalAxis := self class findAxisForNormal: normal.
	tangent := self class getTangentForNormalAxis: normalAxis.
	bitangent := self class getBitangentForNormalAxis: normalAxis.

	brushVertices := parent vertices.
	indices do: [ :i |
		| v wv tu tv  tc |
		v := brushVertices at: i + 1.
		wv := globalTransform transformPosition: v.
		tu := wv dot: tangent.
		tv := wv dot: bitangent.
		tc := textureMatrix transformVector2: (Vector2 x: tu y: tv).
		builder addP: v; addT0: tc; addN: normal
	].
	2 to: indices size - 1 do: [ :i |
		builder addTriangleI0: 0 i1: i - 1 i2: i
	].
]

{ #category : #'mesh building' }
WDMBSPBrushFace >> buildWireframeFaceMeshWith: builder [
	| normal brushVertices |
	builder
		beginLines.
	normal := plane normal.
	brushVertices := parent vertices.
	indices do: [ :i |
		| v |
		v := brushVertices at: i + 1.
		builder addP: v
	].
	0 to: indices size - 1 do: [ :i |
		builder addLineI0: i i1: (i + 1) % indices size
	].
]

{ #category : #'mesh building' }
WDMBSPBrushFace >> clearIndices [
	indices := OrderedCollection new.
	vertices := nil.
]

{ #category : #'as yet unclassified' }
WDMBSPBrushFace >> computePlaneFromVertices [
	| parentVertices v1 v2 v3 |
	parentVertices := parent vertices.
	v1 := parent vertices at: indices first + 1.
	v2 := parent vertices at: indices second + 1.
	v3 := parent vertices at: indices third + 1.

	plane := Plane point: v1 point: v2 point: v3
]

{ #category : #initialization }
WDMBSPBrushFace >> computeTextureMatrix [
	^ Matrix3x3 texScale: textureScale offset: textureOffset
]

{ #category : #serialization }
WDMBSPBrushFace >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#plane . plane encodeForJSON.
		#material . serializationContext materialInfoIndexFor: material.
		#textureScale . textureScale encodeForJSON.
		#textureOffset . textureOffset encodeForJSON.
		#textureRotation . textureRotation.
	}
]

{ #category : #'as yet unclassified' }
WDMBSPBrushFace >> highlightingOrSelectionStatusChanged [
	super highlightingOrSelectionStatusChanged.
	parent ifNotNil: [ :p | p invalidateMeshes ]
]

{ #category : #accessing }
WDMBSPBrushFace >> indices [
	^ indices
]

{ #category : #initialization }
WDMBSPBrushFace >> initialize [
	super initialize.
	textureScale := Vector2 withAll: 0.25.
	textureOffset := Vector2 zeros.
	textureRotation := 0.
]

{ #category : #serialization }
WDMBSPBrushFace >> loadFromJson: jsonData withContext: deserializationContext [
	super loadFromJson: jsonData withContext: deserializationContext.
	plane := Plane loadFromJson: (jsonData at: #plane).
	(jsonData at: #material ifAbsent: [nil]) ifNotNil: [ :materialIndex |
		material := deserializationContext getMaterialInfoWithIndex: materialIndex
	].
	textureScale := Vector2 loadFromJson: (jsonData at: #textureScale).
	textureOffset := Vector2 loadFromJson: (jsonData at: #textureOffset).
	textureRotation := jsonData at: #textureRotation.

]

{ #category : #accessing }
WDMBSPBrushFace >> material [
	^ material
]

{ #category : #accessing }
WDMBSPBrushFace >> material: aMaterial [
	| changed newMaterial |
	newMaterial := aMaterial asWDModelingMaterialInfo.
	changed := material ~~ newMaterial.
	material := newMaterial.
	(changed and: [parent isNotNil]) ifTrue: [ parent faceTexturesChanged ].
]

{ #category : #accessing }
WDMBSPBrushFace >> objectTypeName [
	^ 'Face'
]

{ #category : #accessing }
WDMBSPBrushFace >> plane [

	^ plane
]

{ #category : #accessing }
WDMBSPBrushFace >> plane: anObject [

	plane := anObject
]

{ #category : #serialization }
WDMBSPBrushFace >> prepareForSerializationWithContext: serializationContext [
	super prepareForSerializationWithContext: serializationContext.
	serializationContext recordMaterialInfo: material
]

{ #category : #initialization }
WDMBSPBrushFace >> setMaterialInfoRecursively: newMaterial [
	self material: newMaterial
]

{ #category : #'mesh building' }
WDMBSPBrushFace >> sortIndices [
	| centroid n brushVertices |
	brushVertices := parent vertices.
	centroid := Vector3 zeros.
	indices do: [ :i |
		centroid := centroid + (brushVertices at: i + 1)
	].
	centroid := centroid / indices size.
	n := plane normal.

	indices sort: [ :a :b |
		| u v |
		u := centroid - (brushVertices at: a + 1).
		v := centroid - (brushVertices at: b + 1).
		((u cross: v) dot: n) >= 0
	]
]

{ #category : #accessing }
WDMBSPBrushFace >> textureOffset [

	^ textureOffset
]

{ #category : #accessing }
WDMBSPBrushFace >> textureOffset: anObject [

	textureOffset := anObject
]

{ #category : #accessing }
WDMBSPBrushFace >> textureRotation [

	^ textureRotation
]

{ #category : #accessing }
WDMBSPBrushFace >> textureRotation: anObject [

	textureRotation := anObject
]

{ #category : #accessing }
WDMBSPBrushFace >> textureScale [

	^ textureScale
]

{ #category : #accessing }
WDMBSPBrushFace >> textureScale: anObject [

	textureScale := anObject
]

{ #category : #accessing }
WDMBSPBrushFace >> vertices [
	^ vertices ifNil: [
		| brushVertices |
		brushVertices := parent vertices.
		vertices := indices collect: [ :i | brushVertices at: i + 1 ]
	]
]
