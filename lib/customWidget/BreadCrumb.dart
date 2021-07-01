import 'package:flutter/material.dart';

class Bread<T> {
  final Function(String id, int type) route;
  final arguments;
  final String label;
  final int type;

  Bread({@required this.label, this.route, this.type, this.arguments});
}

class Breadcrumb<T> extends StatelessWidget {
  final Color color;
  final double height;
  final Widget separator;
  final ValueChanged<T> onValueChanged;
  final List<Bread<T>> breads;

  const Breadcrumb({
    this.height = 35.0,
    this.color = const Color(0xFF123391),
    this.separator = const Icon(
      Icons.arrow_forward_ios,
      size: 12.0,
      color: Colors.black,
    ),
    this.onValueChanged,
    @required this.breads,
  }) : assert(breads != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: height,
          child: ListView.separated(
            itemCount: breads.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext ctx, int index) {
              final bread = breads[index];
              bool isLast = bread == breads.last;
              Color _color = isLast ? Colors.black : color;

              return InkWell(
                onTap: () {
                  final arguments = bread.arguments;
                  if (bread.route != null) bread.route(arguments, bread.type);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      bread.label,
                      softWrap: false,
                      textScaleFactor: 1.1,
                      style: TextStyle(
                        color: _color,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        decoration: isLast ? null : TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext ctx, int index) => separator,
          ),
        ),
      ],
    );
  }
}
