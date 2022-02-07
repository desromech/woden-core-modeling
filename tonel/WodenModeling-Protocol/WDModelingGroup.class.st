"
I am a group of modeling scene objects.
"
Class {
	#name : #WDModelingGroup,
	#superclass : #WDModelingSceneObject,
	#traits : 'TWDMModelingElementWithChildren',
	#classTraits : 'TWDMModelingElementWithChildren classTrait',
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
WDModelingGroup >> objectTypeName [
	^ 'Group'
]
