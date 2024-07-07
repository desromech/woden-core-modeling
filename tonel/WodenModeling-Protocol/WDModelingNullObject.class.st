"
I am a null scene object.
"
Class {
	#name : 'WDModelingNullObject',
	#superclass : 'WDModelingSceneObject',
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'serialization' }
WDModelingNullObject class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : 'testing' }
WDModelingNullObject >> isPointModelingElement [
	^ true
]

{ #category : 'testing' }
WDModelingNullObject >> isPointPlacedElement [
	^ true
]

{ #category : 'accessing' }
WDModelingNullObject >> objectTypeName [
	^ 'Null'
]
