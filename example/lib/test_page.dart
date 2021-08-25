import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';

enum DateTimeInlineType {
  YYYY_MM_DD,
  YYYY_MM_DD_HH_MM_SS,
  YYYY_MM_DD_HH_MM,
  YYYY_MM,
  HH_MM_SS,
  HH_MM,
}

GlobalKey<_DateTimeInlineChooseState> dateTimeInlineChooseGlobalKey =
    GlobalKey();

class DateTimeInlineChoose extends StatefulWidget {
  const DateTimeInlineChoose({
    Key? key,
    // this.dateTimeInlineType = DateTimeInlineType.YYYY_MM_DD,
    this.dateTimeInlineType = DateTimeInlineType.HH_MM_SS,
    this.limitToToday = true,
    this.limitIsTodayAfter = true,
  }) : super(key: key);

  final DateTimeInlineType dateTimeInlineType;
  final bool limitToToday;
  final bool limitIsTodayAfter;

  @override
  State createState() {
    return _DateTimeInlineChooseState();
  }
}

class _DateTimeInlineChooseState extends State<DateTimeInlineChoose> {
  late String _currentDate;

  DateTime current() {
    DateTime _current;
    if (widget.dateTimeInlineType == DateTimeInlineType.YYYY_MM) {
      _current = DateUtil.getDateTime(_currentDate + '-01')!;
    } else if (widget.dateTimeInlineType == DateTimeInlineType.HH_MM_SS) {
      _current = DateUtil.getDateTime('2021-01-01 ' + _currentDate)!;
    } else if (widget.dateTimeInlineType == DateTimeInlineType.HH_MM) {
      _current = DateUtil.getDateTime('2021-01-01 ' + _currentDate)!;
    } else {
      _current = DateUtil.getDateTime(_currentDate)!;
    }
    return _current;
  }

  @override
  void initState() {
    super.initState();

    switch (widget.dateTimeInlineType) {
      case DateTimeInlineType.YYYY_MM_DD:
        setState(() {
          _currentDate =
              DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd');
        });
        break;
      case DateTimeInlineType.YYYY_MM_DD_HH_MM_SS:
        setState(() {
          _currentDate = DateUtil.formatDate(DateTime.now(),
              format: 'yyyy-MM-dd HH:mm:ss');
        });
        break;
      case DateTimeInlineType.YYYY_MM_DD_HH_MM:
        setState(() {
          _currentDate =
              DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd HH:mm');
        });
        break;
      case DateTimeInlineType.YYYY_MM:
        setState(() {
          _currentDate = DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM');
        });
        break;
      case DateTimeInlineType.HH_MM_SS:
        setState(() {
          // _currentDate =
          //     DateUtil.formatDate(DateTime.now(), format: 'HH:mm:ss');
          _currentDate = '18:46:12';
        });
        break;
      case DateTimeInlineType.HH_MM:
        setState(() {
          _currentDate = DateUtil.formatDate(DateTime.now(), format: 'HH:mm');
        });
        break;
    }
  }

