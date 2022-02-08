"
I am a convex brush whose faces are represented by planes.

I come from old-school 3D video game editors such as Quake and family.

"
Class {
	#name : #WDMBSPBrush,
	#superclass : #WDModelingSceneObject,
	#instVars : [
		'faces',
		'hasValidTopology',
		'wireframeMesh',
		'solidMesh',
		'texturedMesh',
		'meshWithAlternatives',
		'vertices',
		'editionColorMaterial'
	],
	#category : #'WodenModeling-BSPStyleCSG'
}

{ #category : #'as yet unclassified' }
WDMBSPBrush class >> forBox: aBox [
	^ self withFaces: { 
		WDMBSPBrushFace plane: (Plane nx: -1 ny: 0 nz: 0 distance: aBox min x abs).
		WDMBSPBrushFace plane: (Plane nx: 1 ny: 0 nz: 0 distance: aBox max x abs).
		WDMBSPBrushFace plane: (Plane nx: 0 ny: -1 nz: 0 distance: aBox min y abs).
		WDMBSPBrushFace plane: (Plane nx: 0 ny: 1 nz: 0 distance: aBox max y abs).
		WDMBSPBrushFace plane: (Plane nx: 0 ny: 0 nz: -1 distance: aBox min z abs).
		WDMBSPBrushFace plane: (Plane nx: 0 ny: 0 nz: 1 distance: aBox max z abs).
	}
]

{ #category : #serialization }
WDMBSPBrush class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDM'
]

{ #category : #accessing }
WDMBSPBrush class >> unitBox [
	^ self forBox: AABox unit
]

{ #category : #'as yet unclassified' }
WDMBSPBrush class >> withFaces: aCollectionOfFaces [
	^ self new faces: aCollectionOfFaces; yourself
]

{ #category : #testing }
WDMBSPBrush >> canBeSubtracted [
	^ true
]

{ #category : #accessing }
WDMBSPBrush >> children [
	^ faces
]

{ #category : #'constructive solid geometry' }
WDMBSPBrush >> clipAgainstPlane: plane [
	| classification frontFaces backFaces planeInFront planeInBack frontPolyhedron backPolyhedron |
	self validateTopology.
	classification := plane classifyVertices: vertices epsilon: Epsilon.
	self assert: classification ~~ #inside.
	classification == #front ifTrue: [ ^ { self . nil } ].
	classification == #back ifTrue: [ ^ { nil . self } ].
	self assert: classification == #frontAndBack.
	
	frontFaces := OrderedCollection new.
	backFaces := OrderedCollection new.
	
	planeInFront := false.
	planeInBack := false.
	faces do: [ :eachFace |
		| faceClassification |
		faceClassification := plane classifyVertices: eachFace vertices epsilon: Epsilon.
		faceClassification == #inside ifTrue: [
			| normalDirection |
			normalDirection := eachFace plane normal dot: plane normal.
			normalDirection > 0 ifTrue: [
				self assert: (eachFace plane normal normalized closeTo: plane normal normalized).
				backFaces add: eachFace copy.
				planeInBack := true.
			] ifFalse: [ 
				self assert: (eachFace plane normal normalized closeTo: plane normal normalized).
				frontFaces add: (eachFace copy plane: eachFace plane negated).
				planeInFront := true.
			].
		].
		faceClassification == #front ifTrue: [ 
			frontFaces add: eachFace copy		
		].
		faceClassification == #back ifTrue: [ 
			backFaces add: eachFace copy
		].
		faceClassification == #frontAndBack ifTrue: [ 
			frontFaces add: eachFace copy.
			backFaces add: eachFace copy.
		].
	].

	planeInBack ifFalse: [
		backFaces add: (WDMBSPBrushFace plane: plane)
	].
	planeInFront ifFalse: [
		frontFaces add: (WDMBSPBrushFace plane: plane negated)
	].

	frontPolyhedron := self class new
		setupForNewInstance;
		faces: frontFaces;
		transform: transform;
		yourself.
	backPolyhedron := self class new
		setupForNewInstance;
		faces: backFaces;
		transform: transform;
		yourself.
	^ { frontPolyhedron . backPolyhedron }
]

{ #category : #serialization }
WDMBSPBrush >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#faces . faces collect: [ :each | each encodeForJSONWithContext: serializationContext ]
	}
]

{ #category : #accessing }
WDMBSPBrush >> faces [
	^ faces
]

{ #category : #accessing }
WDMBSPBrush >> faces: aListOfFaces [
	faces := aListOfFaces.
	faces do: [ :each | each parent: self ].
	self invalidateTopology
]

{ #category : #'as yet unclassified' }
WDMBSPBrush >> findVolumeElementsThatIntersectElements: elementsToTest into: result [
	(elementsToTest includes: self) ifFalse: [
		(elementsToTest anySatisfy: [ :testElement | self hasIntersectionWithVolume: testElement ]) ifTrue: [ 
			result add: self
		]
	]
]

{ #category : #'intersection testing' }
WDMBSPBrush >> hasIntersectionWithBrush: otherElement withTransform: otherElementTransform [
	| otherSupportFunction |
	self class == otherElement class ifFalse: [ ^ false ].
	
	"Test the bounding to quickly discard."
	(self localBoundingBox hasIntersectionWithBox: (otherElement localBoundingBox transformedWith: otherElementTransform)) ifFalse: [ ^ false ].
	
	"Test using GJK."
	otherSupportFunction := GeometricFunctions transformSupportFunction: (otherElement localSupportFunction) with: otherElementTransform.
	
	^ GeometricFunctions gjkIntersectionTest: self localSupportFunction with: otherSupportFunction
]

{ #category : #'intersection testing' }
WDMBSPBrush >> hasIntersectionWithConvexSupportFunction: otherSupportFunction [
	^ GeometricFunctions gjkIntersectionTest: self supportFunction with: otherSupportFunction
]

{ #category : #'intersection testing' }
WDMBSPBrush >> hasIntersectionWithVolume: volumeToTest [
	volumeToTest class == self class ifTrue: [
		^ self hasIntersectionWithBrush: volumeToTest withTransform: (self globalTransform inverseTransformTransform: volumeToTest globalTransform)
	].

	^ volumeToTest hasIntersectionWithConvexSupportFunction: self supportFunction
]

{ #category : #initialization }
WDMBSPBrush >> initialize [
	super initialize.
	hasValidTopology := false.
	faces := #()
	
]

{ #category : #caching }
WDMBSPBrush >> invalidateMeshes [
	wireframeMesh := nil.
	solidMesh := nil.
	self invalidateTexturedMeshes
]

{ #category : #caching }
WDMBSPBrush >> invalidateTexturedMeshes [
	texturedMesh := nil.
	meshWithAlternatives := nil.
	self invalidateScenePresentations
]

{ #category : #accessing }
WDMBSPBrush >> invalidateTopology [
	hasValidTopology := false.
	self invalidateMeshes
]

{ #category : #serialization }
WDMBSPBrush >> loadFromJson: jsonData withContext: deserializationContext [
	super loadFromJson: jsonData withContext: deserializationContext.
	self faces: ((jsonData at: #faces ifAbsent: [ #() ]) collect: [ :each |
		WDMBSPBrushFace new
			loadFromJson: each withContext: deserializationContext
	])
]

{ #category : #accessing }
WDMBSPBrush >> localBoundingBox [
	self validateTopology.
	^ localBoundingBox
]

{ #category : #selection }
WDMBSPBrush >> localRayPick: picker [
	| bestDistance localRay |
	bestDistance := nil.
	localRay := picker ray.
	faces do: [ :face |
		| intersectionDistance  |
		intersectionDistance := face plane intersectionWithRay: localRay.
		intersectionDistance ifNotNil: [
			| intersectionPoint |
			intersectionPoint := localRay pointAtDistance: intersectionDistance.
			(faces allSatisfy: [ :otherFace | otherFace == face or: [ otherFace plane isPointInsideOrBehind: intersectionPoint ] ]) ifTrue: [ 
				(bestDistance isNil or: [ intersectionDistance < bestDistance ]) ifTrue: [ 
					bestDistance := intersectionDistance
				]
			]
		].
	].

	bestDistance ifNil: [ ^ nil ].

	picker addResult: self withDistance: bestDistance
]

{ #category : #'intersection testing' }
WDMBSPBrush >> localSupportFunction [
	self validateTopology.
	^ [ :d |
		| best bestDot |
		best := nil.
		bestDot := Float negativeInfinity.
		vertices do: [ :v |
			| dot |
			dot := v dot: d.
			dot > bestDot ifTrue: [
				best := v.
				bestDot := dot
			]
		].
	
		best
	]
]

{ #category : #accessing }
WDMBSPBrush >> objectTypeName [
	^ 'BSP Brush'
]

{ #category : #copying }
WDMBSPBrush >> postCopy [
	super postCopy.
	parent := nil.
	self faces: (faces collect: [ :each | each copy ]).
	
	meshWithAlternatives := nil.
	wireframeMesh := nil.
	solidMesh := nil.
	texturedMesh := nil.
]

{ #category : #serialization }
WDMBSPBrush >> prepareForSerializationWithContext: serializationContext [
	super prepareForSerializationWithContext: serializationContext.
	faces do: [ :each | each prepareForSerializationWithContext: serializationContext ]
]

{ #category : #selection }
WDMBSPBrush >> rayPickElements: picker [
	picker withTransform: transform do: [
		self localRayPick: picker
	]
]

{ #category : #'constructive solid geometry' }
WDMBSPBrush >> subtract: otherBrush [
	| otherBrushTransform myTransform |
	otherBrush class == self class ifFalse: [ ^ { self } ].
	
	otherBrushTransform := otherBrush globalTransform.
	myTransform := self globalTransform.
	^ self subtract: otherBrush withTransform: (myTransform inverseTransformTransform: otherBrushTransform)
]

{ #category : #'constructive solid geometry' }
WDMBSPBrush >> subtract: otherBrush withTransform: otherBrushTransform [
	| otherPlanes otherPlaneClassifications clippingPlanes result remaining |
	self validateTopology.
	(self hasIntersectionWithBrush: otherBrush withTransform: otherBrushTransform) ifFalse: [ 
		^ super subtract: otherBrush withTransform: otherBrushTransform
	].
	otherPlanes := otherBrush faces collect: [ :face | face plane transformedWith: otherBrushTransform ].
	otherPlanes ifEmpty: [ ^ { self } ].

	otherPlaneClassifications := otherPlanes collect: [ :eachPlane | eachPlane classifyVertices: vertices epsilon: Epsilon ].
	
	"Am I fully contained in the other polytope?"
	(otherPlaneClassifications allSatisfy: [:each | #(back inside) includes: each ]) ifTrue: [ ^ #() ].

	"Am I fully outside the other polytope?"
	(otherPlaneClassifications anySatisfy: [:each | #(front inside) includes: each ]) ifTrue: [ ^ { self } ].

	"We only clip against front and back planes."
	clippingPlanes := OrderedCollection new.
	otherPlaneClassifications doWithIndex: [ :classification :index |
		classification == #frontAndBack ifTrue: [ 
			clippingPlanes add: (otherPlanes at: index)
		].
	].

	self assert: clippingPlanes isNotEmpty.
	result := OrderedCollection new. 
	remaining := self.
	clippingPlanes do: [ :plane |
		| frontAndBack front back |
		frontAndBack := remaining clipAgainstPlane: plane.
		front := frontAndBack first.
		back := frontAndBack second.
		front ifNotNil: [
			result add: front
		].

		self assert: back isNotNil.
		remaining := back
	].
	
	^ result
]

{ #category : #'intersection testing' }
WDMBSPBrush >> supportFunction [
	^ GeometricFunctions transformSupportFunction: self localSupportFunction with: self globalTransform
]

{ #category : #'scene presentation' }
WDMBSPBrush >> updateScenePresentationHandle: aHandle [
	super updateScenePresentationHandle: aHandle.
	aHandle sceneNode renderables: { self validMeshWithAlternatives }
]

{ #category : #caching }
WDMBSPBrush >> validMeshWithAlternatives [
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
WDMBSPBrush >> validSolidMesh [
	| builder |
	solidMesh ifNotNil: [ ^ solidMesh ].
	self validateTopology.
	builder := WDMeshBuilder new.
	builder currentMaterial: self editionViewColorMaterial.
	faces do: [ :face |
		face buildSolidFaceMeshWith: builder
	].

	^ solidMesh := builder mesh
]

{ #category : #caching }
WDMBSPBrush >> validTexturedMesh [
	| builder |
	texturedMesh ifNotNil: [ ^ texturedMesh ].
	self validateTopology.
	builder := WDMeshBuilder new.
	faces do: [ :face |
		face buildTexturedFaceMeshWith: builder transform: self transform
	].

	^ texturedMesh := builder mesh
]

{ #category : #caching }
WDMBSPBrush >> validWireframeMesh [
	| builder |
	wireframeMesh ifNotNil: [ ^ wireframeMesh ].
	self validateTopology.
	builder := WDMeshBuilder new.
	builder currentMaterial: self editionViewColorMaterial.
	faces do: [ :face |
		face buildWireframeFaceMeshWith: builder
	].

	^ wireframeMesh := builder mesh
]

{ #category : #caching }
WDMBSPBrush >> validateTopology [
	| faceCount |
	hasValidTopology ifTrue: [ ^ self ].
	faceCount := faces size.
	vertices := OrderedCollection new.
	faces do: [ :f | f clearIndices ].
	
	1 to: faceCount do: [ :i |
		| f1 p1 |
		f1 := (faces at: i).
		p1 := f1 plane.
		i + 1 to: faceCount do: [ :j |
			| f2 p2 |
			f2 := (faces at: j).
			p2 := f2 plane.
			j + 1 to: faceCount do: [ :k |
				| f3 p3 |
				f3 := (faces at: k).
				p3 := f3 plane.
				(i ~= j and: [j ~= k]) ifTrue: [
					| m |
					m := Matrix3x3 rows: { p1 normal . p2 normal . p3 normal }.
					(m determinant closeTo: 0) ifFalse: [ 
						| v p vi |
						v := Vector3 x: p1 distance y: p2 distance z: p3 distance.
						p := m inverse * v.
						vi := vertices size.
						vertices add: p.
						f1 addIndex: vi.
						f2 addIndex: vi.
						f3 addIndex: vi.
					].
				]
			]
		]
	].

	localBoundingBox := AABox empty.
	vertices do: [ :v |
		localBoundingBox insertPoint: v
	].
	faces do: [ :f |
		f sortIndices.
	].
	hasValidTopology := true.
]

{ #category : #accessing }
WDMBSPBrush >> vertices [
	^ vertices
]
