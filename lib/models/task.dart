class Task {
  late final String name;
  late bool isDone;
  Task({this.isDone = false, required this.name});
  void toggleDone() {
    isDone = !isDone;
  }
}
