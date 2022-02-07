Trait {
	#name : #TWDMModelingElementWithEditionViewColor,
	#instVars : [
		'editionViewColor',
		'editionViewColorMaterial'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
TWDMModelingElementWithEditionViewColor >> editionViewColor [
	^ editionViewColor ifNil: [ editionViewColor := Color white ]
]

{ #category : #accessing }
TWDMModelingElementWithEditionViewColor >> editionViewColor: aColor [
	editionViewColor := aColor.
	editionViewColorMaterial := nil.
]

{ #category : #accessing }
TWDMModelingElementWithEditionViewColor >> editionViewColorMaterial [
	^ editionViewColorMaterial ifNil: [
		editionViewColorMaterial := WDMetallicRoughnessMaterial default copy
			baseColorFactor: self editionViewColor;
			yourself
	]
]

{ #category : #'as yet unclassified' }
TWDMModelingElementWithEditionViewColor >> generateEditionViewColor [
	self editionViewColor: WDModelingElement generateEditionViewColor
]
