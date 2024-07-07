Extension { #name : 'WDMVector4Property' }

{ #category : '*WodenModeling-Protocol-Spec' }
WDMVector4Property >> buildSpecPresenter [
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
		add: (	SpNumberInputFieldPresenter new
			beFloat;
			number: self getValue z;
			whenNumberChangedDo: [ :newNumber |
				self setValue: (self getValue copy z: newNumber; yourself)
			];
			yourself
		);
		add: (	SpNumberInputFieldPresenter new
			beFloat;
			number: self getValue w;
			whenNumberChangedDo: [ :newNumber |
				self setValue: (self getValue copy w: newNumber; yourself)
			];
			yourself
		);
		yourself

]
