import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

abstract class MainNavigationRoutesNames{
  static const groups = '/';
  static const groupsForm = 'groupsForm';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}


class MainNavigation{
  final initialRoute = MainNavigationRoutesNames.groups;
  final routes = {
    MainNavigationRoutesNames.groups: (context) => const GroupsWidget(),
    MainNavigationRoutesNames.groupsForm: (context) => const GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case MainNavigationRoutesNames.tasks:
        final config = settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(
          builder: (context){
            return TasksWidget(config: config);
          }
        );
      case MainNavigationRoutesNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context){
              return TaskFormWidget(groupKey: groupKey);
            }
        );
      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);


    }
  }
}