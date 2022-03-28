import 'package:flutter/material.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/group.dart';


class GroupFormWidgetModel extends ChangeNotifier{
  var _groupName = '';
  String? errorText;

  set groupName(String value){
    if(errorText != null && value.trim().isNotEmpty){
      errorText = null;
      notifyListeners();
    }
    _groupName = value;
  }

  void saveGroup(BuildContext context) async{
    final groupName = _groupName.trim();
    if(groupName.isEmpty) {
      errorText = 'Введите название группы';
      notifyListeners();
      return;
    }

    final group = Group(name: groupName);
    final box = await BoxManager.instance.openGroupBox();
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,

  }) : super(key: key, child: child, notifier: model);

  static GroupFormWidgetModelProvider of(BuildContext context) {
    final GroupFormWidgetModelProvider? result = context.dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
    assert(result != null, 'No GroupFormWidgetProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return true;
  }
}