import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../info_helper/loading_view.dart';
import '../../widgets/custom_eleveted_button.dart';
import '../../widgets/custom_outlined_button.dart';
import 'bloc/cities_bloc.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allCities),
        actions: [
          IconButton(
            onPressed: () {
              _showAddCityModalBottomSheet(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<CitiesBloc, CitiesState>(
        builder: (context, state) {
          if (state is CitiesLoadingState) {
            return const LoadingView();
          } else if (state is CitiesLoadedState) {
            final cities = state.cities;
            if (cities.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noCities),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child:
                  // SingleChildScrollView(
                  //   child: InkWell(
                  //     onTap: () {
                  //       Clipboard.setData(
                  //         ClipboardData(
                  //           text: '$cities',
                  //         ),
                  //       );
                  //     },
                  //     child: Text('Cities: $cities'),
                  //   ),
                  // )

                  ListView.separated(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors
                          .primaries[index % Colors.primaries.length][100],
                      child: Text(
                        '${index + 1}',
                      ),
                    ),
                    title: Text(city.name.toUpperCase(),
                        style: const TextStyle(fontSize: 16)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            );
          }
          return Center(
            child: Text(AppLocalizations.of(context)!.noCities),
          );
        },
      ),
    );
  }

  void _showAddCityModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: const AddNewCity(),
        );
      },
    );
  }
}

class AddNewCity extends StatefulWidget {
  const AddNewCity({super.key});

  @override
  State<AddNewCity> createState() => _AddNewCityState();
}

class _AddNewCityState extends State<AddNewCity> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.addNewCity,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            maxLength: 30,
            controller: _controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.cityName,
              hintText: AppLocalizations.of(context)!.cityNameHint,
            ),
            validator: (value) {
              if (value == null || value.length < 3) {
                return AppLocalizations.of(context)!.cityNameError;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<CitiesBloc>().add(
                      CreateNewCity(name: _controller.text),
                    );
                Navigator.of(context).pop();
              }
            },
            child: Text(AppLocalizations.of(context)!.addNewCity,
                style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),
          CustomOutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: const TextStyle(fontSize: 16)))
        ],
      ),
    );
  }
}
