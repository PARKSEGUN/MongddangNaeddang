import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/alarmPageDataSource/alarmPage_api.dart';
import 'package:frontend/dataSource/friendPageDataSource/friendPage_api.dart';
import 'package:frontend/provider/alarmPageProvider/alarmPage_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../model/alarmPageModel/alarmPage_model.dart';
import 'deleteAlarmWidget.dart';

class AlarmPage extends ConsumerWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final alarmListAsync = ref.watch(alarmListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(width),
          Expanded(
            child: alarmListAsync.when(
              data: (alarms) => _buildAlarmList(alarms, width, height),
              error: (error, stackTrace) => Center(child: Text('알림이 없습니다.')),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "알림",
            style: TextStyle(
              fontSize: width * 0.1,
              fontWeight: FontWeight.w500,
            ),
          ),
          DeleteAlarmWidget(),
        ],
      ),
    );
  }

  Widget _buildAlarmList(List<AlarmModel> alarms, double width, double height) {
    if (alarms.isEmpty) {
      return Center(child: Text("알림이 없습니다."));
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) => alarmComponent(alarms[index], width, height),
      ),
    );
  }

  Widget alarmComponent(AlarmModel alarm, double width, double height) {
    height = height * 0.15;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: width,
      height: height,
      child: Container(
        color: Color(0xffdbcdff),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: _buildAlarmHeader(alarm, width, height),
            ),
            Flexible(
              flex: 2,
              child: _buildAlarmContent(alarm, width, height),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmHeader(AlarmModel alarm, double width, double height) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: height * 0.03,
            left: width * 0.03,
            child: Text(
              alarm.title,
              style: TextStyle(fontSize: width * 0.05),
            ),
          ),
          if (alarm.title == "친구 요청")
            Positioned(
              top: height * 0.02,
              left: width * 0.25,
              child: _buildAcceptButton(alarm, width),
            ),
          Positioned(
            top: height * 0.13,
            right: width * 0.05,
            child: Text(
              alarm.createdAt,
              style: TextStyle(fontSize: width * 0.03),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(AlarmModel alarm, double width) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xffc1b2e7),
      ),
      onPressed: () {
        FriendApiService().friendAcceptance(alarm.user2Uuid);
      },
      child: Text(
        "수락",
        style: TextStyle(
          fontSize: width * 0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAlarmContent(AlarmModel alarm, double width, double height) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.03,
        height * 0.01,
        width * 0.03,
        width * 0.03,
      ),
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            alarm.content,
            style: TextStyle(fontSize: width * 0.05),
          ),
        ),
      ),
    );
  }
}