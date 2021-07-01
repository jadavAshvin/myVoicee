import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  /// Creates a MyDialog.
  ///
  /// Typically used in conjunction with [showMyDialog].
  const MyDialog({
    Key key,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
    this.child,
  }) : super(key: key);

  /// {@template flutter.material.MyDialog.backgroundColor}
  /// The background color of the surface of this [MyDialog].
  ///
  /// This sets the [Material.color] on this [MyDialog]'s [Material].
  ///
  /// If `null`, [ThemeData.cardColor] is used.
  /// {@endtemplate}
  final Color backgroundColor;

  /// {@template flutter.material.MyDialog.elevation}
  /// The z-coordinate of this [MyDialog].
  ///
  /// If null then [MyDialogTheme.elevation] is used, and if that's null then the
  /// MyDialog's elevation is 24.0.
  /// {@endtemplate}
  /// {@macro flutter.material.material.elevation}
  final double elevation;

  /// {@template flutter.material.MyDialog.insetAnimationDuration}
  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the MyDialog is placed in.
  ///
  /// Defaults to 100 milliseconds.
  /// {@endtemplate}
  final Duration insetAnimationDuration;

  /// {@template flutter.material.MyDialog.insetAnimationCurve}
  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the MyDialog is placed in.
  ///
  /// Defaults to [Curves.decelerate].
  /// {@endtemplate}
  final Curve insetAnimationCurve;

  /// {@template flutter.material.MyDialog.shape}
  /// The shape of this MyDialog's border.
  ///
  /// Defines the MyDialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  /// {@endtemplate}
  final ShapeBorder shape;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  // TODO(johnsonmh): Update default MyDialog border radius to 4.0 to match material spec.
  static const RoundedRectangleBorder _defaultMyDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme MyDialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              color: backgroundColor ??
                  MyDialogTheme.backgroundColor ??
                  Theme.of(context).backgroundColor,
              elevation:
                  elevation ?? MyDialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? MyDialogTheme.shape ?? _defaultMyDialogShape,
              type: MaterialType.card,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A material design alert MyDialog.
///
/// An alert MyDialog informs the user about situations that require
/// acknowledgement. An alert MyDialog has an optional title and an optional list
/// of actions. The title is displayed above the content and the actions are
/// displayed below the content.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=75CsnyRXf5I}
///
/// If the content is too large to fit on the screen vertically, the MyDialog will
/// display the title and the actions and let the content overflow, which is
/// rarely desired. Consider using a scrolling widget for [content], such as
/// [SingleChildScrollView], to avoid overflow. (However, be aware that since
/// [AlertMyDialog] tries to size itself using the intrinsic dimensions of its
/// children, widgets such as [ListView], [GridView], and [CustomScrollView],
/// which use lazy viewports, will not work. If this is a problem, consider
/// using [MyDialog] directly.)
///
/// For MyDialogs that offer the user a choice between several options, consider
/// using a [SimpleMyDialog].
///
/// Typically passed as the child widget to [showMyDialog], which displays the
/// MyDialog.
///
/// {@tool sample}
///
/// This snippet shows a method in a [State] which, when called, displays a MyDialog box
/// and returns a [Future] that completes when the MyDialog is dismissed.
///
/// ```dart
/// Future<void> _neverSatisfied() async {
///   return showMyDialog<void>(
///     context: context,
///     barrierDismissible: false, // user must tap button!
///     builder: (BuildContext context) {
///       return AlertMyDialog(
///         title: Text('Rewind and remember'),
///         content: SingleChildScrollView(
///           child: ListBody(
///             children: <Widget>[
///               Text('You will never be satisfied.'),
///               Text('You\’re like me. I’m never satisfied.'),
///             ],
///           ),
///         ),
///         actions: <Widget>[
///           FlatButton(
///             child: Text('Regret'),
///             onPressed: () {
///               Navigator.of(context).pop();
///             },
///           ),
///         ],
///       );
///     },
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [SimpleMyDialog], which handles the scrolling of the contents but has no [actions].
///  * [MyDialog], on which [AlertMyDialog] and [SimpleMyDialog] are based.
///  * [CupertinoAlertMyDialog], an iOS-styled alert MyDialog.
///  * [showMyDialog], which actually displays the MyDialog and returns its result.
///  * <https://material.io/design/components/MyDialogs.html#alert-MyDialog>
class AlertMyDialog extends StatelessWidget {
  /// Creates an alert MyDialog.
  ///
  /// Typically used in conjunction with [showMyDialog].
  ///
  /// The [contentPadding] must not be null. The [titlePadding] defaults to
  /// null, which implies a default that depends on the values of the other
  /// properties. See the documentation of [titlePadding] for details.
  const AlertMyDialog({
    Key key,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.shape,
  })  : assert(contentPadding != null),
        super(key: key);

