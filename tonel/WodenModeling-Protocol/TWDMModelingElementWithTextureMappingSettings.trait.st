Trait {
	#name : 'TWDMModelingElementWithTextureMappingSettings',
	#instVars : [
		'textureOffset',
		'textureScale',
		'textureRotation'
	],
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
TWDMModelingElementWithTextureMappingSettings >> collectElementsWithTextureMappingSettingsOnto: result [
	result add: self
]

{ #category : 'initialization' }
TWDMModelingElementWithTextureMappingSettings >> computeTextureMatrix [
	^ Matrix3x3 texScale: self textureScale rotation: self textureRotation offset: self textureOffset
]

{ #category : 'hooks' }
TWDMModelingElementWithTextureMappingSettings >> textureMappingChanged [
]

{ #category : 'accessing' }
TWDMModelingElementWithTextureMappingSettings >> textureOffset [

	^ textureOffset ifNil: [ textureOffset := Vector2 zeros ]
]

{ #category : 'accessing' }
TWDMModelingElementWithTextureMappingSettings >> textureOffset: newOffset [
	| changed |
	changed := textureOffset ~= newOffset.
	textureOffset := newOffset.
	changed ifTrue: [ self textureMappingChanged ]
]

{ #category : 'accessing' }
TWDMModelingElementWithTextureMappingSettings >> textureRotation [

	^ textureRotation ifNil: [ textureRotation := 0 ]
]

{ #category : 'accessing' }
TWDMModelingElementWithTextureMappingSettings >> textureRotation: newRotation [
	| changed |
	changed := textureRotation ~= newRotation.
	textureRotation := newRotation.
	changed ifTrue: [ self textureMappingChanged ]
]

{ #category : 'accessing' }
TWDMModelingElementWithTextureMappingSettings >> textureScale [

	^ textureScale ifNil: [ textureScale := Vector2 ones ]
]

{ #category : 'accessing' }
TWDMModelingElementWithTextureMappingSettings >> textureScale: newScale [
	| changed |
	changed := textureScale ~= newScale.
	textureScale := newScale.
	changed ifTrue: [ self textureMappingChanged ]
]
