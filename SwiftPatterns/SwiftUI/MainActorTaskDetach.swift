import Foundation

/// Run two tasks in the ``@MainActor``.
/// They run sequentially by order of submission. Similar concept to a threadpool and its internal queue in other languages.
///
/// In this example you should see 100 messages of "In Task 1:" followed by 100 messages of task 2.
///
/// https://www.hackingwithswift.com/quick-start/concurrency/whats-the-difference-between-a-task-and-a-detached-task
@MainActor
func tasksRunSequentially() {
    Task {
        for i in 1...100 {
            print("In Task 1: \(i)")
        }
    }
    Task {
        for i in 1...100 {
            print("In Task 2: \(i)")
        }
    }
}

/// Despite wrapped in a ``@MainActor``, run two tasks without actor isolation by making use of ``Task.detach``.
/// The two tasks run concurrently independently of order of submission.
///
/// In this example you should see intermingled lines of"In Task 1:" and "In Task 2:".
@MainActor
func detachedTasks() {
    Task.detached {
        for i in 1...100 {
            print("In Task 1: \(i)")
        }
    }
    Task.detached {
        for i in 1...100 {
            print("In Task 2: \(i)")
        }
    }
}
