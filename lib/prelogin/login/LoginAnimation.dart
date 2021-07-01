import 'package:flutter/material.dart';

class LoginAnimation {
  static LoginAnimation _loginAnimation;
  Animation<Offset> _imgAnim;
  Animation<Offset> _btnAnim;
  Animation<Offset> _nameAnim;
  Animation<Offset> _passAnim;
  Animation<double> _searchAnim;

  static LoginAnimation getInstance() {
    if (_loginAnimation == null) _loginAnimation = LoginAnimation();
    return _loginAnimation;
  }

  void internal(AnimationController _controller) {
    _searchAnim = CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.8, curve: Curves.elasticOut));

    _nameAnim = Tween(
      begin: Offset(-2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1, 0.35, curve: Curves.easeIn),
      ),
    );
    _imgAnim = Tween(
      begin: Offset(-2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.30, curve: Curves.easeIn),
      ),
    );

    _passAnim = Tween(
      begin: Offset(-2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.15, 0.35, curve: Curves.easeIn),
      ),
    );
    _btnAnim = Tween(
      begin: Offset(-2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.40, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  Animation<double> get searchAnim => _searchAnim;

  Animation<Offset> get passAnim => _passAnim;

  Animation<Offset> get nameAnim => _nameAnim;

  Animation<Offset> get btnAnim => _btnAnim;

  Animation<Offset> get imgAnim => _imgAnim;
}
