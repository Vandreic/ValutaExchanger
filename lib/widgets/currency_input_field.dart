import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valuta_exchanger/services/currency_service.dart';

/// Reusable text field for entering a currency amount.
/// Only allows numbers and one decimal point - blocks letters and other chars.
class CurrencyInputField extends StatelessWidget {
  /// The controller that holds the text - shared with parent for updates
  final TextEditingController controller;

  /// Called when the user types - receives the currency and new value
  final void Function(Currency currency, String value) onChanged;

  /// Shown as the label above/beside the field (e.g. "DKK: 100.00 kr.")
  final String labelText;

  /// Which currency this field represents - used when calling onChanged
  final Currency currency;

  const CurrencyInputField({
    super.key,
    required this.currency,
    required this.controller,
    required this.onChanged,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        // Only allow digits, optional minus, one decimal point
        // Regex: -? = optional minus, \d* = digits, \.? = optional dot, \d* = more digits
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'-?\d*\.?\d*')),
        ],
        onChanged: (value) => onChanged(currency, value),
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
