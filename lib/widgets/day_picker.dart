import 'package:doriapp/utils/functions.dart';
import 'package:flutter/material.dart';

class DayPickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final bool validate;

  const DayPickerWidget({
    super.key,
    required this.onDateSelected,
    required this.validate,
  });

  @override
  State<DayPickerWidget> createState() => _DayPickerWidgetState();
}

class _DayPickerWidgetState extends State<DayPickerWidget> {
  late bool error;
  DateTime? pickedDate;

  @override
  void initState() {
    super.initState();
    error = widget.validate;
  }

  @override
  void didUpdateWidget(covariant DayPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    reload();
  }

  reload() {
    setState(() {
      error = widget.validate;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    pickedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      locale: const Locale('es', ''),
      confirmText: 'Aceptar',
    );

    if (pickedDate != null) {
      setState(() {
        error = false;
        widget.onDateSelected(pickedDate!);
      });
    }
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString();
    final String month = CustomFunctions.getMonthName(date.month);
    final String year = date.year.toString();
    return '$day de $month del $year';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: TextField(
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          errorText: (error) ? "Fecha de nacimiento requerida" : null,
          hintText:
              (pickedDate != null) ? _formatDate(pickedDate!) : 'Fecha de nacimiento',
          suffixIcon: const Icon(Icons.calendar_today),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
