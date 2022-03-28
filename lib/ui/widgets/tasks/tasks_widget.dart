import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget_model.dart';

class TaskWidgetConfiguration{
  final int groupKey;
  final String title;

  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfiguration config;
  const TasksWidget({Key? key, required this.config}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TaskWidgetModel  _model;

  @override
  void initState() {
    super.initState();
    _model = TaskWidgetModel(config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return TaskWidgetProvider(
      model: _model,
      child: const TaskWidgetBody());
  }

  @override
  void dispose() async{
    await _model.dispose();
    super.dispose();
  }
}



class TaskWidgetBody extends StatelessWidget {
  const TaskWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetProvider.of(context).model;
    final title = model.config.title ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TasksListWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => model.showForm(context),
      ),
    );
  }
}

class _TasksListWidget extends StatelessWidget {
  const _TasksListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount = TaskWidgetProvider.of(context).model.tasks.length;
    return ListView.separated(
        itemCount: groupsCount,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return _TaskListRowWidget(
            indexInList: index,
          );
        });
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetProvider.of(context).model;
    final task = model.tasks[indexInList];

    final icon = task.isDone ? Icons.done : Icons.do_not_disturb_on_outlined;
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough) : null;
    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteTask(indexInList),
        ),
      ],
      child: ColoredBox(
        color: Colors.white,
        child: ListTile(
          title: Text(
            task.text,
            style: style,
          ),
          trailing: Icon(icon),
          onTap: () => model.doneToggle(indexInList),
        ),
      ),
    );
  }
}
