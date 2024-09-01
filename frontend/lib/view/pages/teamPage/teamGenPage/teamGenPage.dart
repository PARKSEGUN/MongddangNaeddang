import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/teamPageModel/teamGenPageInfo_model.dart';
import 'package:frontend/provider/teamPageProvider/teamGenPageProvider/teamGenPage_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class TeamGenPage extends ConsumerStatefulWidget {
  const TeamGenPage({
    super.key,
  });

  @override
  ConsumerState<TeamGenPage> createState() => _TeamGenPageState();
}

class _TeamGenPageState extends ConsumerState<TeamGenPage> {
  final _key = GlobalKey<FormState>();

  // late TeamPageTeamInfoModel _teamGenInfo;
  late TeamGenPageInfoModel _teamGenInfo;

  // TeamGenPageInfoModel teamGenInfo = TeamGenPageInfoModel(teamName: "HELLO", description: "WORLD", teamColor: "RED");
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Color _currentColor = Color(0XFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _teamGenInfo = TeamGenPageInfoModel.empty();
  }

  Future _pickImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    } else {
      print('이미지 선택 안됨');
    }
  }

  void _changeColor(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  void _pickColor() async {
    Color? selectedColor = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('팀 색 선택'),
          content: SizedBox(
            height: 400,
            width: 300,
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: _changeColor,
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              // pickerAreaBorderRadius: BorderRadius.circular(100),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                GoRouter.of(context).pop(_currentColor);
              },
            ),
          ],
        );
      },
    );
    if (selectedColor != null) {
      setState(() {
        _currentColor = selectedColor;
      });
    }
  }

  String _getHexFromColor(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  // Future<String?> getUserAuthUuid() async {
  //   UserSecureStorage userSecureStorage = UserSecureStorage();
  //   String? authUuid = await userSecureStorage.readAuthUuid();
  //   return authUuid;
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                screenSize.width * 0.05, 0, 0, 0),
                            height: screenSize.width * 0.4,
                            width: screenSize.width * 0.45,
                            child: ClipOval(
                              child: _image == null
                                  ? Image.asset(
                                      'assets/temp/noImg.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(File(_image!.path)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(
                                screenSize.width * 0.05, 0, 0, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                _pickImage(ImageSource.gallery);
                              },
                              child: Text(
                                '이미지 선택',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.05,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              Flexible(
                                flex: 1,
                                child: inputForm('팀 이름', screenSize.height,
                                    screenSize.width),
                              ),
                              Flexible(
                                flex: 1,
                                child: inputForm('팀 소개', screenSize.height,
                                    screenSize.width),
                              ),
                              Expanded(
                                  // flex: 1,
                                  child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: screenSize.width * 0.5,
                                      color: Color(int.parse(
                                          _getHexFromColor(_currentColor)
                                              .substring(1),
                                          radix: 16)),
                                      child: Center(
                                        child: Text(
                                          _getHexFromColor(_currentColor),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 77,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _pickColor();
                                        },
                                        child: Center(
                                          child: Text(
                                            '팀색 선택',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenSize.height * 0.05,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    _key.currentState!.save();
                                    _teamGenInfo.teamColor =
                                        _getHexFromColor(_currentColor);
                                    if (_image != null) {
                                      print("이미지 null아님");
                                      ref
                                          .read(
                                              teamGenNotifierProvider.notifier)
                                          .setImgFile(_image!);
                                      int? statusCode = await ref
                                          .read(
                                              teamGenNotifierProvider.notifier)
                                          .generateTeam(_image!, _teamGenInfo);
                                      if (statusCode == 200) {
                                        GoRouter.of(context).go('/explore');
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                  '팀 생성',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenSize.width * 0.05,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
      // bottomNavigationBar: NavBar(),
    );
  }

  Widget inputForm(String category, double height, double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      alignment: Alignment.center,
      height: height,
      width: width,
      child: TextFormField(
        validator: (val) {
          if (val!.isEmpty) {
            return '$category를 작성하세요.';
          } else {
            return null;
          }
        },
        onSaved: (inputContent) {
          if (category == '팀 이름') {
            _teamGenInfo.teamName = inputContent as String;
          } else if (category == '팀 소개') {
            _teamGenInfo.description = inputContent as String;
          }
          // else if (category == '팀 색상') {
          //   _teamGenInfo.teamColor = inputContent as String;
          // }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: '$category를 입력하세요.',
          labelText: category,
          labelStyle: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
        ],
      ),
    );
  }
}
