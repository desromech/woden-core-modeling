"
I am a modeling layer.
"
Class {
	#name : 'WDModelingLayer',
	#superclass : 'WDModelingElement',
	#traits : 'TWDMModelingElementWithChildren',
	#classTraits : 'TWDMModelingElementWithChildren classTrait',
	#category : 'WodenModeling-Protocol-Model',
	#package : 'WodenModeling-Protocol',
	#tag : 'Model'
}

{ #category : 'accessing' }
WDModelingLayer >> objectTypeName [
	^ 'Layer'
]
