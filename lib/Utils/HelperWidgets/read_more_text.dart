import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final Color expandingButtonColor;
  final int minLines;
  ReadMoreText(
    this.text, {
    this.expandingButtonColor,
    this.minLines = 3,
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText>
    with TickerProviderStateMixin<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final expandingButtonColor = widget.expandingButtonColor != null
        ? widget.expandingButtonColor
        : Colors.black;
    return Column(children: <Widget>[
      AnimatedSize(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        child: ConstrainedBox(
          constraints: isExpanded
              ? BoxConstraints()
              : BoxConstraints(maxHeight: (57 / 3) * widget.minLines),
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Text(
              widget.text,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
      Row(
        children: <Widget>[
          GestureDetector(
              child: Text('${isExpanded ? 'Show less' : 'Read more'}',
                  style: TextStyle(color: expandingButtonColor)),
              onTap: () => setState(() => isExpanded = !isExpanded))
        ],
      )
    ]);
  }
}
