import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet({
    required this.selectedDate,
    this.scheduleId,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: null,
          builder: (context, snapshot) {
            return FutureBuilder<Schedule>(
                future: widget.scheduleId == null
                    ? null
                    : GetIt.I<LocalDatabase>()
                        .getScheduleById(widget.scheduleId!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('스케줄을 불러올 수 없습니다.'),
                    );
                  }

                  if (snapshot.connectionState != ConnectionState.none &&
                      !snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData && startTime == null) {
                    startTime = snapshot.data!.startTime;
                    endTime = snapshot.data!.endTime;
                    content = snapshot.data!.content;
                    selectedColorId = snapshot.data!.colorId;
                  }

                  return SafeArea(
                    child: Container(
                      color: Colors.white,
                      height:
                          MediaQuery.of(context).size.height / 2 + bottomInset,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: bottomInset),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 8,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Time(
                                  onEndSaved: onEndSaved,
                                  onStartSaved: onStartSaved,
                                  startInitialValue:
                                      startTime?.toString() ?? '',
                                  endInitialValue: endTime?.toString() ?? '',
                                ),
                                SizedBox(height: 16),
                                _Content(
                                  onContentSaved: onContentSaved,
                                  contentInitialValue: content ?? '',
                                ),
                                SizedBox(height: 16),
                                FutureBuilder<List<CategoryColor>>(
                                  future: GetIt.I<LocalDatabase>()
                                      .getCategoryColors(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        selectedColorId == null &&
                                        snapshot.data!.isNotEmpty) {
                                      selectedColorId = snapshot.data![0].id;
                                    }

                                    return _ColorPicker(
                                      colors: snapshot.hasData
                                          ? snapshot.data!
                                          : [],
                                      selectedColorId: selectedColorId,
                                      colorIdSetter: ColorIdSetter,
                                    );
                                  },
                                ),
                                SizedBox(height: 8),
                                _SaveButton(
                                  onPressed: onSavePressed,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  ColorIdSetter(int id) {
    setState(() {
      selectedColorId = id;
    });
  }

  onStartSaved(String? val) {
    startTime = int.parse(val!);
  }

  onEndSaved(String? val) {
    endTime = int.parse(val!);
  }

  onContentSaved(String? val) {
    content = val;
  }

  void onSavePressed() async {
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      }

      Navigator.of(context).pop();
    } else {
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.startInitialValue,
    required this.endInitialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved,
            initialValue: startInitialValue,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            isTime: true,
            onSaved: onEndSaved,
            initialValue: endInitialValue,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onContentSaved;
  final String contentInitialValue;

  const _Content({
    required this.onContentSaved,
    required this.contentInitialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onContentSaved,
        initialValue: contentInitialValue,
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: colors
          .map(
            (e) => GestureDetector(
              onTap: () {
                colorIdSetter(e.id);
              },
              child: renderColor(
                e,
                selectedColorId == e.id,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
          int.parse(
            'FF${color.hexCode}',
            radix: 16,
          ),
        ),
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4,
              )
            : null,
      ),
      width: 32,
      height: 32,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
