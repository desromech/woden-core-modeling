Extension { #name : 'WDMQuaternionProperty' }

{ #category : '*WodenModeling-Protocol-Spec' }
WDMQuaternionProperty >> buildEulerSpecPresenter [
	| euler |
	euler := self getValue asEulerZYX.
	
	^ SpBoxLayout newHorizontal
		add: (	SpNumberInputFieldPresenter new
			beFloat;
			number: euler x radiansToDegrees;
			whenNumberChangedDo: [ :newNumber |
				self setValue: (self getValue asEulerZYX x: newNumber degreesToRadians; asQuaternion)
			];
			yourself
		);
		add: (	SpNumberInputFieldPresenter new
			beFloat;
			number: euler y radiansToDegrees;
			whenNumberChangedDo: [ :newNumber |
				self setValue: (self getValue asEulerZYX y: newNumber degreesToRadians; asQuaternion)
			];
			yourself
		);
		add: (	SpNumberInputFieldPresenter new
			beFloat;
			number: euler z radiansToDegrees;
			whenNumberChangedDo: [ :newNumber |
				self setValue: (self getValue asEulerZYX z: newNumber degreesToRadians; asQuaternion)
			];
			yourself
		);
		yourself
]

{ #category : '*WodenModeling-Protocol-Spec' }
WDMQuaternionProperty >> buildQuaternionSpecPresenter [
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
				self setValue: (self getValue copy w: newNumber; yourself) normalized
			];
			yourself
		);
		yourself
]

{ #category : '*WodenModeling-Protocol-Spec' }
WDMQuaternionProperty >> buildSpecPresenter [
	^ SpBoxLayout newVertical
		add: self buildQuaternionSpecPresenter;
		add: self buildEulerSpecPresenter;
		yourself

]
