"
I am a combiner for different BSP CSG operations.
"
Class {
	#name : 'WDMBSPCombiner',
	#superclass : 'WDModelingGroup',
	#instVars : [
		'root'
	],
	#category : 'WodenModeling-BSPStyleCSG',
	#package : 'WodenModeling-BSPStyleCSG'
}

{ #category : 'instance creation' }
WDMBSPCombiner class >> with: root [
	^ self new root: root
]

{ #category : 'accessing' }
WDMBSPCombiner >> boundingBox [
	^ self localBoundingBox translatedBy: transform translation
]

{ #category : 'accessing' }
WDMBSPCombiner >> children [
	^ { self root }
]

{ #category : 'accessing' }
WDMBSPCombiner >> instantiateForPlacingIn: owner box: placementBox [
	| instance placementTransform placementTransformWithoutTranslation |
	instance := self copy setupForNewInstance.
	instance root setupForNewInstance.
	
	placementTransform := (placementBox trsTransformToConvertToMe: instance boundingBox).
	placementTransformWithoutTranslation := placementTransform copy translation: Vector3 zeros.
	instance root transform: placementTransformWithoutTranslation.
	instance transformWith: (TRSTransform3D translation: placementTransform translation).
	owner add: instance.
	^ instance
]

{ #category : 'accessing' }
WDMBSPCombiner >> localBoundingBox [ 
	^ root boundingBox
]

{ #category : 'accessing' }
WDMBSPCombiner >> objectTypeName [
	^ 'BSP Combiner'
]

{ #category : 'copying' }
WDMBSPCombiner >> postCopy [
	super postCopy.
	parent := nil.
	root := root copy
]

{ #category : 'accessing' }
WDMBSPCombiner >> root [

	^ root
]

{ #category : 'accessing' }
WDMBSPCombiner >> root: anObject [

	root := anObject
]
