//
//  MockHealthKitWorker.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/09.
//
import Foundation

class MockHealthKitWorker: HealthKitProtocol {
	func requestAuthorisation() async throws {}
	func startWorkout() async {}
	func stopWorkout() async -> Workout { return Workout(start: Date(), end: Date(), stepCount: 0, calories: 0)}
}
