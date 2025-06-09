//
//  File.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//

import HealthKit

enum HealthKitWorkerError: Error {
	case healthkitUnavailable
	case stepCountUnavailable
	case caloriesUnavailable
	case otherHealthKitError(error: Error)
}

class HealthKitWorker: HealthKitProtocol, @unchecked Sendable {
	init() {}
	
	private var healthStore = HKHealthStore()
	private var currentWorkoutBuilder: HKWorkoutBuilder? = nil
	private var observerQuery: HKObserverQuery?
	private var accumulatedSteps: Double = 0
	private var streamTask: Task<Void, Never>?
	private var workoutStart: Date = Date()
	
	func requestAuthorisation() async throws {
		guard HKHealthStore.isHealthDataAvailable() else {
			throw HealthKitWorkerError.healthkitUnavailable
		}
		
		let typesToRead: Set = [
			HKQuantityType.quantityType(forIdentifier: .heartRate)!,
			HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
			HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
			HKQuantityType.quantityType(forIdentifier: .stepCount)!
		]
		try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Void, Error>) in
			healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
				if let error = error {
					continuation.resume(throwing: HealthKitWorkerError.otherHealthKitError(error: error))
				} else {
					continuation.resume()
				}
			}
		})
	}
	func startWorkout() async {
		workoutStart = Date()
		accumulatedSteps = 0
		
		streamTask?.cancel()
		streamTask = Task {
			for await steps in stepCountUpdatesStream() {
				accumulatedSteps = steps
				print("Accumulated Steps: \(accumulatedSteps)")
			}
		}
	}
	
	func stopWorkout() async -> Workout {
		streamTask?.cancel()
		streamTask = nil
		
		if let query = observerQuery {
			healthStore.stop(query)
			observerQuery = nil
		}
		
		let endDate = Date()
		let totalSteps = Int(accumulatedSteps)
		print("totalSteps Steps: \(totalSteps)")

		return Workout(start: workoutStart, end: endDate, stepCount: totalSteps, calories: 0)
	}
	
	private func stepCountUpdatesStream() -> AsyncStream<Double> {
		AsyncStream { continuation in
			let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
			
			observerQuery = HKObserverQuery(sampleType: stepType, predicate: nil) { _, _, error in
				if let error = error {
					continuation.finish()
					print("Observer error: \(error)")
					return
				}
				
				Task {
					let steps = await self.fetchCurrentStepCount()
					continuation.yield(steps)
				}
			}
			
			if let query = observerQuery {
				healthStore.execute(query)
				healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { success, error in
					if let error = error {
						print("Background delivery error: \(error.localizedDescription)")
					}
				}
			}
			
			continuation.onTermination = { _ in
				if let query = self.observerQuery {
					self.healthStore.stop(query)
					self.observerQuery = nil
				}
			}
		}
	}
	
	private func fetchCurrentStepCount() async -> Double {
		let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
		let now = Date()
		let predicate = HKQuery.predicateForSamples(withStart: workoutStart, end: now, options: .strictStartDate)
		
		return await withCheckedContinuation { continuation in
			let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
				let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
				print("Fetching current Steps: \(steps)")
				continuation.resume(returning: steps)
			}
			self.healthStore.execute(query)
		}
	}
}
