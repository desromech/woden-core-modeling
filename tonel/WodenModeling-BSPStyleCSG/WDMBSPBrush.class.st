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

{ #category : #accessing }
WDMBSPBrush class >> unitBox [
	^ self forBox: AABox unit
]

{ #category : #'as yet unclassified' }
WDMBSPBrush class >> withFaces: aCollectionOfFaces [
	^ self new faces: aCollectionOfFaces; yourself
]

{ #category : #accessing }
WDMBSPBrush >> children [
	^ faces
]

{ #category : #accessing }
WDMBSPBrush >> faces: aListOfFaces [
	faces := aListOfFaces.
	faces do: [ :each | each parent: self ].
	self invalidateTopology
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

{ #category : #accessing }
WDMBSPBrush >> localBoundingBox [
	self validateTopology.
	^ localBoundingBox
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
WDMBSPBrush >> rayPickElements: picker [
	picker withTransform: transform do: [
		self localRayPick: picker
	]
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
