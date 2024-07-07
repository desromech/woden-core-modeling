Extension { #name : 'WDMScalarProperty' }

{ #category : '*WodenModeling-Protocol-Spec' }
WDMScalarProperty >> buildSpecPresenter [
	^ SpNumberInputFieldPresenter new
		beFloat;
		minimum: minimum;
		maximum: maximum;
		number: self getValue;
		whenNumberChangedDo: [ :newNumber |
			self setValue: newNumber
		];
		yourself
]
