Class {
	#name : #BaselineOfWodenCoreModeling,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenCoreModeling
}

{ #category : #baselines }
BaselineOfWodenCoreModeling >> baseline: spec [
    <baseline>
	spec for: #'common' do: [
		spec
			baseline: #'WodenSceneGraph' with: [ spec repository: 'github://ronsaldo/woden-core-scene-graph' ];
			package: #'WodenModeling-Protocol' with: [
				spec requires: #( #'WodenSceneGraph').
			];
			package: #'WodenModeling-Protocol-Tests' with: [
				spec requires: #( #'WodenModeling-Protocol').
			];
			package: #'WodenModeling-Mesh' with: [
				spec requires: #( #'WodenModeling-Protocol').
			];
			package: #'WodenModeling-Mesh-Tests' with: [
				spec requires: #( #'WodenModeling-Protocol' #'WodenModeling-Mesh').
			];
			package: #'WodenModeling-BSPStyleCSG' with: [
				spec requires: #( #'WodenModeling-Protocol' #'WodenModeling-BSPStyleCSG').
			];
			package: #'WodenModeling-BSPStyleCSG-Tests' with: [
				spec requires: #( #'WodenModeling-Protocol').
			];
			package: #'WodenModeling-Terrain' with: [
				spec requires: #( #'WodenModeling-Protocol').
			];
			package: #'WodenModeling-Terrain-Tests' with: [
				spec requires: #( #'WodenModeling-Protocol' #'WodenModeling-Terrain').
			]
	].

]
