import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PinView extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final TextInputType keyboardType;
  final int itemCount;
  final double itemSize;
  final bool autofocus;
  final OutlineInputBorder border;
  final TextStyle textStyle;

  PinView(
      {Key key,
        this.onCompleted,
        this.keyboardType = TextInputType.number,
        this.itemCount = 4,
        this.border,
        this.itemSize = 50,
        this.textStyle = const TextStyle(fontSize: 25.0, color: Colors.black),
        this.autofocus = true})
      : assert(itemCount > 0),
        assert(itemSize > 0),
        super(key: key);

  @override
  _PinViewState createState() => _PinViewState();
}

class _PinViewState extends State<PinView> {
  final List<FocusNode> _listFocusNode = <FocusNode>[];
  final List<TextEditingController> _listControllerText = <TextEditingController>[];
  List<String> _code = List();
  int _currentIndex = 0;

  @override
  void initState() {
    if (_listFocusNode.isEmpty) {
      for (var i = 0; i < widget.itemCount; i++) {
        _listFocusNode.add(new FocusNode());
        _listControllerText.add(new TextEditingController());
        _code.add(' ');
      }
    }
    super.initState();
  }

  String _getInputVerify() {
    String pin = '';
    for (var i = 0; i < widget.itemCount; i++) {
      for (var index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != ' ') {
          pin += _listControllerText[i].text[index];
        }
      }
    }
    return pin;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _widgetItemList()
      ),
    );
  }

  List<Widget> _widgetItemList(){
    List<Widget> widgetList = List();
    for(int index = 0; index<widget.itemCount;index ++){
      double left = (index == 0) ? 0.0 : (widget.itemSize / 10);
      widgetList.add(Container(
        height: widget.itemSize,
        width: widget.itemSize,
        margin: EdgeInsets.only(left: left),
        child: _inputField(index)
      ));
    }
    return widgetList;
  }

  Widget _inputField(int index) {
    return TextField(
      keyboardType: widget.keyboardType,
      maxLines: 1,
      maxLength: 2,
      focusNode: _listFocusNode[index],
      decoration: InputDecoration(
          border: widget.border,
          enabled: _currentIndex == index,
          counterText: "",
          contentPadding: EdgeInsets.all(((widget.itemSize * 2) / 10)),
          fillColor: Colors.black),
      onChanged: (String value) {
        if (value.length > 1 && index < widget.itemCount || index == 0 && value.isNotEmpty) {
          if (index == widget.itemCount - 1) {
            widget.onCompleted(_getInputVerify());
            return;
          }
          if (_listControllerText[index + 1].value.text.isEmpty) {
            _listControllerText[index + 1].value =
            new TextEditingValue(text: " ");
          }
          if (value.length == 2) {
            if (value[0] != _code[index]) {
              _code[index] = value[0];
            } else if (value[1] != _code[index]) {
              _code[index] = value[1];
            }
            if (value[0] == " ") {
              _code[index] = value[1];
            }
            _listControllerText[index].text = _code[index];
          }
          _next(index);

          return;
        }
        if (value.isEmpty && index >= 0) {
          if (_listControllerText[index - 1].value.text.isEmpty) {
            _listControllerText[index - 1].value =
            new TextEditingValue(text: " ");
          }
          _prev(index);
        }
      },
      controller: _listControllerText[index],
      maxLengthEnforced: true,
      autocorrect: false,
      textAlign: TextAlign.center,
      autofocus: widget.autofocus,
      style: widget.textStyle,
    );
  }

  void _next(int index) {
    if (index != widget.itemCount) {
      setState(() {
        _currentIndex = index + 1;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index + 1]);
      });
    }
  }

  void _prev(int index) {
    if (index > 0) {
      setState(() {
        if (_listControllerText[index].text.isEmpty) {
          _listControllerText[index - 1].text = ' ';
        }
        _currentIndex = index - 1;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index - 1]);
      });
    }
  }
}