  /// The (optional) title of the MyDialog is displayed in a large font at the top
  /// of the MyDialog.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Padding around the title.
  ///
  /// If there is no title, no padding will be provided. Otherwise, this padding
  /// is used.
  ///
  /// This property defaults to providing 24 pixels on the top, left, and right
  /// of the title. If the [content] is not null, then no bottom padding is
  /// provided (but see [contentPadding]). If it _is_ null, then an extra 20
  /// pixels of bottom padding is added to separate the [title] from the
  /// [actions].
  final EdgeInsetsGeometry titlePadding;

  /// Style for the text in the [title] of this [AlertMyDialog].
  ///
  /// If null, [MyDialogTheme.titleTextStyle] is used, if that's null, defaults to
  /// [ThemeData.textTheme.title].
  final TextStyle titleTextStyle;

  /// The (optional) content of the MyDialog is displayed in the center of the
  /// MyDialog in a lighter font.
  ///
  /// Typically this is a [SingleChildScrollView] that contains the MyDialog's
  /// message. As noted in the [AlertMyDialog] documentation, it's important
  /// to use a [SingleChildScrollView] if there's any risk that the content
  /// will not fit.
  final Widget content;

  /// Padding around the content.
  ///
  /// If there is no content, no padding will be provided. Otherwise, padding of
  /// 20 pixels is provided above the content to separate the content from the
  /// title, and padding of 24 pixels is provided on the left, right, and bottom
  /// to separate the content from the other edges of the MyDialog.
  final EdgeInsetsGeometry contentPadding;

  /// Style for the text in the [content] of this [AlertMyDialog].
  ///
  /// If null, [MyDialogTheme.contentTextStyle] is used, if that's null, defaults
  /// to [ThemeData.textTheme.subhead].
  final TextStyle contentTextStyle;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// MyDialog.
  ///
  /// Typically this is a list of [FlatButton] widgets.
  ///
  /// These widgets will be wrapped in a [ButtonBar], which introduces 8 pixels
  /// of padding on each side.
  ///
  /// If the [title] is not null but the [content] _is_ null, then an extra 20
  /// pixels of padding is added above the [ButtonBar] to separate the [title]
  /// from the [actions].
  final List<Widget> actions;

  /// {@macro flutter.material.MyDialog.backgroundColor}
  final Color backgroundColor;

  /// {@macro flutter.material.MyDialog.elevation}
  /// {@macro flutter.material.material.elevation}
  final double elevation;

  /// The semantic label of the MyDialog used by accessibility frameworks to
  /// announce screen transitions when the MyDialog is opened and closed.
  ///
  /// If this label is not provided, a semantic label will be inferred from the
  /// [title] if it is not null.  If there is no title, the label will be taken
  /// from [MaterialLocalizations.alertMyDialogLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.isRouteName], for a description of how this
  ///    value is used.
  final String semanticLabel;

  /// {@macro flutter.material.MyDialog.shape}
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final DialogTheme MyDialogTheme = DialogTheme.of(context);

    String label = semanticLabel;
    if (title == null) {
      switch (theme.platform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }

    Widget MyDialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          (title != null)
              ? Padding(
                  padding: titlePadding ??
                      EdgeInsets.fromLTRB(
                          24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
                  child: DefaultTextStyle(
                    style: titleTextStyle ??
                        MyDialogTheme.titleTextStyle ??
                        theme.textTheme.title,
                    child: Semantics(
                      child: title,
                      namesRoute: true,
                      container: true,
                    ),
                  ),
                )
              : Container(),
          (content != null)
              ? Flexible(
                  child: Padding(
                    padding: contentPadding,
                    child: DefaultTextStyle(
                      style: contentTextStyle ??
                          MyDialogTheme.contentTextStyle ??
                          theme.textTheme.subhead,
                      child: content,
                    ),
                  ),
                )
              : Container(),
          (actions != null)
              ? ButtonBar(
                  children: actions,
                )
              : Container(),
        ],
      ),
    );

    if (label != null)
      MyDialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: MyDialogChild,
      );

    return MyDialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      child: MyDialogChild,
    );
  }
}

