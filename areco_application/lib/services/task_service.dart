import '../models/task_model.dart';

class TaskService {
  final List<TaskModel> _mockTasks = [];

  Future<List<TaskModel>> getTasks() async {
    return _mockTasks;
  }

  Future<void> addTask(TaskModel task) async {
    _mockTasks.add(task);
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    final index = _mockTasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _mockTasks[index] = updatedTask;
    }
  }

  Future<void> deleteTask(int id) async {
    _mockTasks.removeWhere((t) => t.id == id);
  }
}
