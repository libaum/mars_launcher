import 'package:flutter/material.dart';
import 'package:mars_launcher/logic/apps_manager.dart';
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

class _TodoListState extends State<TodoList> with WidgetsBindingObserver {
  final themeManager = getIt<ThemeManager>();
  final appsManager = getIt<AppsManager>();
  final todoManager = getIt<TodoManager>();
  final currentlyInTextFieldNotifier = ValueNotifier(false);
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void callbackRemoveFromTodoList(index) {
    todoManager.removeTodo(index);
  }

  void callbackAddTodo(todo) {
    todoManager.addTodo(todo);
  }

  @override
  Widget build(BuildContext context) {
    const title = "To-Dos";
    const text_delete_all = "clear all";

    final newTodoTextFieldWithPadding = Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: NewTodoTextField(callbackAddTodo: callbackAddTodo),
    );

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
                      child: const Text(text_delete_all,
                        style: TextStyle(
                          fontSize: 12
                        ),
                      )
                  )
                ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
                          child: ValueListenableBuilder<List<String>>(
                              valueListenable: todoManager.todoListNotifier,
                              builder: (context, todoList, child) {
                                var items = todoList.asMap().entries
                                    .map<Widget>((todo) => TodoListCard(
                                          index: todo.key,
                                          todo: todo.value,
                                          callbackRemoveFromTodos: callbackRemoveFromTodoList,
                                        ))
                                    .toList();
                                items.add(newTodoTextFieldWithPadding);

                                return Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: items);
                              })
                      ),
                    ],
                  ),
                ),
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
  TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final decorationColor = Theme.of(context).primaryColor;
    final underlineColor = Colors.transparent;
    final fontSize = 18.0;

    return TextField(
      // maxLength: 2,
      controller: _controller,
      cursorColor: decorationColor,
      onSubmitted: (value) {
        checkInput(value);
      },
      decoration: InputDecoration(
          // counterText: "",
          errorText: _errorText,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: underlineColor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: underlineColor)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: underlineColor)),
          focusColor: Colors.redAccent,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.add,
              color: decorationColor,
            ),
            onPressed: () {
              checkInput(_controller.text.trim());
            },
          ),
          hintText: "Enter todo",
          hintStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? decorationColor.withOpacity(0.4)
                  : decorationColor.withOpacity(0.3), //Colors.black45,
              fontFamily: FONT_LIGHT,
              fontSize: fontSize)),
    );
  }

  checkInput(value) {
    if (value.isEmpty) {
    } else {
      widget.callbackAddTodo(value);
      _controller.clear();
    }
  }

  void setErrorText(errorText) {
    setState(() {
      _errorText = errorText;
    });
  }
}
