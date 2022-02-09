Extension { #name : #WDMetallicRoughnessMaterial }

{ #category : #'*WodenModeling-Protocol' }
WDMetallicRoughnessMaterial >> withHighlightedStatus: highlightedStatus selectedStatus: selectedStatus [
	selectedStatus ifTrue: [
		^ self copy
			baseColorFactor: baseColorFactor * 0.6;
			emissiveFactor: emissiveFactor * 0.6 + (Vector3 x: 0.2 y: 0.2 z: 0.05);
			yourself
	].

	highlightedStatus ifTrue: [
		^ self copy
			baseColorFactor: baseColorFactor * 0.6;
			emissiveFactor: emissiveFactor * 0.6 + (Vector3 x: 0.1 y: 0.1 z: 0.1);
			yourself
	].

	^ self
]
