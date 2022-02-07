"
A WDModelingTreeTest is a test class for testing the behavior of WDModelingTree
"
Class {
	#name : #WDModelingTreeTest,
	#superclass : #TestCase,
	#category : #'WodenModeling-Protocol-Tests-Model'
}

{ #category : #tests }
WDModelingTreeTest >> testAddLayer [
	| tree firstLayer secondLayer |
	tree := WDModelingTree new.
	firstLayer := WDModelingLayer named: 'First Layer'.
	secondLayer := WDModelingLayer named: 'Second Layer'.
	tree add: firstLayer.
	self assert: tree children size equals: 1.
	self assert: (tree children includes: firstLayer).
	
	tree add: secondLayer.
	self assert: tree children size equals: 2.
	self assert: (tree children includes: secondLayer).
]

{ #category : #tests }
WDModelingTreeTest >> testNew [
	| tree |
	tree := WDModelingTree new.
	self assert: tree children isEmpty.
]
