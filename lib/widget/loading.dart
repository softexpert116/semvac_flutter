import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../config/color.dart';

/// For Loading Widget
Widget kLoadingWidget(context) => Center(
      child: SpinKitFadingCube(
        color: titleColor,
        size: 30.0,
      ),
    );
Widget kLoadingWaveWidget(context, Color color) => Center(
      child: SpinKitWave(
        color: color,
        size: 50.0,
      ),
    );
