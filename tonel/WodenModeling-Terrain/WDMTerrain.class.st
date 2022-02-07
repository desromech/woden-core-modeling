Class {
	#name : #WDMTerrain,
	#superclass : #WDModelingSceneObject,
	#instVars : [
		'patchSize',
		'patches',
		'columns',
		'rows'
	],
	#category : #'WodenModeling-Terrain'
}

{ #category : #initialization }
WDMTerrain class >> patchSize: patchSize gridExtent: gridExtent [
	^ self new patchSize: patchSize gridExtent: gridExtent; yourself
]

{ #category : #accessing }
WDMTerrain >> children [
	^ patches
]

{ #category : #accessing }
WDMTerrain >> columns [
	^ columns
]

{ #category : #'as yet unclassified' }
WDMTerrain >> generateLocalHeightWith: aBlock [
	patches do: [ :each | each generateLocalHeightWith: aBlock ]
]

{ #category : #initialization }
WDMTerrain >> initialize [
	super initialize.
	patches := #().
	self patchSize: 32 gridExtent: 1@1
]

{ #category : #initialization }
WDMTerrain >> initializeScenePresentationHandle: aPresentationHandle [
	self addChildrenOntoScenePresentationHandle: aPresentationHandle

]

{ #category : #'as yet unclassified' }
WDMTerrain >> invalidateLocalBoundingBox [
	localBoundingBox := nil.
]

{ #category : #accessing }
WDMTerrain >> localBoundingBox [
	localBoundingBox ifNil: [ 
		localBoundingBox := AABox empty.
		patches do: [ :each |
			localBoundingBox insertBox: each boundingBox
		]
	].
	^ localBoundingBox
]

{ #category : #selection }
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

{ #category : #accessing }
WDMTerrain >> objectTypeName [
	^ 'Terrain'
]

{ #category : #initialization }
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

{ #category : #accessing }
WDMTerrain >> patches [

	^ patches
]

{ #category : #accessing }
WDMTerrain >> postCopy [
	| oldPatches |
	super postCopy.
	oldPatches := patches.
	patches := #().
	self privateSetPatches: (oldPatches collect: [ :each | each copy ]).
]

{ #category : #accessing }
WDMTerrain >> privateSetPatches: newPatches [
	patches do: [ :each | each removedFromModelTree ].

	patches := newPatches.

	patches do: [ :each | each parent: self ].
	self addChildrenOntoScenePresentations.
]

{ #category : #selection }
WDMTerrain >> rayPickElements: picker [
	picker withTransform: transform do: [
		self localRayPick: picker
	]
]

{ #category : #accessing }
WDMTerrain >> rows [
	^ rows
]
