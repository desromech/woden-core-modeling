Extension { #name : 'WDMaterial' }

{ #category : '*WodenModeling-Protocol' }
WDMaterial >> asWDModelingMaterialInfo [
	^ WDModelingMaterialInfo new definition: self
]

{ #category : '*WodenModeling-Protocol' }
WDMaterial >> withHighlightedStatus: highlightedStatus selectedStatus: selectedStatus [
	^ self
]
