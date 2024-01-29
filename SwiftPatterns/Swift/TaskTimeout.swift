import Foundation


class TaskTimeoutExample {

    var cachedTask: Task<Int, Error>?

    func sampleTaskWithTimeout(timeoutSecs: Int = 3) async throws -> Int {
        let actualTask = Task {
            try await Task.sleep(for: .seconds(5))
            return 0
        }

        let task = wrapTaskWithTimeout(task: actualTask, timeoutSecs: timeoutSecs)
        return try await task.value
    }

    func sampleTaskWithTimeoutAndDeduplication(timeoutSecs: Int = 3) async throws -> Int {
        if let existingTask = cachedTask {
            return try await existingTask.value
        }

        let actualTask = Task {
            try await Task.sleep(for: .seconds(5))
            return 0
        }

        let task = wrapTaskWithTimeout(task: actualTask, timeoutSecs: timeoutSecs)
        cachedTask = task
        return try await task.value
    }

    func createTimeoutTask(_ otherTask: Task<Int, any Error>, timeoutSecs: Int = 3) -> Task<Void, Error> {
        // https://stackoverflow.com/questions/74710155/how-to-add-a-timeout-to-an-awaiting-function-call
        return Task {
            try await Task.sleep(for: .seconds(timeoutSecs))
            otherTask.cancel()
        }
    }

    func wrapTaskWithTimeout(task: Task<Int, any Error>, timeoutSecs: Int = 3) -> Task<Int, Error> {
        return Task<Int, Error> {
            let timeoutTask = createTimeoutTask(task, timeoutSecs: timeoutSecs)
            return try await withTaskCancellationHandler {
                let result = try await task.value
                timeoutTask.cancel()
                cachedTask = nil
                return result
            } onCancel: {
                task.cancel()
                timeoutTask.cancel()
                cachedTask = nil
            }
        }
    }
}
