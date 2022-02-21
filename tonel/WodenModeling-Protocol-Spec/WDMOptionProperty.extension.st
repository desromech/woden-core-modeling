Extension { #name : #WDMOptionProperty }

{ #category : #'*WodenModeling-Protocol-Spec' }
WDMOptionProperty >> buildSpecPresenter [
	^ SpDropListPresenter new
		items: options;
		selectIndex: (options indexOf: (self getValue ));
		whenSelectedItemChangedDo: [ :selectedItem | self setValue: selectedItem ];
		yourself
]
