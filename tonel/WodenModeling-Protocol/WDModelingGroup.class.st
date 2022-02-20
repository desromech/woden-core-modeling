"
I am a group of modeling scene objects.
"
Class {
	#name : #WDModelingGroup,
	#superclass : #WDModelingSceneObject,
	#traits : 'TWDMModelingElementWithChildren',
	#classTraits : 'TWDMModelingElementWithChildren classTrait',
	#instVars : [
		'lockedGroup'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingGroup class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : #'property pages' }
WDModelingGroup >> buildModelingElementMainPropertyPageWith: builder [
	super buildModelingElementMainPropertyPageWith: builder.
	builder
		booleanPropertyNamed: 'Locked Group' selector: #lockedGroup
]

{ #category : #'as yet unclassified' }
WDModelingGroup >> childrenChanged [
	self invalidateLocalBoundingBox.
	super childrenChanged.
]

{ #category : #serialization }
WDModelingGroup >> encodeJsonKeyValuesWithContext: serializationContext [
	^ (super encodeJsonKeyValuesWithContext: serializationContext) , {
		#lockedGroup . lockedGroup.
		#children . self children collect: [ :each | each encodeForJSONWithContext: serializationContext ]
	}
]

{ #category : #initialization }
WDModelingGroup >> initialize [
	super initialize.
	lockedGroup := false.
	
]

{ #category : #'as yet unclassified' }
WDModelingGroup >> invalidateLocalBoundingBox [
	localBoundingBox := nil.
]

{ #category : #testing }
WDModelingGroup >> isGroup [
	^ true
]

{ #category : #serialization }
WDModelingGroup >> loadFromJson: jsonData withContext: deserializationContext [
	super loadFromJson: jsonData withContext: deserializationContext.
	lockedGroup := (jsonData at: #lockedGroup ifAbsent: [ nil ]) ifNil: [ lockedGroup ].
	(jsonData at: #children ifAbsent: [ nil ]) ifNotNil: [ :childrenData |
		childrenData do: [ :childData |
			self add: (deserializationContext materializeObject: childData)
		]
	].
]

{ #category : #'as yet unclassified' }
WDModelingGroup >> localBoundingBox [
	localBoundingBox ifNil: [ 
		localBoundingBox := AABox empty.
		self children do: [ :each |
			localBoundingBox insertBox: each boundingBox
		]
	].
	^ localBoundingBox
]

{ #category : #accessing }
WDModelingGroup >> lockedGroup [

	^ lockedGroup
]

{ #category : #accessing }
WDModelingGroup >> lockedGroup: anObject [

	lockedGroup := anObject
]

{ #category : #accessing }
WDModelingGroup >> objectTypeName [
	^ 'Group'
]

{ #category : #selection }
WDModelingGroup >> rayPickElements: picker [
	self isSceneSelectableObject ifTrue: [
		self children isEmpty ifTrue: [
			^ super rayPickElements: picker
		].

		self lockedGroup ifTrue: [
			| firstChildRayPicker |
			firstChildRayPicker := WDMFirstRayPicker ray: picker ray.
			firstChildRayPicker withTransform: self transform do: [
				children do: [ :each | each rayPickElements: firstChildRayPicker ]
			].

			firstChildRayPicker result ifNotNil: [
				picker addResult: self withDistance: firstChildRayPicker resultDistance
			].
			^ self
		].
	].

	picker withTransform: self transform do: [ 
		children do: [ :each | each rayPickElements: picker ]
	].
]
