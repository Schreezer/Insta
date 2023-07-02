import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../models/user.dart' as model;

class Tester extends StatelessWidget {
  const Tester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("I got rendered");

    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final model.User? user = userProvider.getUser;

        print("User: $user");

        return const Text("Batman is still alive");
      },
    );
  }
}
