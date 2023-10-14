import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../6_reports_gen_screen/cubit/report_cubit.dart';
import '../models/Circle.dart';

class GenerateReportForm extends StatefulWidget {
  final List<Circle> circles;
  const GenerateReportForm({super.key, required this.circles});

  @override
  State<GenerateReportForm> createState() => _GenerateReportFormState();
}

class _GenerateReportFormState extends State<GenerateReportForm> {
  final _formKey = GlobalKey<FormState>();
  Circle? _selectedCircle; // ? this is the selected circle
  // i want only today's date without time

  DateTime date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return _form(circles: widget.circles);
  }

  Widget _form({required List<Circle> circles}) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {},
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _selectCircleAndDate(circles: circles),
              const SizedBox(height: 16.0),
              _selectDate(),
              const SizedBox(height: 32.0),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectCircleAndDate({required List<Circle> circles}) {
    List<DropdownMenuItem<Circle>> buildDropDownMenuItem(
        {required List<Circle> dropCircles}) {
      List<DropdownMenuItem<Circle>> items = [];
      for (Circle circle in circles) {
        items.add(
          DropdownMenuItem(
            value: circle,
            child: Text(circle.circleName[0].toUpperCase() +
                circle.circleName.substring(1).toLowerCase()),
          ),
        );
      }
      return items;
    }

    return DropdownButtonFormField(
      items: buildDropDownMenuItem(dropCircles: circles),
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _selectedCircle = value;
        });
      },
      hint: Text(AppLocalizations.of(context)!.selectCircle),
      decoration: InputDecoration(
        icon: const Icon(Icons.supervised_user_circle),
        label: Text(AppLocalizations.of(context)!.circle),
      ),
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)!.selectCircle;
        }
        return null;
      },
    );
  }

  Widget _selectDate() {
    return TextFormField(
      decoration: InputDecoration(
        icon: const Icon(Icons.calendar_today),
        labelText: AppLocalizations.of(context)!.date,
      ),
      onTap: () async {
        DateTime? newSelectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2021),
          lastDate: DateTime(2050),
        );
        if (newSelectedDate != null) {
          setState(() {
            date = newSelectedDate;
          });
        }
      },
      readOnly: true,
      controller: TextEditingController(
        text: '${date.day}/${date.month}/${date.year}',
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          BlocProvider.of<ReportCubit>(context).storeCredentials(
            circle: _selectedCircle!,
            date: date,
          );
        }
      },
      child: Text(
        AppLocalizations.of(context)!.generateReport,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
