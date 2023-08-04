import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frame/widget/widget.dart';

/// The height of the toolbar component of the [Toolbar].
const double ToolBarHeight = 48.0;

const bool ToolBartTitleCenter = true;

const Color defualtBackgroundColor = Colors.white;

///
/// app bar的them
///
final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    // backwardsCompatibility: false,
    centerTitle: true,
    systemOverlayStyle:
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18.0),
    elevation: 0,
    shadowColor: Colors.transparent);
