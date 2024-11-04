import 'package:flutter/material.dart';

class IconButtonWithTooltip extends StatefulWidget {
  final Widget icon;
  final String tooltipMessage;

  IconButtonWithTooltip({
    required this.icon,
    required this.tooltipMessage,
  });

  @override
  _IconButtonWithTooltipState createState() => _IconButtonWithTooltipState();
}

class _IconButtonWithTooltipState extends State<IconButtonWithTooltip> {
  OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltipMessage,
      child: GestureDetector(
        onTap: () {
          if (_isTooltipVisible) {
            _overlayEntry!.remove();
            _overlayEntry = null;
            _isTooltipVisible = false;
          } else {
            showTooltip(context);
          }
        },
        child: widget.icon,
      ),
    );
  }

  void showTooltip(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox iconBox = context.findRenderObject() as RenderBox;
    final Offset target = iconBox.localToGlobal(Offset.zero, ancestor: overlay);
    final double verticalOffset = 40; // Adjust as needed
    final double preferedWidth = 200.0; // Adjust as needed

    final tooltip = Tooltip(
      message: widget.tooltipMessage,
      child: Container(
        width: preferedWidth,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          widget.tooltipMessage,
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: target.dy + verticalOffset,
        left: target.dx,
        child: Material(
          color: Colors.transparent,
          child: Builder(builder: (context) => tooltip),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
    _isTooltipVisible = true;

    // Remove tooltip after 2 seconds
    Future.delayed(Duration(seconds: 10), () {
      if (_overlayEntry != null) { // Check if _overlayEntry is not null
        _overlayEntry!.remove();
        _overlayEntry = null;
        _isTooltipVisible = false;
      }
    });
  }
}

// class ToolTipCustomShape extends ShapeBorder {
//   final bool usePadding;

//   ToolTipCustomShape({this.usePadding = true});

//   @override
//   EdgeInsetsGeometry get dimensions =>
//       EdgeInsets.only(bottom: usePadding ? 20 : 0);

//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     rect =
//         Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(0, 20));
//     return Path()
//       ..addRRect(
//           RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 3)))
//       ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
//       ..relativeLineTo(10, 20)
//       ..relativeLineTo(10, -20)
//       ..close();
//   }

//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

//   @override
//   ShapeBorder scale(double t) => this;
// }
