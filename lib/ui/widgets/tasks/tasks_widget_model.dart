import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/task.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';


class TaskWidgetModel extends ChangeNotifier {
  TaskWidgetConfiguration config;
  late final Future<Box<Task>> _box;
  ValueListenable<Object>? _listenableBox;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TaskWidgetModel({required this.config}){
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(
        MainNavigationRoutesNames.tasksForm,
        arguments: config.groupKey);
  }

  Future <void> deleteTask (int indexTask) async{
    (await _box).deleteAt(indexTask);
  }

  Future <void> doneToggle(int indexTask) async{
    final task = (await _box).deleteAt(indexTask);
    /*task?.isDone = !task.isDone;
    await task?.save();*/
  }


  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future <void> _setup() async {
    _box = BoxManager.instance.openTaskBox(config.groupKey);
    await _readTasksFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTasksFromHive);
  }

  @override
  Future <void> dispose() async{
    _listenableBox?.removeListener(_readTasksFromHive);
    await BoxManager.instance.closeBox(await _box);
    super.dispose();
  }



}

class TaskWidgetProvider extends InheritedNotifier {
  final TaskWidgetModel model;
  const TaskWidgetProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, child: child, notifier: model);

  static TaskWidgetProvider of(BuildContext context) {
    final TaskWidgetProvider? result = context.dependOnInheritedWidgetOfExactType<TaskWidgetProvider>();
    assert(result != null, 'No  found in context');
    return result!;
  }
}