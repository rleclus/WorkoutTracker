//
//  HealthKitProtocol.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/09.
//
protocol HealthKitProtocol {
	func requestAuthorisation() async throws
	func startWorkout() async
	func stopWorkout() async -> Workout
}
