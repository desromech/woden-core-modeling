"
I am terrain composed by a grid of equally sized height field patches.
"
Class {
	#name : 'WDMTerrain',
	#superclass : 'WDModelingSceneObject',
	#instVars : [
		'patchSize',
		'patches',
		'columns',
		'rows'
	],
	#category : 'WodenModeling-Terrain',
	#package : 'WodenModeling-Terrain'
}

{ #category : 'serialization' }
WDMTerrain class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDM'
]

{ #category : 'initialization' }
WDMTerrain class >> patchSize: patchSize gridExtent: gridExtent [
	^ self new patchSize: patchSize gridExtent: gridExtent; yourself
]

{ #category : 'testing' }
WDMTerrain >> canBeDuplicatedAndPlaced [
	^ true
]

{ #category : 'accessing' }
WDMTerrain >> children [
	^ patches
]

{ #category : 'as yet unclassified' }
WDMTerrain >> collectElementsWithTextureMappingSettingsOnto: result [
	result addAll: self patches
]

{ #category : 'accessing' }
WDMTerrain >> columns [
	^ columns
]

{ #category : 'topology edition mode' }
WDMTerrain >> commitSculptingChanges [
	patches do: [ :each | each commitSculptingChanges ].
	localBoundingBox := nil.
]

{ #category : 'serialization' }
WDMTerrain >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#patchSize . patchSize.
		#rows . rows.
		#columns . columns.
		#patches . patches collect: [:each | each encodeForJSONWithContext: serializationContext ] as: Array
	}
]

{ #category : 'as yet unclassified' }
WDMTerrain >> exportToGltfWith: gltfBuilder [
	| terrainNode |
	terrainNode := gltfBuilder newNode: self name.
	terrainNode transform: transform.
	terrainNode children: (patches collect: [ :eachPatch |
		eachPatch exportToGltfWith: gltfBuilder
	]).
	^ terrainNode
]

{ #category : 'as yet unclassified' }
WDMTerrain >> generateLocalHeightWith: aBlock [
	patches do: [ :each | each generateLocalHeightWith: aBlock ]
]

{ #category : 'initialization' }
WDMTerrain >> initialize [
	super initialize.
	patches := #().
	self patchSize: 32 gridExtent: 1@1
]

{ #category : 'initialization' }
WDMTerrain >> initializeScenePresentationHandle: aPresentationHandle [
	self addChildrenOntoScenePresentationHandle: aPresentationHandle

]

{ #category : 'as yet unclassified' }
WDMTerrain >> invalidateLocalBoundingBox [
	localBoundingBox := nil.
]

{ #category : 'testing' }
WDMTerrain >> isSceneSelectableObject [
	^ true
]

{ #category : 'serialization' }
WDMTerrain >> loadFromJson: jsonData withContext: deserializationContext [
	super loadFromJson: jsonData withContext: deserializationContext.
	patchSize := (jsonData at: #patchSize ifAbsent: [ nil ]) ifNil: [ patchSize ].
	rows := (jsonData at: #rows ifAbsent: [ nil ]) ifNil: [ rows ].
	columns := (jsonData at: #columns ifAbsent: [ nil ]) ifNil: [ columns ].
	patches := ((jsonData at: #patches ifAbsent: [ nil ]) ifNil: [ #() ]) collectWithIndex: [ :each :index |
		WDMTerrainPatch new
			patchSize: patchSize;
			row: (index - 1) // columns;
			column: (index - 1) % columns;
			loadFromJson: each withContext: deserializationContext;
			parent: self;
			yourself
	].
	localBoundingBox := nil.
]

{ #category : 'accessing' }
WDMTerrain >> localBoundingBox [
	localBoundingBox ifNil: [ 
		localBoundingBox := AABox empty.
		patches do: [ :each |
			localBoundingBox insertBox: each boundingBox
		]
	].
	^ localBoundingBox
]

{ #category : 'selection' }
WDMTerrain >> localRayPick: picker [
	| bestDistance localRay |
	bestDistance := nil.
	localRay := picker ray.
	patches do: [ :each |
		| intersectionDistance |
		intersectionDistance := each rayCast: localRay.
		intersectionDistance ifNotNil: [ 
			(bestDistance isNil or: [intersectionDistance < bestDistance]) ifTrue: [ 
				bestDistance := intersectionDistance
			]
		]
	].

	bestDistance ifNil: [ ^ nil ].

	picker addResult: self withDistance: bestDistance
]

{ #category : 'accessing' }
WDMTerrain >> objectTypeName [
	^ 'Terrain'
]

{ #category : 'initialization' }
WDMTerrain >> patchSize: newPatchSize gridExtent: gridExtent [
	| newPatches |
	patchSize := newPatchSize.
	columns := gridExtent x.
	rows := gridExtent y.
	newPatches := OrderedCollection new.
	0 to: columns - 1 do: [ :y |
		0 to: rows - 1 do: [ :x |
			newPatches add: (WDMTerrainPatch new
				row: y;
				column: x;
				patchSize: patchSize;
				yourself)
		]
	].
	self privateSetPatches: newPatches
]

{ #category : 'accessing' }
WDMTerrain >> patches [

	^ patches
]

{ #category : 'accessing' }
WDMTerrain >> postCopy [
	| oldPatches |
	super postCopy.
	oldPatches := patches.
	patches := #().
	self privateSetPatches: (oldPatches collect: [ :each | each copy ]).
]

{ #category : 'serialization' }
WDMTerrain >> prepareForSerializationWithContext: serializationContext [
	super prepareForSerializationWithContext: serializationContext.
	patches do: [ :each | each prepareForSerializationWithContext: serializationContext ]
]

{ #category : 'accessing' }
WDMTerrain >> privateSetPatches: newPatches [
	patches do: [ :each | each removedFromModelTree ].

	patches := newPatches.

	patches do: [ :each | each parent: self ].
	self addChildrenOntoScenePresentations.
]

{ #category : 'selection' }
WDMTerrain >> rayPickElements: picker [
	self visible ifFalse: [ ^ self ].
	
	picker editionMode isObjectEditionMode ifFalse: [ ^ self ].
	picker withTransform: transform do: [
		self localRayPick: picker
	]
]

{ #category : 'accessing' }
WDMTerrain >> rows [
	^ rows
]

{ #category : 'topology edition mode' }
WDMTerrain >> sculptWithLocalRay: ray drawIntensity: drawIntensity drawRadius: drawRadius [
	patches do: [ :each |
		each sculptWithLocalRay: ray drawIntensity: drawIntensity drawRadius: drawRadius
	]
]

{ #category : 'initialization' }
WDMTerrain >> setMaterialInfoRecursively: newMaterial [
	self patches do: [ :each | each setMaterialInfoRecursively: newMaterial ].
]

{ #category : 'as yet unclassified' }
WDMTerrain >> supportsModelingEditionMode: aMode [
	aMode asModelingEditionMode isSculptEditionMode ifTrue: [ ^ true ].
	^ super supportsModelingEditionMode: aMode
]
