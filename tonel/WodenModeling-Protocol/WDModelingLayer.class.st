"
I am a modeling layer.
"
Class {
	#name : #WDModelingLayer,
	#superclass : #Object,
	#traits : 'TWDMModelingElement',
	#classTraits : 'TWDMModelingElement classTrait',
	#instVars : [
		'name',
		'children'
	],
	#category : #'WodenModeling-Protocol-Model'
}

{ #category : #'instance creation' }
WDModelingLayer class >> named: aName [
	^ self new name: aName; yourself
]

{ #category : #'add/remove' }
WDModelingLayer >> add: aChild [
	children add: aChild
]

{ #category : #testing }
WDModelingLayer >> canAddOrRemoveChildren [
	^ true
]

{ #category : #accessing }
WDModelingLayer >> children [
	^ children
]

{ #category : #initialization }
WDModelingLayer >> initialize [
	super initialize.
	name := ''.
	children := OrderedCollection new.
]

{ #category : #accessing }
WDModelingLayer >> name [
	^ name
]

{ #category : #accessing }
WDModelingLayer >> name: aString [
	name := aString
]

{ #category : #accessing }
WDModelingLayer >> objectTypeName [
	^ 'Layer'
]

{ #category : #'add/remove' }
WDModelingLayer >> remove: aChild [
	children remove: aChild
]
