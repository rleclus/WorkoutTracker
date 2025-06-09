//
//  WorkoutManager.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/04.
//
import SwiftUI

public class WorkoutManager: @unchecked Sendable  {
	public static let shared = WorkoutManager()
	private let healthkitWorker: HealthKitProtocol
	private init() {
		// Created a check here because the HealthKitWorker is called on app startup and should not be called when running unit tests. 
		let isRunningTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
		if isRunningTests {
			healthkitWorker = MockHealthKitWorker()
		} else {
			healthkitWorker = HealthKitWorker()
		}
	}
	public func authoriseHealthKit() async throws {
		try await self.healthkitWorker.requestAuthorisation()
	}
	
	public func startWorkout() async {
		await healthkitWorker.startWorkout()
	}
	public func stopWorkout() async -> Workout {
		return await healthkitWorker.stopWorkout()
	}
}
