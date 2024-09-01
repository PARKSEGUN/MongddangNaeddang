import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/alarmPageProvider/alarmPage_provider.dart';

class DeleteAlarmWidget extends ConsumerWidget {
  const DeleteAlarmWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(onPressed: () {
      // 알람 삭제 요청
      ref.read(alarmListNotifierProvider.notifier).deleteAlarmAll(context);
    }, icon: Icon(Icons.delete));
  }
}
