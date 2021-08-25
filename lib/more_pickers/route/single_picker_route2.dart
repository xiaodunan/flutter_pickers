import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/style/picker_style.dart';

typedef SingleCallback(var data, int position);

class PickerContentView extends StatefulWidget {
  PickerContentView({
    Key? key,
    required this.data,
    this.selectData,
    required this.pickerStyle,
  }) : super(key: key);

  final List data;
  final dynamic selectData;
  // final SinglePickerRoute route;
  final PickerStyle pickerStyle;

  @override
  State<StatefulWidget> createState() =>
      _PickerState(this.data, this.selectData, this.pickerStyle);
}

class _PickerState extends State<PickerContentView> {
  final PickerStyle _pickerStyle;
  // 选中数据
  var _selectData;
  // 选中数据下标
  int _selectPosition = 0;

  List _data = [];

  late FixedExtentScrollController scrollCtrl;

  // 单位widget Padding left
  late double _laberLeft;

  _PickerState(this._data, this._selectData, this._pickerStyle) {
    _init();
  }

  @override
  void dispose() {
    scrollCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _renderPickerView();
  }

  _init() {
    int pindex = 0;
    pindex = _data
        .indexWhere((element) => element.toString() == _selectData.toString());
    // 如果没有匹配到选择器对应数据，我们得修改选择器选中数据 ，不然confirm 返回的事设置的数据
    if (pindex < 0) {
      _selectData = _data[0];
      pindex = 0;
    }
    _selectPosition = pindex;

    scrollCtrl = new FixedExtentScrollController(initialItem: pindex);
    _laberLeft = _pickerLaberPadding(_data[pindex].toString());
  }

  void _setPicker(int index) {
    var selectedProvince = _data[index];

    if (_selectData.toString() != selectedProvince.toString()) {
      setState(() {
        _selectData = selectedProvince;
      });
      _selectPosition = index;

      _notifyLocationChanged();
    }
  }

  void _notifyLocationChanged() {
    // if (widget.route.onChanged != null) {
    //   widget.route.onChanged!(_selectData, _selectPosition);
    // }
  }

  double _pickerLaberPadding(String? text) {
    double left = 60;

    if (text != null) {
      left = left + text.length * 12;
    }
    return left;
  }

  double _pickerFontSize(String text) {
    if (text.length <= 6) {
      return 18.0;
    } else if (text.length < 9) {
      return 16.0;
    } else if (text.length < 13) {
      return 12.0;
    } else {
      return 10.0;
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();

    if (!_pickerStyle.showTitleBar && _pickerStyle.menu == null) {
      return itemView;
    }
    List<Widget> viewList = <Widget>[];
    if (_pickerStyle.showTitleBar) {
      viewList.add(_titleView());
    }
    if (_pickerStyle.menu != null) {
      viewList.add(_pickerStyle.menu!);
    }
    viewList.add(itemView);

    return Column(children: viewList);
  }

  Widget _renderItemView() {
    // 选择器
    Widget cPicker = CupertinoPicker.builder(
      scrollController: scrollCtrl,
      itemExtent: _pickerStyle.pickerItemHeight,
      onSelectedItemChanged: (int index) {
        _setPicker(index);
        // if (widget.route.suffix != null && widget.route.suffix != '') {
        //   // 如果设置了才计算 单位的paddingLeft
        //   double resuleLeft = _pickerLaberPadding(_data[index].toString());
        //   if (resuleLeft != _laberLeft) {
        //     setState(() {
        //       _laberLeft = resuleLeft;
        //     });
        //   }
        // }
      },
      childCount: _data.length,
      itemBuilder: (_, index) {
        String text = _data[index].toString();
        return Align(
            alignment: Alignment.center,
            child: Text(text,
                style: TextStyle(
                    color: _pickerStyle.textColor,
                    fontSize: _pickerFontSize(text)),
                textAlign: TextAlign.start));
      },
    );

    Widget view;
    // 单位
    // if (widget.route.suffix != null && widget.route.suffix != '') {
    if (false) {
      // Widget laberView = Center(
      //     child: AnimatedPadding(
      //   duration: Duration(milliseconds: 100),
      //   padding: EdgeInsets.only(left: _laberLeft),
      //   child: Text(widget.route.suffix!,
      //       style: TextStyle(
      //           color: _pickerStyle.textColor,
      //           fontSize: 20,
      //           fontWeight: FontWeight.w500)),
      // ));
      //
      // view = Stack(children: [cPicker, laberView]);
    } else {
      view = cPicker;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: _pickerStyle.pickerHeight,
      color: _pickerStyle.backgroundColor,
      child: view,
    );
  }

  // 选择器上面的view
  Widget _titleView() {
    return Container(
      height: _pickerStyle.pickerTitleHeight,
      decoration: _pickerStyle.headDecoration,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// 取消按钮
          InkWell(
              onTap: () => Navigator.pop(context),
              child: _pickerStyle.cancelButton),

          /// 标题
          Expanded(child: _pickerStyle.title),

          /// 确认按钮
          InkWell(
              onTap: () {
                // if (widget.route.onConfirm != null) {
                //   widget.route.onConfirm!(_selectData, _selectPosition);
                // }
                Navigator.pop(context);
              },
              child: _pickerStyle.commitButton)
        ],
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {required this.pickerStyle});

  final double progress;
  final PickerStyle pickerStyle;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = pickerStyle.pickerHeight;
    if (pickerStyle.showTitleBar) {
      maxHeight += pickerStyle.pickerTitleHeight;
    }
    if (pickerStyle.menu != null) {
      maxHeight += pickerStyle.menuHeight;
    }

    return BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
