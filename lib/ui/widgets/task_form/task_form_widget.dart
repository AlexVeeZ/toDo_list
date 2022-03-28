import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_model_widget.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;

  const TaskFormWidget({
    Key? key,
    required this.groupKey,
  }) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
        model: _model, child: const _TextFormWidgetBody());
  }
}

class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.of(context).model;
    final actionButton = FloatingActionButton(
      child: const Icon(Icons.done),
      onPressed: () => model.saveTask(context),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая задача'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: _TaskNameTextWidget(),
        ),
      ),
      floatingActionButton: model.isValid == true ? actionButton : null,
    );
  }
}

class _TaskNameTextWidget extends StatelessWidget {
  const _TaskNameTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.of(context).model;
    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        labelText: 'Текст задачи:',
      ),
      onEditingComplete: () => model.saveTask(context),
      onChanged: (value) => model.taskText = value,
    );
  }
}
