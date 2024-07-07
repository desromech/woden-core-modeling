Trait {
	#name : 'TWDMJsonSerializableModelingElement',
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'serialization' }
TWDMJsonSerializableModelingElement classSide >> jsonObjectTypeName [
	^ self name
]

{ #category : 'serialization' }
TWDMJsonSerializableModelingElement >> encodeForJSONWithContext: serializationContext [
	^ OrderedDictionary newFromPairs: (self encodeJsonKeyValuesWithContext: serializationContext)
]

{ #category : 'serialization' }
TWDMJsonSerializableModelingElement >> encodeJsonKeyValuesWithContext: serializationContext [
	^ {
		#__type__ . self jsonObjectTypeName
	}
]

{ #category : 'serialization' }
TWDMJsonSerializableModelingElement >> jsonObjectTypeName [
	^ self class jsonObjectTypeName
]

{ #category : 'serialization' }
TWDMJsonSerializableModelingElement >> loadFromJson: jsonData withContext: deserializationContext [
	
]

{ #category : 'serialization' }
TWDMJsonSerializableModelingElement >> prepareForSerializationWithContext: serializationContext [
]
