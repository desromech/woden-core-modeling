"
I am a null scene object.
"
Class {
	#name : #WDModelingNullObject,
	#superclass : #WDModelingSceneObject,
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #serialization }
WDModelingNullObject class >> jsonObjectTypeName [
	^ self name withoutPrefix: 'WDModeling'
]

{ #category : #accessing }
WDModelingNullObject >> objectTypeName [
	^ 'Null'
]
