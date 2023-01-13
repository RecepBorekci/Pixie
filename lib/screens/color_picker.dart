import 'package:flutter/material.dart';
import 'package:photo_editor/utils/chosen_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Color Picker Demo"),
        ),
        body: const SafeArea(
          child: ColorPicker(300),
        ),
      ),
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  _SliderIndicatorPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(position, size.height / 2), 12, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}

class ColorPicker extends StatefulWidget {
  final double width;
  const ColorPicker(this.width, {super.key});
  @override
  ColorPickerState createState() => ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 128, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 128, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 128),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 128, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 127, 0, 255),
    const Color.fromARGB(255, 255, 0, 255),
    const Color.fromARGB(255, 255, 0, 127),
    const Color.fromARGB(255, 128, 128, 128),
  ];
  double _colorSliderPosition = 0;
  late double _shadeSliderPosition;
  late Color _currentColor;
  late Color _shadedColor;

  Color getColor() {
    return _shadedColor;
  }

  @override
  initState() {
    super.initState();
    _currentColor = _calculateSelectedColor(_colorSliderPosition);
    _shadeSliderPosition = widget.width / 2;
    _shadedColor = _calculateShadedColor(_shadeSliderPosition);
  }

  _colorChangeHandler(double position) {
    if (position > widget.width) {
      position = widget.width;
    }
    if (position < 0) {
      position = 0;
    }
    setState(() {
      _colorSliderPosition = position;
      _currentColor = _calculateSelectedColor(_colorSliderPosition);
      _shadedColor = _calculateShadedColor(_shadeSliderPosition);
    });
  }

  _shadeChangeHandler(double position) {
    if (position > widget.width) position = widget.width;
    if (position < 0) position = 0;
    setState(() {
      _shadeSliderPosition = position;
      _shadedColor = _calculateShadedColor(_shadeSliderPosition);
    });
  }

  Color _calculateShadedColor(double position) {
    double ratio = position / widget.width;
    if (ratio > 0.5) {
      int redVal = _currentColor.red != 255
          ? (_currentColor.red +
                  (255 - _currentColor.red) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      int greenVal = _currentColor.green != 255
          ? (_currentColor.green +
                  (255 - _currentColor.green) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      int blueVal = _currentColor.blue != 255
          ? (_currentColor.blue +
                  (255 - _currentColor.blue) * (ratio - 0.5) / 0.5)
              .round()
          : 255;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else if (ratio < 0.5) {
      int redVal = _currentColor.red != 0
          ? (_currentColor.red * ratio / 0.5).round()
          : 0;
      int greenVal = _currentColor.green != 0
          ? (_currentColor.green * ratio / 0.5).round()
          : 0;
      int blueVal = _currentColor.blue != 0
          ? (_currentColor.blue * ratio / 0.5).round()
          : 0;
      return Color.fromARGB(255, redVal, greenVal, blueVal);
    } else {
      return _currentColor;
    }
  }

  Color _calculateSelectedColor(double position) {
    double positionInColorArray =
        (position / widget.width * (_colors.length - 1));
    int index = positionInColorArray.truncate();
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      _currentColor = _colors[index];
    } else {
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
                  (_colors[index + 1].red - _colors[index].red) * remainder)
              .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
                  (_colors[index + 1].green - _colors[index].green) * remainder)
              .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
                  (_colors[index + 1].blue - _colors[index].blue) * remainder)
              .round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
    }
    return _currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: _shadedColor,
            shape: BoxShape.circle,
          ),
        ),
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _colorChangeHandler(details.localPosition.dx);
              ChosenColor.painterController.drawColor = _shadedColor;
            },
            onTapDown: (TapDownDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: widget.width,
                height: 15,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: _colors),
                ),
                child: CustomPaint(
                  painter: _SliderIndicatorPainter(_colorSliderPosition),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
              ChosenColor.painterController.drawColor = _shadedColor;
            },
            onTapDown: (TapDownDetails details) {
              _shadeChangeHandler(details.localPosition.dx);
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: widget.width,
                height: 15,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      colors: [Colors.black, _currentColor, Colors.white]),
                ),
                child: CustomPaint(
                  painter: _SliderIndicatorPainter(_shadeSliderPosition),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
