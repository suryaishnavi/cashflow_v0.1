import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/ModelProvider.dart';
import '../4_customer_screen/customer_bloc/customer_bloc.dart';

class FilterCustomers extends StatelessWidget {
  const FilterCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoadingState) {
          return const SizedBox.shrink();
        } else if (state is CustomerLoadedState) {
          return DropdownButtonFormField(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            menuMaxHeight: 400,
            decoration: InputDecoration(
                isDense: true,
                labelText: AppLocalizations.of(context)!.sortCustomer,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
            itemHeight: 50,
            elevation: 4,
            value: state.selectedCity,
            items: state.cities.map(
              (city) {
                // Calculate the number of customers for each city
                int customerCount = city.id.isNotEmpty
                    ? state.customers
                        .where((customer) => customer.city.id == city.id)
                        .length
                    : state.customers.length;

                return DropdownMenuItem(
                  value: city,
                  child: Text('${city.name} ($customerCount)'),
                );
              },
            ).toList(),
            onChanged: (value) {
              context.read<CustomerBloc>().add(
                    SelectedCityCustomersEvent(city: value as City),
                  );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
