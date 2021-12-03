import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:ui';

class SearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  SearchBar({required this.hintText, required this.onChanged});
  @override
  _SearchBar createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar> {
  FocusNode _focus = new FocusNode();
  double height = 47.0;
  double margin = 40.0;

  TextEditingController _controller = new TextEditingController();
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    final keyboardVisibilityController = KeyboardVisibilityController();
    // Query

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        setState(() {
          height = window.physicalSize.height;
          margin = 0;
        });
      } else {
        _focus.unfocus();
        setState(() {
          height = 47.0;
          margin = 40.0;
        });
      }
    });
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }

  void _onFocusChange() {}

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        clipBehavior: Clip.hardEdge,
        height: height,
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius:
                BorderRadius.all(Radius.circular(margin == 40.0 ? 12 : 0))),
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.only(top: margin == 40.0 ? 0 : 40.0),
        duration: Duration(milliseconds: 300),
        child: TextField(
            focusNode: _focus,
            controller: _controller,
            onChanged: widget.onChanged,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade900,
                contentPadding: EdgeInsets.zero,
                hintText: 'Search...',
                hintStyle: TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
                alignLabelWithHint: true)));
  }
}

// class SearchBar extends StatelessWidget {
//   final String hintText;
//   final Function(String) onChanged;
//   SearchBar({required this.hintText, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     double h = 40;
//     return AnimatedContainer(
//         decoration: BoxDecoration(color: Colors.red),
//         clipBehavior: Clip.hardEdge,
//         height: h,
//         width: double.infinity,
//         duration: Duration(seconds: 1),
//         child: Center(
//             child: TextField(
//                 onTap: () {
//                   h = 100;
//                   print("OK");
//                 },
//                 onChanged: onChanged,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 15),
//                 decoration: InputDecoration(
//                     isDense: true,
//                     contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                         borderSide: BorderSide(color: Colors.grey)),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       borderSide: BorderSide(color: Colors.amber),
//                     ),
//                     hintText: 'Search...',
//                     hintStyle: TextStyle(
//                         letterSpacing: 2, fontWeight: FontWeight.w600),
//                     alignLabelWithHint: true))));
//   }
// }