/// An option used in a [SimpleMyDialog].
///
/// A simple MyDialog offers the user a choice between several options. This
/// widget is commonly used to represent each of the options. If the user
/// selects this option, the widget will call the [onPressed] callback, which
/// typically uses [Navigator.pop] to close the MyDialog.
///
/// The padding on a [SimpleMyDialogOption] is configured to combine with the
/// default [SimpleMyDialog.contentPadding] so that each option ends up 8 pixels
/// from the other vertically, with 20 pixels of spacing between the MyDialog's
/// title and the first option, and 24 pixels of spacing between the last option
/// and the bottom of the MyDialog.
///
/// {@tool sample}
///
/// ```dart
/// SimpleMyDialogOption(
///   onPressed: () { Navigator.pop(context, Department.treasury); },
///   child: const Text('Treasury department'),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [SimpleMyDialog], for a MyDialog in which to use this widget.
///  * [showMyDialog], which actually displays the MyDialog and returns its result.
///  * [FlatButton], which are commonly used as actions in other kinds of
///    MyDialogs, such as [AlertMyDialog]s.
///  * <https://material.io/design/components/MyDialogs.html#simple-MyDialog>
class SimpleMyDialogOption extends StatelessWidget {
  /// Creates an option for a [SimpleMyDialog].
  const SimpleMyDialogOption({
    Key key,
    this.onPressed,
    this.child,
  }) : super(key: key);

  /// The callback that is called when this option is selected.
  ///
  /// If this is set to null, the option cannot be selected.
  ///
  /// When used in a [SimpleMyDialog], this will typically call [Navigator.pop]
  /// with a value for [showMyDialog] to complete its future with.
  final VoidCallback onPressed;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: child,
      ),
    );
  }
}

/// A simple material design MyDialog.
///
/// A simple MyDialog offers the user a choice between several options. A simple
/// MyDialog has an optional title that is displayed above the choices.
///
/// Choices are normally represented using [SimpleMyDialogOption] widgets. If
/// other widgets are used, see [contentPadding] for notes regarding the
/// conventions for obtaining the spacing expected by Material Design.
///
/// For MyDialogs that inform the user about a situation, consider using an
/// [AlertMyDialog].
///
/// Typically passed as the child widget to [showMyDialog], which displays the
/// MyDialog.
///
/// {@tool sample}
///
/// In this example, the user is asked to select between two options. These
/// options are represented as an enum. The [showMyDialog] method here returns
/// a [Future] that completes to a value of that enum. If the user cancels
/// the MyDialog (e.g. by hitting the back button on Android, or tapping on the
/// mask behind the MyDialog) then the future completes with the null value.
///
/// The return value in this example is used as the index for a switch statement.
/// One advantage of using an enum as the return value and then using that to
/// drive a switch statement is that the analyzer will flag any switch statement
/// that doesn't mention every value in the enum.
///
/// ```dart
/// Future<void> _askedToLead() async {
///   switch (await showMyDialog<Department>(
///     context: context,
///     builder: (BuildContext context) {
///       return SimpleMyDialog(
///         title: const Text('Select assignment'),
///         children: <Widget>[
///           SimpleMyDialogOption(
///             onPressed: () { Navigator.pop(context, Department.treasury); },
///             child: const Text('Treasury department'),
///           ),
///           SimpleMyDialogOption(
///             onPressed: () { Navigator.pop(context, Department.state); },
///             child: const Text('State department'),
///           ),
///         ],
///       );
///     }
///   )) {
///     case Department.treasury:
///       // Let's go.
///       // ...
///     break;
///     case Department.state:
///       // ...
///     break;
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [SimpleMyDialogOption], which are options used in this type of MyDialog.
///  * [AlertMyDialog], for MyDialogs that have a row of buttons below the body.
///  * [MyDialog], on which [SimpleMyDialog] and [AlertMyDialog] are based.
///  * [showMyDialog], which actually displays the MyDialog and returns its result.
///  * <https://material.io/design/components/MyDialogs.html#simple-MyDialog>
class SimpleMyDialog extends StatelessWidget {
  /// Creates a simple MyDialog.
  ///
  /// Typically used in conjunction with [showMyDialog].
  ///
  /// The [titlePadding] and [contentPadding] arguments must not be null.
  const SimpleMyDialog({
    Key key,
    this.title,
    this.titlePadding = const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
    this.children,
    this.contentPadding = const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.shape,
  })  : assert(titlePadding != null),
        assert(contentPadding != null),
        super(key: key);

  /// The (optional) title of the MyDialog is displayed in a large font at the top
  /// of the MyDialog.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Padding around the title.
  ///
  /// If there is no title, no padding will be provided.
  ///
  /// By default, this provides the recommend Material Design padding of 24
  /// pixels around the left, top, and right edges of the title.
  ///
  /// See [contentPadding] for the conventions regarding padding between the
  /// [title] and the [children].
  final EdgeInsetsGeometry titlePadding;

