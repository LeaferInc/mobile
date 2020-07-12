import 'package:flutter/material.dart';

import 'loading.dart';

/// This class displays a loading widget if the list is null,
/// And a centered Text if the list is empty
/// Otherwise it displays the given ListView
class LoadingList extends StatelessWidget {
  final List list;
  final String emptyText;
  final ListView child;

  /// @param list  The list to manage
  /// @param emptyText  The displayed text when the list is empty
  /// @param child  Le ListView à afficher
  LoadingList(
      {@required this.list,
      this.emptyText = 'Aucune donnée',
      @required this.child});

  @override
  Widget build(BuildContext context) {
    if (list == null) {
      return Loading();
    }
    if (list.length == 0) {
      return Center(
        child: Text(
          emptyText,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[500],
          ),
        ),
      );
    }

    return child;
  }
}
