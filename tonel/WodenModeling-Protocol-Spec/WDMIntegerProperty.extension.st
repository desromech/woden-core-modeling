Extension { #name : #WDMIntegerProperty }

{ #category : #'*WodenModeling-Protocol-Spec' }
WDMIntegerProperty >> buildSpecPresenter [
	^ SpNumberInputFieldPresenter new
		beInteger;
		minimum: minimum;
		maximum: maximum;
		number: self getValue;
		whenNumberChangedDo: [ :newNumber |
			self setValue: newNumber
		];
		yourself
]
