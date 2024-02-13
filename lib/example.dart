import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var _isCollaps = true;
  void _toggle() {
    //toggle=переключать
    _isCollaps = !_isCollaps;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ElevatedButton(
          onPressed: _toggle,
          child: Text(_isCollaps ? "Развернуть" : "свернуть"),
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.green,
              child: CollapseAnimatedBox(
                isCollaps: _isCollaps,
                duration: Duration(milliseconds: 2500),
                child: Container(
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class CollapseAnimatedBox extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final bool isCollaps;
  const CollapseAnimatedBox({
    Key? key,
    required this.child,
    required this.duration,
    required this.isCollaps,
  }) : super(key: key);

  @override
  State<CollapseAnimatedBox> createState() => _CollapseAnimatedBoxState();
}

class _CollapseAnimatedBoxState extends State<CollapseAnimatedBox>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    if (!widget.isCollaps) {
      _animationController.value = 1;
    }
  }

  @override
  void didUpdateWidget(CollapseAnimatedBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCollaps == widget.isCollaps) return;
    if (widget.isCollaps) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      axisAlignment: 0.0,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Curves.linear,
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose;
  }
}
