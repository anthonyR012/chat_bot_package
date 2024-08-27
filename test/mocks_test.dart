import 'package:chat_bot/util/format_data_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockScrollPosition extends Mock implements ScrollPosition {
  @override
  double get pixels => 0.0;

  @override
  double get maxScrollExtent => 0.0;
}

@GenerateMocks([Dio, ScrollController, TextEditingController, FormatDataUtil])
void main() {}
