import 'package:unidwell_finder/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.value,
      required this.items,
      this.validator,
      this.hintText,
      this.onChanged,
      this.radius,
      this.color,
      this.onSaved,
      this.label,
      this.prefixIcon,
      this.iconData});

  final dynamic value;
  final List<DropdownMenuItem> items;
  final String? Function(dynamic)? validator;
  final String? hintText;
  final String? label;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? onSaved;
  final double? radius;
  final Color? color;
  final IconData? iconData;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);

    return DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
      borderRadius: BorderRadius.circular(5),
      style: styles.body(color: Theme.of(context).textTheme.labelLarge!.color),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(
            color: color ?? Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(
            color: color ?? Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
        fillColor: Colors.transparent,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: BorderSide(
              color: color ?? Theme.of(context).colorScheme.secondary),
        ),
        prefixIconColor: Theme.of(context).colorScheme.secondary,
        suffixIconColor: Theme.of(context).colorScheme.secondary,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Theme.of(context).colorScheme.secondary,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        labelStyle: styles.body(),
        labelText: label,
        hintText: hintText,
        focusColor: Theme.of(context).colorScheme.secondary,
        iconColor: Theme.of(context).colorScheme.secondary,
        hintStyle: styles.body(),
      ),
      onChanged: onChanged,
      onSaved: onSaved,
      items: items,
      validator: validator,
      value: value,
      isExpanded: true,
      icon: Icon(
        iconData ?? Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ));
  }
}
