Trait {
	#name : 'TWDMModelingElementWithEditionViewColor',
	#instVars : [
		'editionViewColor',
		'editionViewColorMaterial'
	],
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'accessing' }
TWDMModelingElementWithEditionViewColor >> editionViewColor [
	^ editionViewColor ifNil: [ editionViewColor := Color white ]
]

{ #category : 'accessing' }
TWDMModelingElementWithEditionViewColor >> editionViewColor: aColor [
	editionViewColor := aColor.
	editionViewColorMaterial := nil.
]

{ #category : 'accessing' }
TWDMModelingElementWithEditionViewColor >> editionViewColorMaterial [
	^ editionViewColorMaterial ifNil: [
		editionViewColorMaterial := WDMetallicRoughnessMaterial default copy
			baseColorFactor: self editionViewColor;
			yourself
	]
]

{ #category : 'serialization' }
TWDMModelingElementWithEditionViewColor >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#editionViewColor . self editionViewColor asVector4 encodeForJSON
	}
]

{ #category : 'as yet unclassified' }
TWDMModelingElementWithEditionViewColor >> generateEditionViewColor [
	self editionViewColor: WDModelingElement generateEditionViewColor
]

{ #category : 'serialization' }
TWDMModelingElementWithEditionViewColor >> loadFromJson: jsonData withContext: deserializationContext [
	super loadFromJson: jsonData withContext: deserializationContext.
	(jsonData at: #editionViewColor ifAbsent: [ nil ]) ifNotNil: [ :c |
		self editionViewColor: (Vector4 loadFromJson: c) asColor
	]
]
