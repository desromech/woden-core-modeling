Extension { #name : 'WDMVector2Property' }

{ #category : '*WodenModeling-Protocol-Spec' }
WDMVector2Property >> buildSpecPresenter [
	^ SpBoxLayout newHorizontal
		add: (	SpNumberInputFieldPresenter new
			beFloat;
			number: self getValue x;
			whenNumberChangedDo: [ :newNumber |
				self setValue: (self getValue copy x: newNumber; yourself)
			];
			yourself
		);
		add: (	SpNumberInputFieldPresenter new
			beFloat;
			number: self getValue y;
			whenNumberChangedDo: [ :newNumber |
				self setValue: (self getValue copy y: newNumber; yourself)
			];
			yourself
		);
		yourself

]
