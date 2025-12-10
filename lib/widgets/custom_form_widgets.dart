import 'package:flutter/material.dart';
import 'package:cervical_cancer_flutter_app/constants.dart';

// نمط حقل الإدخال المخصص
InputDecoration _customInputDecoration({required String labelText}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: kDarkColor, fontWeight: FontWeight.w500, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
    ),
    fillColor: Colors.white,
    filled: true,
  );
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? initialValue;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: _customInputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: kTextColor),
    );
  }
}

class CustomDropdownFormField extends StatelessWidget {
  final String label;
  final dynamic value;
  final Map<String, String> options;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;

  const CustomDropdownFormField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: _customInputDecoration(labelText: label),
      value: value,
      items: options.entries.map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value, style: const TextStyle(fontSize: 14, color: kTextColor)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: kTextColor),
      isExpanded: true,
    );
  }
}

class FormSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const FormSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Row(
        children: [
          Icon(icon, color: kDarkColor, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: isPrimary
            ? const LinearGradient(
                colors: [kPrimaryColor, kSecondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPrimary ? null : kDarkColor, // لون ثانوي لزر ثانوي
      ),
      child: MaterialButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
