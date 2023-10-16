import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../circles_helper/screen_helper_cubit/screens_cubit.dart';
import '../../config/routes/route_constants.dart';
import '../../info_helper/loading_view.dart';
import '../../models/ModelProvider.dart';
import '../loan_creation_bloc/loan_creation_bloc/loan_creation_bloc.dart';
import 'create_customer_bloc/create_customer_bloc.dart';

class CreateCustomerView extends StatefulWidget {
  final bool isNewLoan;
  const CreateCustomerView({
    super.key,
    required this.isNewLoan,
  });

  @override
  State<CreateCustomerView> createState() => _CreateCustomerViewState();
}

class _CreateCustomerViewState extends State<CreateCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final key = GlobalKey();
  CityDetails? city;

  TextEditingController uidController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController loanIdentityController = TextEditingController();

  @override
  void dispose() {
    _formKey.currentState?.reset();
    uidController.dispose();
    nameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocBuilder<CreateCustomerBloc, CreateCustomerState>(
          builder: (context, state) {
            if (state is LoadingCircleCitiesState) {
              return const LoadingView();
            } else if (state is LoadedCircleCitiesState) {
              loanIdentityController.text =
                  widget.isNewLoan ? state.loanIdentity : '';
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: _form(),
                    ),
                  ],
                ),
              );
            }
            return const Text('Something went wrong');
          },
        ),
      ),
    );
  }

  Widget _form() {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScreensCubit, ScreensState>(
          listener: (context, state) {
            if (state == ScreensState.loanCreation) {
              GoRouter.of(context).pushReplacementNamed(
                RouteConstants.loanCreation,
                extra: widget.isNewLoan,
              );
            } else if (state == ScreensState.citiesView) {
              GoRouter.of(context).pushNamed(RouteConstants.citiesView);
            }
          },
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            _identityField(),
            const SizedBox(height: 8.0),
            _nameField(),
            const SizedBox(height: 8.0),
            _mobileNumberField(),
            const SizedBox(height: 8.0),
            _addressField(),
            const SizedBox(height: 8.0),
            _loanIdentity(),
            const SizedBox(height: 8.0),
            _citysListDropDown(),
            const SizedBox(height: 32.0),
            _submitBtn(),
          ],
        ),
      ),
    );
  }

  Widget _identityField() {
    return BlocBuilder<CreateCustomerBloc, CreateCustomerState>(
      builder: (context, state) {
        if (state is LoadedCircleCitiesState) {
          final customers = state.existingCustomers;
          return TextFormField(
            key: key,
            maxLength: 12,
            smartDashesType: SmartDashesType.enabled,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: uidController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              isDense: true,
              icon: const Icon(Icons.badge),
              labelText: AppLocalizations.of(context)!.identityField('label'),
              hintText: AppLocalizations.of(context)!.identityField('hint'),
            ),
            validator: (value) {
              if (value == null || value.length < 12) {
                return AppLocalizations.of(context)!.identityField('error');
              } else if (customers
                  .any((customer) => customer.uId == value.trim())) {
                return AppLocalizations.of(context)!
                    .identityField('alreadyExists');
              }
              return null;
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _nameField() {
    return TextFormField(
      maxLength: 30,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      controller: nameController,
      decoration: InputDecoration(
          isDense: true,
          icon: const Icon(Icons.person),
          labelText: AppLocalizations.of(context)!.nameField('label'),
          hintText: AppLocalizations.of(context)!.nameField('hint')),
      validator: (value) {
        if (value == null || value.length < 3) {
          return AppLocalizations.of(context)!.nameField('error');
        }
        return null;
      },
    );
  }

  Widget _mobileNumberField() {
    return TextFormField(
      maxLength: 10,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      controller: mobileNumberController,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
          isDense: true,
          icon: const Icon(Icons.phone),
          prefix: const Text('+91 '),
          labelText: AppLocalizations.of(context)!.mobileNumberField('label'),
          hintText: AppLocalizations.of(context)!.mobileNumberField('hint')),
      validator: (value) {
        RegExp regex = RegExp(r'^[5-9]\d{9}$');
        if (!regex.hasMatch('$value')) {
          return AppLocalizations.of(context)!.mobileNumberField('error');
        } else {
          return null;
        }
      },
    );
  }

  Widget _addressField() {
    return TextFormField(
      maxLength: 50,
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.next,
      controller: addressController,
      decoration: InputDecoration(
          isDense: true,
          icon: const Icon(Icons.place),
          labelText: AppLocalizations.of(context)!.addressField('label'),
          hintText: AppLocalizations.of(context)!.addressField('hint')),
      validator: (value) {
        if (value == null || value.length < 3) {
          return AppLocalizations.of(context)!.addressField('error');
        }
        return null;
      },
    );
  }

  Widget _loanIdentity() {
    return TextFormField(
      controller: loanIdentityController,
      maxLength: 5,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid loan identity';
        }
        return null;
      },
      decoration: InputDecoration(
        isDense: true,
        icon: const Icon(Icons.menu_book),
        labelText: AppLocalizations.of(context)!.loanIdField('label'),
        hintText: AppLocalizations.of(context)!.loanIdField('hint'),
      ),
    );
  }

  void _onCitySelected({required City newCity}) {
    setState(() {
      city = CityDetails(
        name: newCity.name,
        circleID: newCity.circleID,
        id: newCity.id,
      );
    });
  }

  Widget _citysListDropDown() {
    return BlocBuilder<CreateCustomerBloc, CreateCustomerState>(
      builder: (context, state) {
        if (state is LoadedCircleCitiesState) {
          final cities = <City>[
            ...state.cities.map((e) => e.copyWith(name: e.name.toUpperCase()))
          ];
          return DropdownButtonFormField(
            menuMaxHeight: 400,
            decoration: InputDecoration(
              isDense: true,
              icon: const Icon(Icons.location_city),
              labelText: AppLocalizations.of(context)!.selectCity,
            ),
            value: cities[0],
            items: cities
                .map((city) =>
                    DropdownMenuItem(value: city, child: Text(city.name)))
                .toList(),
            onChanged: (value) {
              _onCitySelected(newCity: value as City);
            },
            validator: (value) {
              city ??= CityDetails(
                name: state.cities[0].name,
                circleID: state.cities[0].circleID,
                id: state.cities[0].id,
              );
              return null;
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _submitBtn() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // * call LoanCreationResetEvent to reset the loan creation state
          BlocProvider.of<LoanCreationBloc>(context)
              .add(LoanCreationInitialEvent());
          // *on submission first try to save Customer
          try {
            BlocProvider.of<ScreensCubit>(context).showCustomerLoanCreation(
              uId: uidController.text.trim(),
              name: nameController.text.trim(),
              phone: mobileNumberController.text.trim(),
              address: addressController.text.trim(),
              loanIdentity: loanIdentityController.text.trim(),
              city: city!,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Something went wrong, please try again'),
              ),
            );
          }
        }
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 350),
        );
      },
      child: Text(
        AppLocalizations.of(context)!.submit,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
