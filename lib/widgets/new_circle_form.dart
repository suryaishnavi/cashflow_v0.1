import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../3_circle_screen/create_new_circle/create_circle_bloc.dart';
import '../info_helper/form_submission_status.dart';
import '../models/WeekDay.dart';
import 'custom_eleveted_button.dart';
import 'custom_outlined_button.dart';

class NewCircleForm extends StatefulWidget {
  const NewCircleForm({super.key});

  @override
  State<NewCircleForm> createState() => _NewCircleFormState();
}

class _NewCircleFormState extends State<NewCircleForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _circleNameForm(),
          const SizedBox(height: 16),
          _weekdayDropDown(context),
          const SizedBox(height: 32),
          _circleDetailsSubmit(),
          const SizedBox(height: 16),
          _dismissModalBottomSheet(),
        ],
      ),
    );
  }

  Widget _circleNameForm() {
    return BlocBuilder<CreateCircleBloc, CreateCircleState>(
      builder: (context, state) {
        return TextFormField(
          autofocus: true,
          maxLength: 30,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.circleNameHint,
            label: Text(AppLocalizations.of(context)!.circleName),
          ),
          keyboardType: TextInputType.text,
          validator: (value) => state.isValidCircleName
              ? null
              : AppLocalizations.of(context)!.circleNameError,
          onChanged: (value) => context.read<CreateCircleBloc>().add(
                CircleNameChanged(circleName: value),
              ),
        );
      },
    );
  }

  Widget _weekdayDropDown(BuildContext context) {
    return BlocBuilder<CreateCircleBloc, CreateCircleState>(
      builder: (context, state) {
        return DropdownButtonFormField(
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.circleType),
          ),
          value: state.selectedDay,
          items: WeekDay.values.map((day) {
            return DropdownMenuItem(
              value: day,
              child: Text(
                AppLocalizations.of(context)!
                    .getWeekDay(day.toString().split('.').last),
              ),
            );
          }).toList(),
          onChanged: (newValue) => context.read<CreateCircleBloc>().add(
                DayChanged(selectedDay: newValue as WeekDay),
              ),
        );
      },
    );
  }

  Widget _circleDetailsSubmit() {
    return BlocBuilder<CreateCircleBloc, CreateCircleState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<CreateCircleBloc>()
                        .add(const CircleSubmission());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(AppLocalizations.of(context)!.createCircleBtn,
                    style: const TextStyle(fontSize: 16)),
              );
      },
    );
  }

  Widget _dismissModalBottomSheet() {
    return CustomOutlinedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(AppLocalizations.of(context)!.cancel,
          style: const TextStyle(fontSize: 16)),
    );
  }
}
