import 'package:flutter/material.dart';

const int extraLargeBreakpoint = 1280;
const int largeBreakpoint = 1024;
const int mediumBreakpoint = 768;
const int smallBreakpoint = 640;

extension Responsive on BuildContext {
  T responsive<T>(
    T defaultVal, {
    T? sm,
    T? md,
    T? lg,
    T? xl,
  }) {
    final screenWidth = MediaQuery.of(this).size.width;

    if (screenWidth >= extraLargeBreakpoint) {
      return xl ?? lg ?? md ?? sm ?? defaultVal;
    } else if (screenWidth >= largeBreakpoint) {
      return lg ?? md ?? sm ?? defaultVal;
    } else if (screenWidth >= mediumBreakpoint) {
      return md ?? sm ?? defaultVal;
    } else if (screenWidth >= smallBreakpoint) {
      return sm ?? defaultVal;
    } else {
      return defaultVal;
    }
  }
}
