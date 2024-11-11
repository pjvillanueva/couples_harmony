import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String? leadingIcon;
  final String hintText;
  final String? labelText;

  final bool isEnable;
  final bool? obscureText;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FocusNode? node;
  final Function? onFieldSubmit;
  final ValueChanged<String?>? onChange;
  final TextDirection? direction;
  final TextInputAction? inputAction;
  final bool? readOnly, isFilled;
  final Function()? onTap;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final double? suffixPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final double borderRadius;

  final bool isDense;
  final bool showError;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;

  const CustomTextFormField(
      {super.key,
      this.leadingIcon = "",
      this.labelText,
      this.hintText = "",
      this.obscureText = false,
      this.isEnable = true,
      this.inputType,
      this.isFilled = false,
      this.controller,
      this.node,
      this.maxLength,
      this.validator,
      this.onFieldSubmit,
      this.onChange,
      this.direction,
      this.inputAction,
      this.readOnly = false,
      this.onTap,
      this.autoValidateMode,
      this.suffixWidget,
      this.suffixPadding = 0.0,
      this.isDense = false,
      this.showError = true,
      this.prefixWidget,
      this.inputFormatters,
      this.borderRadius = 12.0,
      this.border,
      this.enabledBorder,
      this.disabledBorder,
      this.focusedBorder,
      this.focusedErrorBorder});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    InputDecorationTheme inputDecorationTheme =
        Theme.of(context).inputDecorationTheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return TextFormField(
      maxLength: widget.maxLength,
      keyboardType: widget.inputType ?? TextInputType.name,
      obscureText: widget.obscureText ?? false,
      controller: widget.controller,
      onTap: widget.onTap,
      style: textTheme.bodyMedium,
      textInputAction: widget.inputAction,
      autovalidateMode:
          widget.autoValidateMode ?? AutovalidateMode.onUserInteraction,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 14),
          labelText: widget.labelText,
          alignLabelWithHint: false,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          fillColor:
              widget.isEnable ? inputDecorationTheme.fillColor : Colors.white,
          filled: inputDecorationTheme.filled,
          isDense: inputDecorationTheme.isDense,
          enabled: widget.isEnable,
          errorStyle: inputDecorationTheme.errorStyle,
          suffixIcon: widget.suffixWidget == null
              ? null
              : Padding(
                  padding: EdgeInsets.all(widget.suffixPadding!),
                  child: widget.suffixWidget),
          prefixIcon: widget.leadingIcon!.isNotEmpty
              ? const Padding(
                  padding: EdgeInsets.all(15.0), child: Icon(Icons.person))
              : widget.prefixWidget,
          contentPadding: inputDecorationTheme.contentPadding,
          border: widget.border ?? inputDecorationTheme.border,
          focusedBorder:
              widget.focusedBorder ?? inputDecorationTheme.focusedBorder,
          focusedErrorBorder: widget.focusedErrorBorder ??
              inputDecorationTheme.focusedErrorBorder,
          disabledBorder:
              widget.disabledBorder ?? inputDecorationTheme.disabledBorder,
          enabledBorder:
              widget.enabledBorder ?? inputDecorationTheme.enabledBorder,
          hintText: widget.hintText,
          hintStyle: textTheme.bodyMedium),
      enabled: widget.isEnable,
      validator: widget.validator,
      onChanged: widget.onChange,
      onSaved: (newValue) => widget.controller!.text,
    );
  }
}
