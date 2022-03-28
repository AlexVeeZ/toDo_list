import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;

  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutesNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int indexGroup) async {
    final group = (await _box).getAt(indexGroup);
    if(group != null){
      final config = TaskWidgetConfiguration(group.key as int, group.name);
      Navigator.of(context)
          .pushNamed(MainNavigationRoutesNames.tasks,
          arguments: config);
    }

  }

  GroupsWidgetModel() {
    _setup();
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> deleteGroup(int indexGroup) async {
    final box = await _box;
    final groupKey = box.keyAt(indexGroup) as int;
    await Hive.deleteBoxFromDisk(BoxManager.instance.makeTaskBoxName(groupKey));
    await box.deleteAt(indexGroup);
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  @override
  Future<void> dispose() async{
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox(await _box);
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupsWidgetModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(key: key, notifier: model, child: child);

  static GroupsWidgetModelProvider of(BuildContext context) {
    final GroupsWidgetModelProvider? result =
        context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
    assert(result != null, 'No GroupsWidgetModelProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GroupsWidgetModelProvider oldWidget) {
    return false;
  }
}
