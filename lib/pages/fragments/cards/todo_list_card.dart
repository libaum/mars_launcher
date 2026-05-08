import 'package:flutter/material.dart';
import 'package:mars_launcher/theme/theme_constants.dart';

class TodoListCard extends StatelessWidget {
  final int index;
  final String todo;
  final void Function(int) callbackRemoveFromTodos;

  const TodoListCard({
    super.key,
    required this.index,
    required this.todo,
    required this.callbackRemoveFromTodos,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).primaryColor;

    /// Plain Padding + Text instead of TextButton so the layout primitive
    /// matches NewTodoTextField's TextField — same paddings, no minimumSize
    /// quirks → text sits at the exact same X/Y when added.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              todo,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TEXT_STYLE_APP_SMALL.copyWith(color: textColor),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => callbackRemoveFromTodos(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Icon(Icons.remove, color: textColor, size: 20),
          ),
        ),
      ],
    );
  }
}
