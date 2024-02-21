import 'package:flutter/material.dart';
import 'package:agl_passcode/src/secret_config.dart';

class SecretsConfig {
  const SecretsConfig(
      {double? spacing,
      this.padding = const EdgeInsets.only(top: 20, bottom: 20),
      this.secretConfig})
      : spacing = spacing ?? 12;

  /// Space between secret widgets.
  final double spacing;

  /// Padding of secrets widget.
  final EdgeInsetsGeometry padding;

  /// Config for secrets.
  final SecretConfig? secretConfig;

  /// Copies a [SecretsConfig] with new values.
  SecretsConfig copyWith({
    double? spacing,
    EdgeInsetsGeometry? padding,
    SecretConfig? secretConfig,
  }) {
    return SecretsConfig(
      spacing: spacing ?? this.spacing,
      padding: padding ?? this.padding,
      secretConfig: secretConfig ?? this.secretConfig,
    );
  }
}
