Extension { #name : #WDMBooleanProperty }

{ #category : #'*WodenModeling-Protocol-Spec' }
WDMBooleanProperty >> buildSpecPresenter [
	^ SpCheckBoxPresenter new
		state: self getValue;
		whenChangedDo: [ :newState | self setValue: newState ];
		yourself
]
