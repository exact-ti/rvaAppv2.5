import 'package:flutter/material.dart';

abstract class ILoginCore {
  Future<bool> login(String username, String password,BuildContext context);
}
