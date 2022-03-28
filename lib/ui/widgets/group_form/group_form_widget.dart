import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_model_widget.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  _GroupFormWidgetState createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
        model: _model,
    child: const _GroupFormWidgetBody());

  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая группа'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: _GroupNameTextWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () => GroupFormWidgetModelProvider.of(context).model.saveGroup(context),
      ),
    );
  }
}


class _GroupNameTextWidget extends StatelessWidget {
  const _GroupNameTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.of(context).model;
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Название группы:',
        errorText: model.errorText,
      ),
      onEditingComplete: () => model.saveGroup(context),
      onChanged: (value) => model.groupName = value,
    );
  }
}


