import 'package:flutter/cupertino.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormWidgetModel extends ChangeNotifier{
  int groupKey;
  var _taskText = '';
  bool get isValid => _taskText.trim().isNotEmpty;

  set taskText(String value){
    final isTaskTextEmpty = _taskText.trim().isNotEmpty;
    _taskText = value;
    if(value.trim().isEmpty != isTaskTextEmpty){
      notifyListeners();
    }
  }

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async{
    final taskText = _taskText.trim();
    if(taskText.isEmpty) return;

    final task = Task(text: taskText, isDone: false);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedNotifier {

  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
      key: key,
      notifier: model,
      child: child
  );

  static TaskFormWidgetModelProvider of(BuildContext context) {
    final TaskFormWidgetModelProvider? result = context.dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
    assert(result != null, 'No TaskFormWidgetModelProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}