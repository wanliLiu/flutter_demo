import 'package:flutter/material.dart';
import 'package:flutter_frame/app.dart';

///
///
///
///
class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({Key? key, this.color, this.onPressed})
      : super(key: key);
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      color: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}

class _AppBarLeading extends StatelessWidget {
  const _AppBarLeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget leading = Container();

    if (canPop) {
      leading = useCloseButton
          ? const CloseButton()
          : const AppBarBackButton(
              color: Colors.black,
            );
    }

    return leading;
  }
}

///
///
/// 项目用的顶部AppBar
///
///
class Toolbar extends AppBar {
  Toolbar(
      {String? title,
      List<Widget>? actions,
      bool? centerTitle,
      Color? backgroundColor})
      : super(
            title: Text(title ?? ""),
            actions: actions,
            centerTitle: centerTitle,
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: _AppBarLeading(),
            //不要阴影
            toolbarHeight: ToolBarHeight);
}