  /// The (optional) content of the MyDialog is displayed in a
  /// [SingleChildScrollView] underneath the title.
  ///
  /// Typically a list of [SimpleMyDialogOption]s.
  final List<Widget> children;

  /// Padding around the content.
  ///
  /// By default, this is 12 pixels on the top and 16 pixels on the bottom. This
  /// is intended to be combined with children that have 24 pixels of padding on
  /// the left and right, and 8 pixels of padding on the top and bottom, so that
  /// the content ends up being indented 20 pixels from the title, 24 pixels
  /// from the bottom, and 24 pixels from the sides.
  ///
  /// The [SimpleMyDialogOption] widget uses such padding.
  ///
  /// If there is no [title], the [contentPadding] should be adjusted so that
  /// the top padding ends up being 24 pixels.
  final EdgeInsetsGeometry contentPadding;

  /// {@macro flutter.material.MyDialog.backgroundColor}
  final Color backgroundColor;

  /// {@macro flutter.material.MyDialog.elevation}
  /// {@macro flutter.material.material.elevation}
  final double elevation;

  /// The semantic label of the MyDialog used by accessibility frameworks to
  /// announce screen transitions when the MyDialog is opened and closed.
  ///
  /// If this label is not provided, a semantic label will be inferred from the
  /// [title] if it is not null.  If there is no title, the label will be taken
  /// from [MaterialLocalizations.MyDialogLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.isRouteName], for a description of how this
  ///    value is used.
  final String semanticLabel;

  /// {@macro flutter.material.MyDialog.shape}
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);

    String label = semanticLabel;
    if (title == null) {
      switch (theme.platform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
      }
    }

    Widget MyDialogChild = IntrinsicWidth(
      stepWidth: 56.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (title != null)
                ? Padding(
                    padding: titlePadding,
                    child: DefaultTextStyle(
                      style: theme.textTheme.title,
                      child: Semantics(namesRoute: true, child: title),
                    ),
                  )
                : Container(),
            (children != null)
                ? Flexible(
                    child: SingleChildScrollView(
                      padding: contentPadding,
                      child: ListBody(children: children),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );

    if (label != null)
      MyDialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: MyDialogChild,
      );
    return MyDialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      child: MyDialogChild,
    );
  }
}

Widget _buildMaterialMyDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

/// Displays a Material MyDialog above the current contents of the app, with
/// Material entrance and exit animations, modal barrier color, and modal
/// barrier behavior (MyDialog is dismissible with a tap on the barrier).
///
/// This function takes a `builder` which typically builds a [MyDialog] widget.
/// Content below the MyDialog is dimmed with a [ModalBarrier]. The widget
/// returned by the `builder` does not share a context with the location that
/// `showMyDialog` is originally called from. Use a [StatefulBuilder] or a
/// custom [StatefulWidget] if the MyDialog needs to update dynamically.
///
/// The `child` argument is deprecated, and should be replaced with `builder`.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the MyDialog. It is only used when the method is called. Its corresponding
/// widget can be safely removed from the tree before the MyDialog is closed.
///
/// The `useRootNavigator` argument is used to determine whether to push the
/// MyDialog to the [Navigator] furthest from or nearest to the given `context`.
/// By default, `useRootNavigator` is `true` and the MyDialog route created by
/// this method is pushed to the root navigator.
///
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// MyDialog rather than just `Navigator.pop(context, result)`.
///
/// Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the MyDialog was closed.
///
/// See also:
///
///  * [AlertMyDialog], for MyDialogs that have a row of buttons below a body.
///  * [SimpleMyDialog], which handles the scrolling of the contents and does
///    not show buttons below its body.
///  * [MyDialog], on which [SimpleMyDialog] and [AlertMyDialog] are based.
///  * [showCupertinoMyDialog], which displays an iOS-style MyDialog.
///  * [showGeneralMyDialog], which allows for customization of the MyDialog popup.
///  * <https://material.io/design/components/MyDialogs.html>
Future<T> showMyDialog<T>({
  @required
      BuildContext context,
  bool barrierDismissible = true,
  @Deprecated(
      'Instead of using the "child" argument, return the child from a closure '
      'provided to the "builder" argument. This will ensure that the BuildContext '
      'is appropriate for widgets built in the MyDialog. '
      'This feature was deprecated after v0.2.3.')
      Widget child,
  WidgetBuilder builder,
  bool useRootNavigator = true,
}) {
  assert(child == null || builder == null);
  assert(useRootNavigator != null);
  assert(debugCheckHasMaterialLocalizations(context));

  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = child ?? Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialMyDialogTransitions,
    useRootNavigator: useRootNavigator,
  );
}
