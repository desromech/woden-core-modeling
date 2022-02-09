Extension { #name : #WDUnlitMaterial }

{ #category : #'*WodenModeling-Protocol' }
WDUnlitMaterial >> withHighlightedStatus: highlightedStatus selectedStatus: selectedStatus [
	selectedStatus ifTrue: [
		^ self copy
			colorFactor: colorFactor * 0.6 + (Vector3 x: 0.4 y: 0.4 z: 0.2);
			yourself
	].

	highlightedStatus ifTrue: [
		^ self copy
			colorFactor: colorFactor * 0.6 + (Vector3 x: 0.2 y: 0.2 z: 0.2);
			yourself
	].

	^ self
]
