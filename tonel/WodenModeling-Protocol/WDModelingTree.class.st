"
I am a modeling tree where all of its elements respect the Woden modeling protocol.
"
Class {
	#name : #WDModelingTree,
	#superclass : #WDModelingElement,
	#traits : 'TWDMModelingElementWithChildren',
	#classTraits : 'TWDMModelingElementWithChildren classTrait',
	#instVars : [
		'treeTopologyChangeListeners'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #accessing }
WDModelingTree >> objectTypeName [
	^ 'Modeling Tree'
]

{ #category : #accessing }
WDModelingTree >> treeTopologyChangeListeners [
	^ treeTopologyChangeListeners := Set new
]

{ #category : #enumerating }
WDModelingTree >> treeTopologyChanged [
	self treeTopologyChangeListeners do: [ :each | each value ]
]

{ #category : #enumerating }
WDModelingTree >> whenAddedOrRemovedElementDo: aBlock [
	self treeTopologyChangeListeners add: aBlock
]
