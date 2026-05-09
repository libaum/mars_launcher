import 'package:flutter/material.dart';

import 'package:mars_launcher/theme/theme_manager.dart';
import 'package:mars_launcher/logic/todo_manager.dart';
import 'package:mars_launcher/pages/fragments/cards/todo_list_card.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

const TEXT_STYLE_TODO_TITLE = TextStyle(fontSize: 30, fontWeight: FontWeight.normal);
const ROW_PADDING_RIGHT = 60.0;

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final themeManager = getIt<ThemeManager>();
  final todoManager = getIt<TodoManager>();
  late final NewTodoTextField _newTodoTextField =
      NewTodoTextField(callbackAddTodo: todoManager.addTodo);

  @override
  Widget build(BuildContext context) {
    const title = "To-Dos";
    const textDeleteAll = "clear all";

    return GestureDetector(
      onDoubleTap: () {
        themeManager.toggleTheme();
      },
      onTap: () { /// On tap outside of keyboard unfocus
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 33, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TEXT_STYLE_TODO_TITLE,
                    ),
                  TextButton(
                      onPressed: () {
                        todoManager.clearTodoList();
                      },
                      child: const Text(textDeleteAll,
                        style: TextStyle(
                          fontSize: 14
                        ),
                      )
                  )
                ]),
              ),
              Expanded(
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: todoManager.todoListNotifier,
                  builder: (context, todoList, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      itemCount: todoList.length,
                      itemBuilder: (context, index) {
                        return TodoListCard(
                          index: index,
                          todo: todoList[index],
                          callbackRemoveFromTodos: todoManager.removeTodo,
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
                child: _newTodoTextField,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewTodoTextField extends StatefulWidget {
  final callbackAddTodo;

  NewTodoTextField({required this.callbackAddTodo});

  @override
  _NewTodoTextFieldState createState() =>
      _NewTodoTextFieldState();
}

class _NewTodoTextFieldState extends State<NewTodoTextField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final decorationColor = Theme.of(context).primaryColor;
    final hintColor = Theme.of(context).brightness == Brightness.light
        ? decorationColor.withValues(alpha: 0.4)
        : decorationColor.withValues(alpha: 0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            cursorColor: decorationColor,
            style: TEXT_STYLE_APP_SMALL.copyWith(color: decorationColor),
            onEditingComplete: () {},
            onSubmitted: checkInput,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: "Enter todo",
              hintStyle: TEXT_STYLE_APP_SMALL.copyWith(color: hintColor),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          ),
        ),
        // GestureDetector instead of IconButton — IconButton participates in
        // Flutter's focus system and steals focus from the TextField on tap.
        GestureDetector(
          onTap: () => checkInput(_controller.text),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Icon(Icons.add, color: decorationColor, size: 20),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void checkInput(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      widget.callbackAddTodo(trimmed);
      _controller.clear();
    }
    // postFrameCallback lets Flutter re-acquire the IME after the OS closes it
    // on keyboard "done" action, without needing it for the plus-button path.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }
}
