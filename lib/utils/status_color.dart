import 'dart:ui';

import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'TODO':
      return Colors.red;
    case 'DOING':
      return Colors.yellow;
    case 'DONE':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
