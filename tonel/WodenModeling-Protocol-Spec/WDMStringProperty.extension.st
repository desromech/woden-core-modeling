Extension { #name : #WDMStringProperty }

{ #category : #'*WodenModeling-Protocol-Spec' }
WDMStringProperty >> buildSpecPresenter [
	^ SpTextInputFieldPresenter new
		text: self getFormattedValue;
		whenTextChangedDo: [ :newText |
			self parseTextAndSetValue: newText asString
		];
		yourself
]
