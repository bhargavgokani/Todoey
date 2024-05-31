import 'package:flutter/foundation.dart';
import 'task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  final List<Task> _task = [
    Task(name: 'Buy milk'),
    Task(name: 'Do exercise'),
    Task(name: 'Coding'),
  ];
  int get taskCount {
    return _task.length;
  }

  UnmodifiableListView<Task> get task {
    return UnmodifiableListView(_task);
  }

  void addTask(String newtaskTitle) {
    final tasks = Task(name: newtaskTitle);
    _task.add(tasks);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void removeTask(Task task) {
    _task.remove(task);
    notifyListeners();
  }
}
