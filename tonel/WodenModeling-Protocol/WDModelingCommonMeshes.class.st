"
I hold a set of meshes that are commonly used by the modeling tools.
"
Class {
	#name : #WDModelingCommonMeshes,
	#superclass : #Object,
	#instVars : [
		'lightSourceWithoutDirectionMesh',
		'lightSourceMaterial',
		'lightSourceWithDirectionMesh',
		'pointObjectBoundingBox',
		'pointObjectDisplayBox',
		'greenPointObjectDisplayMaterial'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
WDModelingCommonMeshes class >> reset [
	<script>
	uniqueInstance := nil.
]

{ #category : #accessing }
WDModelingCommonMeshes class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
WDModelingCommonMeshes >> greenPointObjectDisplayMaterial [
	^ greenPointObjectDisplayMaterial ifNil: [ greenPointObjectDisplayMaterial := WDUnlitMaterial new
		colorFactor: (Vector4 x: 0.3 y: 0.8 z: 0.3 w: 1.0);
		yourself
	]
]

{ #category : #accessing }
WDModelingCommonMeshes >> lightSourceDisplayRadius [
	^ 0.1
]

{ #category : #accessing }
WDModelingCommonMeshes >> lightSourceMaterial [
	^ lightSourceMaterial ifNil: [ lightSourceMaterial := WDUnlitMaterial new doubleSided: true]
]

{ #category : #accessing }
WDModelingCommonMeshes >> lightSourceWithDirection [
	^ lightSourceWithDirectionMesh ifNil: [ lightSourceWithDirectionMesh := WDMeshBuilder new
		currentMaterial: self lightSourceMaterial;
		 addConeWithRadius: self lightSourceDisplayRadius halfDepth: self lightSourceDisplayRadius segments: 16;
		mesh
	].
	
]

{ #category : #accessing }
WDModelingCommonMeshes >> lightSourceWithoutDirection [
	^ lightSourceWithoutDirectionMesh ifNil: [ lightSourceWithoutDirectionMesh := WDMeshBuilder new
		currentMaterial: self lightSourceMaterial;
		addUVSphereWithRadius: self lightSourceDisplayRadius segments: 16 slices: 16;
		mesh
	].
	
]

{ #category : #accessing }
WDModelingCommonMeshes >> pointObjectBoundingBox [
	^ pointObjectBoundingBox ifNil: [ pointObjectBoundingBox := AABox halfExtent: self pointObjectDisplayRadius asVector3 ]
]

{ #category : #accessing }
WDModelingCommonMeshes >> pointObjectDisplayBox [
	^ pointObjectDisplayBox ifNil: [ pointObjectDisplayBox := WDMeshBuilder new
		addCubeWithWidth: self pointObjectDisplayRadius*2 height: self pointObjectDisplayRadius*2 depth: self pointObjectDisplayRadius*2;
		mesh
	].
	
]

{ #category : #accessing }
WDModelingCommonMeshes >> pointObjectDisplayRadius [
	^ 0.1
]