  bool _canToPre() {
    if (widget.dateTimeInlineType == DateTimeInlineType.HH_MM_SS ||
        widget.dateTimeInlineType == DateTimeInlineType.HH_MM) {
      return false;
    }
    if (widget.limitToToday) {
      DateTime _current;
      if (widget.dateTimeInlineType == DateTimeInlineType.YYYY_MM) {
        _current = DateUtil.getDateTime(_currentDate + '-01')!;
      } else {
        _current = DateUtil.getDateTime(_currentDate)!;
      }
      if (widget.limitIsTodayAfter) {
        switch (widget.dateTimeInlineType) {
          case DateTimeInlineType.YYYY_MM_DD:
            return _current.isAfter(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day));
          case DateTimeInlineType.YYYY_MM_DD_HH_MM_SS:
            return _current.isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second));
          case DateTimeInlineType.YYYY_MM_DD_HH_MM:
            return _current.isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute));
          case DateTimeInlineType.YYYY_MM:
            return _current
                .isAfter(DateTime(DateTime.now().year, DateTime.now().month));
          default:
            return true;
        }
      }
    }
    return true;
  }

  bool _canToNext() {
    if (widget.dateTimeInlineType == DateTimeInlineType.HH_MM_SS ||
        widget.dateTimeInlineType == DateTimeInlineType.HH_MM) {
      return false;
    }
    if (widget.limitToToday) {
      DateTime _current;
      if (widget.dateTimeInlineType == DateTimeInlineType.YYYY_MM) {
        _current = DateUtil.getDateTime(_currentDate + '-01')!;
      } else {
        _current = DateUtil.getDateTime(_currentDate)!;
      }
      if (!widget.limitIsTodayAfter) {
        switch (widget.dateTimeInlineType) {
          case DateTimeInlineType.YYYY_MM_DD:
            return _current.isBefore(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day));
          case DateTimeInlineType.YYYY_MM_DD_HH_MM_SS:
            return _current.isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second));
          case DateTimeInlineType.YYYY_MM_DD_HH_MM:
            return _current.isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute));
          case DateTimeInlineType.YYYY_MM:
            return _current
                .isBefore(DateTime(DateTime.now().year, DateTime.now().month));
          default:
            return true;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          const SizedBox(width: 6),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(4).copyWith(right: 2, bottom: 5),
              child: Icon(
                Icons.arrow_left_rounded,
                size: 22,
                color: _canToPre() ? Colors.black87 : Colors.black12,
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _preDateTime();
            },
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                _currentDate,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _showDateChooseDialog();
            },
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(4).copyWith(left: 2, bottom: 5),
              child: Icon(
                Icons.arrow_right_rounded,
                size: 22,
                color: _canToNext() ? Colors.black87 : Colors.black12,
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _nextDateTime();
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  /// 前一个日期
  _preDateTime() {
    if (_canToPre()) {
      switch (widget.dateTimeInlineType) {
        case DateTimeInlineType.YYYY_MM_DD:
          DateTime date =
              DateUtils.addDaysToDate(DateUtil.getDateTime(_currentDate)!, -1);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'yyyy-MM-dd');
          });
          break;
        case DateTimeInlineType.YYYY_MM_DD_HH_MM_SS:
          DateTime _current = DateUtil.getDateTime(_currentDate)!;
          int hour = _current.hour;
          int minute = _current.minute;
          int second = _current.second;
          DateTime dateTo = DateUtils.addDaysToDate(_current, -1);
          if (widget.limitToToday && widget.limitIsTodayAfter) {
            if (DateUtils.isSameDay(_current, DateTime.now())) {
              dateTo = DateTime(
                  _current.year,
                  _current.month,
                  _current.day,
                  DateTime.now().hour,
                  DateTime.now().minute,
                  DateTime.now().second);
            }
          }
          DateTime date = DateTime(
              dateTo.year, dateTo.month, dateTo.day, hour, minute, second);
          setState(() {
            _currentDate =
                DateUtil.formatDate(date, format: 'yyyy-MM-dd HH:mm:ss');
          });
          break;
        case DateTimeInlineType.YYYY_MM_DD_HH_MM:
          DateTime _current = DateUtil.getDateTime(_currentDate)!;
          int hour = _current.hour;
          int minute = _current.minute;
          DateTime dateTo = DateUtils.addDaysToDate(_current, -1);
          if (widget.limitToToday && widget.limitIsTodayAfter) {
            if (DateUtils.isSameDay(_current, DateTime.now())) {
              dateTo = DateTime(_current.year, _current.month, _current.day,
                  DateTime.now().hour, DateTime.now().minute);
            }
          }
          DateTime date =
              DateTime(dateTo.year, dateTo.month, dateTo.day, hour, minute);
          setState(() {
            _currentDate =
                DateUtil.formatDate(date, format: 'yyyy-MM-dd HH:mm');
          });
          break;
        case DateTimeInlineType.YYYY_MM:
          DateTime date = DateUtils.addMonthsToMonthDate(
              DateUtil.getDateTime(_currentDate + '-01')!, -1);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'yyyy-MM');
          });
          break;
        case DateTimeInlineType.HH_MM_SS:
          break;
        case DateTimeInlineType.HH_MM:
          break;
      }
    }
  }

  /// 后一个日期
  _nextDateTime() {
    if (_canToNext()) {
      switch (widget.dateTimeInlineType) {
        case DateTimeInlineType.YYYY_MM_DD:
          DateTime date =
              DateUtils.addDaysToDate(DateUtil.getDateTime(_currentDate)!, 1);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'yyyy-MM-dd');
          });
          break;
        case DateTimeInlineType.YYYY_MM_DD_HH_MM_SS:
          DateTime _current = DateUtil.getDateTime(_currentDate)!;
          int hour = _current.hour;
          int minute = _current.minute;
          int second = _current.second;
          DateTime dateTo = DateUtils.addDaysToDate(_current, 1);
          if (widget.limitToToday && !widget.limitIsTodayAfter) {
            if (DateUtils.isSameDay(_current, DateTime.now())) {
              dateTo = DateTime(
                  _current.year,
                  _current.month,
                  _current.day,
                  DateTime.now().hour,
                  DateTime.now().minute,
                  DateTime.now().second);
            }
          }
          DateTime date = DateTime(
              dateTo.year, dateTo.month, dateTo.day, hour, minute, second);
          setState(() {
            _currentDate =
                DateUtil.formatDate(date, format: 'yyyy-MM-dd HH:mm:ss');
          });
          break;
        case DateTimeInlineType.YYYY_MM_DD_HH_MM:
          DateTime _current = DateUtil.getDateTime(_currentDate)!;
          int hour = _current.hour;
          int minute = _current.minute;
          DateTime dateTo = DateUtils.addDaysToDate(_current, 1);
          if (widget.limitToToday && !widget.limitIsTodayAfter) {
            if (DateUtils.isSameDay(_current, DateTime.now())) {
              dateTo = DateTime(_current.year, _current.month, _current.day,
                  DateTime.now().hour, DateTime.now().minute);
            }
          }
          DateTime date =
              DateTime(dateTo.year, dateTo.month, dateTo.day, hour, minute);
          setState(() {
            _currentDate =
                DateUtil.formatDate(date, format: 'yyyy-MM-dd HH:mm');
          });
          break;
        case DateTimeInlineType.YYYY_MM:
          DateTime date = DateUtils.addMonthsToMonthDate(
              DateUtil.getDateTime(_currentDate + '-01')!, 1);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'yyyy-MM');
          });
          break;
        case DateTimeInlineType.HH_MM_SS:
          break;
        case DateTimeInlineType.HH_MM:
          break;
      }
    }
  }

  _showDateChooseDialog() {
    late PDuration current;
    DateMode mode = DateMode.YMD;
    switch (widget.dateTimeInlineType) {
      case DateTimeInlineType.YYYY_MM_DD:
        current = PDuration(
          year: DateUtil.getDateTime(_currentDate)!.year,
          month: DateUtil.getDateTime(_currentDate)!.month,
          day: DateUtil.getDateTime(_currentDate)!.day,
        );
        mode = DateMode.YMD;
        break;
      case DateTimeInlineType.YYYY_MM_DD_HH_MM_SS:
        current = PDuration(
          year: DateUtil.getDateTime(_currentDate)!.year,
          month: DateUtil.getDateTime(_currentDate)!.month,
          day: DateUtil.getDateTime(_currentDate)!.day,
          hour: DateUtil.getDateTime(_currentDate)!.hour,
          minute: DateUtil.getDateTime(_currentDate)!.minute,
          second: DateUtil.getDateTime(_currentDate)!.second,
        );
        mode = DateMode.YMDHMS;
        break;
      case DateTimeInlineType.YYYY_MM_DD_HH_MM:
        current = PDuration(
          year: DateUtil.getDateTime(_currentDate)!.year,
          month: DateUtil.getDateTime(_currentDate)!.month,
          day: DateUtil.getDateTime(_currentDate)!.day,
          hour: DateUtil.getDateTime(_currentDate)!.hour,
          minute: DateUtil.getDateTime(_currentDate)!.minute,
        );
        mode = DateMode.YMDHM;
        break;
      case DateTimeInlineType.YYYY_MM:
        current = PDuration(
          year: DateUtil.getDateTime(_currentDate + '-01')!.year,
          month: DateUtil.getDateTime(_currentDate + '-01')!.month,
        );
        mode = DateMode.YM;
        break;
      case DateTimeInlineType.HH_MM_SS:
        current = PDuration(
          hour: DateUtil.getDateTime('2021-01-01 ' + _currentDate)!.hour,
          minute: DateUtil.getDateTime('2021-01-01 ' + _currentDate)!.minute,
          second: DateUtil.getDateTime('2021-01-01 ' + _currentDate)!.second,
        );
        mode = DateMode.HMS;
        break;
      case DateTimeInlineType.HH_MM:
        current = PDuration(
          hour: DateUtil.getDateTime('2021-01-01 ' + _currentDate)!.hour,
          minute: DateUtil.getDateTime('2021-01-01 ' + _currentDate)!.minute,
        );
        mode = DateMode.HM;
        break;
    }
    Pickers.showDatePicker(context,
        mode: mode,
        selectDate: current,
        // minDate: widget.limitToToday && widget.limitIsTodayAfter
        //     ? PDuration.now()
        //     : null,
        minDate: PDuration(
            year: 2021, month: 1, day: 1, hour: 18, minute: 46, second: 12),
        maxDate: widget.limitToToday && !widget.limitIsTodayAfter
            ? PDuration.now()
            : null, onConfirm: (PDuration res) {
      switch (widget.dateTimeInlineType) {
        case DateTimeInlineType.YYYY_MM_DD:
          DateTime date = DateTime(res.year ?? 0, res.month ?? 0, res.day ?? 0);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'yyyy-MM-dd');
          });
          break;
        case DateTimeInlineType.YYYY_MM_DD_HH_MM_SS:
          DateTime date = DateTime(res.year ?? 0, res.month ?? 0, res.day ?? 0,
              res.hour ?? 0, res.minute ?? 0, res.second ?? 0);
          setState(() {
            _currentDate =
                DateUtil.formatDate(date, format: 'yyyy-MM-dd HH:mm:ss');
          });
          break;
        case DateTimeInlineType.YYYY_MM_DD_HH_MM:
          DateTime date = DateTime(res.year ?? 0, res.month ?? 0, res.day ?? 0,
              res.hour ?? 0, res.minute ?? 0);
          setState(() {
            _currentDate =
                DateUtil.formatDate(date, format: 'yyyy-MM-dd HH:mm');
          });
          break;
        case DateTimeInlineType.YYYY_MM:
          DateTime date = DateTime(res.year ?? 0, res.month ?? 0);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'yyyy-MM');
          });
          break;
        case DateTimeInlineType.HH_MM_SS:
          DateTime date = DateTime(
              2021, 1, 1, res.hour ?? 0, res.minute ?? 0, res.second ?? 0);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'HH:mm:ss');
          });
          break;
        case DateTimeInlineType.HH_MM:
          DateTime date = DateTime(2021, 1, 1, res.hour ?? 0, res.minute ?? 0);
          setState(() {
            _currentDate = DateUtil.formatDate(date, format: 'HH:mm');
          });
          break;
      }
    }, onChanged: (PDuration res) {
      // print('longer   改变 >>> ${res}');
    });
  }
}
