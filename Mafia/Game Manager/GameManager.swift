//
//  GameManager.swift
//  Mafia
//
//  Created by Alex Studnička on 17/01/2018.
//  Copyright © 2018 Alex Studnicka. All rights reserved.
//

import Foundation
import SceneKit

#if os(macOS)
    let mainDirectory = URL(fileURLWithPath: "/Users/Alex/Development/Mafia/Mafia")
#elseif os(iOS)
	let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let mainDirectory = documentDirectory.appendingPathComponent("Mafia")
#endif

class GameManager {

	let view: SCNView

	var mainMenu: MainMenu?
	var game: Game!

	init(view: SCNView) {
		self.view = view

		// swiftlint:disable:next force_try
		try! TextDb.load()

		view.rendersContinuously = true
		view.backgroundColor = .black
		view.showsStatistics = true
//		view.debugOptions = [.showPhysicsShapes]
		view.antialiasingMode = .none
		view.allowsCameraControl = false
		view.autoenablesDefaultLighting = false
// 		view.preferredFramesPerSecond = 10
		loadMission(textId: 4084, imageName: "tutorial.tga", folder: "tutorial")
//		loadMission(textId: 4085, imageName: "freeride.tga", folder: "freeitaly")
//		loadMenu()
		view.play(nil)
	}

	func loadMenu() {
		view.scene = SCNScene()
		view.overlaySKScene = LoadingScene(textId: 0, imageName: "00menu.tga")
		DispatchQueue.global().async {
			// swiftlint:disable:next force_try
			self.mainMenu = try! MainMenu()
			self.mainMenu?.setup(in: self.view)
		}
	}

	func loadMission(textId: Int, imageName: String, folder: String) {
		view.scene = SCNScene()
		view.overlaySKScene = LoadingScene(textId: textId, imageName: imageName)
		DispatchQueue.global().async {
			// swiftlint:disable:next force_try
			self.game = try! Game(missionName: folder)
			self.game.setup(in: self.view)
		}
	}

}
