//
//  WorkoutManager.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/04.
//
import SwiftUI

public class WorkoutManager: @unchecked Sendable  {
	public static let shared = WorkoutManager()
	private let healthkitWorker = HealthKitWorker()
	private init() {
		
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
