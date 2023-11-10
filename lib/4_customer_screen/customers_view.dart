import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/screen_helper_cubit/common_cubit.dart';
import '../config/routes/route_constants.dart';
import '../info_helper/loading_view.dart';
import '../models/ModelProvider.dart';
import 'create_customer_bloc/create_customer_bloc/create_customer_bloc.dart';
import 'customer_bloc/customer_bloc.dart';
import '../widgets/filter_customers.dart';
import 'loan_creation_bloc/loan_creation_bloc/loan_creation_bloc.dart';
// import 'update_loan_dialog/update_loan_dialog_cubit/update_loan_dialog_cubit.dart';
import 'update_loan_dialog/update_loan_dialog_bloc/update_loan_dialog_bloc.dart';
import 'update_loan_dialog/update_loan_view.dart';

class CustomersView extends StatelessWidget {
  const CustomersView({super.key});

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ({Color error, Color success}) getColors() {
      return (error: Colors.red, success: Colors.green);
    }

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ScreensCubit, ScreensState>(
            listener: (context, state) {
              if (state == ScreensState.customerProfileView) {
                GoRouter.of(context)
                    .pushNamed(RouteConstants.customerProfileView);
              }
            },
          ),
          // BlocListener<UpdateLoanDialogCubit, UpdateLoanDialogState>(
          //   listener: (context, state) {
          //     // take customer name from state and shorten it to 20 characters if it is more than 20 characters and add '...' at the end of the name
          //     if (state is LoanUpdatedState) {
          //       final name = state.customer.customerName.length > 20
          //           ? '${state.customer.customerName[0].toUpperCase() + state.customer.customerName.substring(1, 20).toLowerCase()}...'
          //           : state.customer.customerName[0].toUpperCase() +
          //               state.customer.customerName.substring(1).toLowerCase();
          //       _showSnackBar(
          //           context,
          //           '$name ${AppLocalizations.of(context)!.loanUpdateSuccess}',
          //           getColors().success);
          //     } else if (state is LoanUpdatedErrorState) {
          //       _showSnackBar(
          //           context,
          //           AppLocalizations.of(context)!.loanUpdateFailed,
          //           getColors().error);
          //     }
          //   },
          // ),
          BlocListener<LoanCreationBloc, LoanCreationState>(
            listener: (context, state) {
              if (state is LoanCreationSuccessState) {
                _showSnackBar(context, state.message, getColors().success);
              } else if (state is LoanCreationErrorState) {
                _showSnackBar(context, state.message, getColors().error);
              }
            },
          ),
        ],
        child: const CustomerScrollView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CreateCustomerBloc>().add(LoadCitiesEvent());
          GoRouter.of(context).pushNamed(RouteConstants.customerCreation);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

// !---CustomerScrollView---
class CustomerScrollView extends StatefulWidget {
  const CustomerScrollView({super.key});

  @override
  State<CustomerScrollView> createState() => _CustomerScrollViewState();
}

class _CustomerScrollViewState extends State<CustomerScrollView> {
  // ! ---show customer loans dialog---
  Future<void> _showCustomerLoansDialog(BuildContext context,
      {required Customer customer}) async {
    await showDialog(
      context: context,
      builder: (_) {
        return Dialog.fullscreen(
          child: BlocBuilder<UpdateLoanDialogBloc, UpdateLoanDialogState>(
            builder: (context, state) {
              switch (state) {
                case CreatedChatViewState():
                  return UpdateLoanView(
                    state: state,
                    customer: customer,
                  );
                case LoansEmptyStateEvent():
                  return MarkCustomerInactive(customer: customer);
                case UpdateLoanDialogInitialState():
                case UpdateLoanDialogLoadingState():
                return Column(
                    children: [
                      AppBar(
                        title: Text(AppLocalizations.of(context)!.wait),
                        leading: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  );
                case UpdateLoanDialogFailureState():
                return Column(
                    children: [
                      AppBar(
                        title: Text(AppLocalizations.of(context)!.errorMsg),
                        leading: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.errorMsg),
                        ],
                      ),
                    ],
                  );
              }
            },
          ),
        );
      },
    );
  }

  void showSelectedCustomer(Customer selectedCustomer) {
    _showCustomerLoansDialog(context, customer: selectedCustomer);
  }

  void goHiddenCustomerProfile(Customer selectedCustomer) {
    context.read<CustomerBloc>().add(
          ShowCustomerProfileEvent(customer: selectedCustomer),
        );
  }

  final PageStorageKey _pageStorageKey = const PageStorageKey('my_silver_list');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoadingState) {
          return const LoadingView();
        } else if (state is CustomerLoadedState) {
          final List<Customer> customers = state.filteredCustomers;
          //! ---custom scroll view
          return CustomScrollView(
            key: _pageStorageKey,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[
              SliverAppBar(
                stretch: true,
                expandedHeight: 120,
                floating: true,
                actions: [
                  IconButton(
                    onPressed: () async {
                      final selectedCustomer = await showSearch(
                        context: context,
                        delegate: CustomerSearchDelegate(
                          customerBloc: context.read<CustomerBloc>(),
                        ),
                      );
                      if (selectedCustomer != null &&
                          selectedCustomer is Customer) {
                        if (selectedCustomer.customerStatus ==
                            CustomerStatus.CLOSED) {
                          goHiddenCustomerProfile(selectedCustomer);
                        } else {
                          showSelectedCustomer(selectedCustomer);
                        }
                      }
                    },
                    icon: const Icon(Icons.search, size: 28.0),
                  ),
                ],
                title: const Text('Customers'),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(70.0),
                  child: FilterCustomers(),
                ),
              ),
              sliverList(context: context, customers: customers)
            ],
          );
        }
        return Center(
          child: Text(AppLocalizations.of(context)!.errorMsg),
        );
      },
    );
  }

  SliverList sliverList({
    required BuildContext context,
    required List<Customer> customers,
  }) {
    if (customers.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.noCustomers,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          },
          childCount: 1,
        ),
      );
    }
    return SliverList.separated(
      key: _pageStorageKey,
      itemBuilder: (BuildContext context, int index) {
        Customer customer = customers[index];
        return CustomerListTile(
          customer: customer,
          index: index,
          function: () {
            // remove focus from search field
            FocusScope.of(context).unfocus();
            _showCustomerLoansDialog(context, customer: customer);
          },
        );
      },
      itemCount: customers.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 4.0),
    );
  }
}

// !---CustomerListTile---

class CustomerListTile extends StatelessWidget {
  final Customer customer;
  final int index;
  final Function function;
  const CustomerListTile({
    super.key,
    required this.customer,
    required this.index,
    required this.function,
  });

  ({MaterialColor color, String text, bool isNewCustomer}) isNewCustomer() {
    DateTime today = DateTime.parse('${DateTime.now()}'.split(' ')[0]);
    if (customer.newLoanAddedDate != null) {
      DateTime loanCreatedOn = customer.newLoanAddedDate!.getDateTime();
      final DateTime createdOn =
          DateTime.parse(loanCreatedOn.toString().split(' ')[0]);
      return (
        color: Colors.pink,
        text: 'New Loan',
        isNewCustomer: today == createdOn
      );
    } else {
      DateTime customerCreatedOn = customer.dateOfCreation.getDateTime();
      final DateTime createdOn =
          DateTime.parse(customerCreatedOn.toString().split(' ')[0]);
      return (
        color: Colors.blue,
        text: 'New Customer',
        isNewCustomer: today == createdOn
      );
    }
  }

  bool isCLUpdTdy() {
    if (customer.paymentInfo?.paidDate != null) {
      DateTime today = DateTime.parse('${DateTime.now()}'.split(' ')[0]);
      DateTime loanUpdatedOn = customer.paymentInfo!.paidDate.getDateTime();
      final DateTime updatedOn =
          DateTime.parse(loanUpdatedOn.toString().split(' ')[0]);
      return today == updatedOn;
    }
    return false;
  }

// get amount paid today
  ({Color color, String text}) amountPaid() {
    if (customer.paymentInfo?.paidAmount != null) {
      // get emiamount
      final int emiAmount = customer.paymentInfo!.emiAmount;
      // get paid amount
      final int paidAmount = customer.paymentInfo!.paidAmount;
      // if paid amount is less than emi amount then return text : 'Paid: $paidAmount', color: Colors.yellow else return text : 'Paid: $paidAmount', color: Colors.green
      if (paidAmount < emiAmount) {
        return (
          text: '\u{20B9}$paidAmount / \u{20B9}$emiAmount',
          color: Colors.orange
        );
      } else {
        return (
          text: '\u{20B9}$paidAmount / \u{20B9}$emiAmount',
          color: Colors.green
        );
      }
    }
    return (text: 'Updated', color: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      largeSize: 18,
      isLabelVisible: isCLUpdTdy() || isNewCustomer().isNewCustomer,
      label: Text(isCLUpdTdy()
          ? amountPaid().text
          : isNewCustomer().isNewCustomer
              ? isNewCustomer().text
              : 'Updated'),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      textColor: isCLUpdTdy()
          ? amountPaid().color
          : isNewCustomer().isNewCustomer
              ? isNewCustomer().color
              : Colors.black,
      backgroundColor: isCLUpdTdy()
          ? amountPaid().color.withOpacity(0.1)
          : isNewCustomer().isNewCustomer
              ? isNewCustomer().color.withOpacity(0.1)
              : Colors.transparent,
      offset: const Offset(-100, 50),
      alignment: Alignment.topRight,
      child: ListTile(
        minVerticalPadding: 16.0,
        onTap: () async {
          context.read<UpdateLoanDialogBloc>().add(
                GetLoanDataEvent(customer: customer),
              );
          await Future.delayed(const Duration(milliseconds: 200), () {
            function();
          });
        },
        tileColor: isCLUpdTdy()
            ? amountPaid().color.withOpacity(0.1)
            : isNewCustomer().isNewCustomer
                ? isNewCustomer().color.withOpacity(0.1)
                : Colors.white,
        isThreeLine: true,
        trailing: CustomerMenuOptions(customer: customer),
        title: Row(
          children: [
            colorDot(),
            const SizedBox(width: 16),
            Text(
              customer.customerName.length > 25
                  ? '${customer.customerName[0].toUpperCase() + customer.customerName.substring(1, 25).toLowerCase()}...'
                  : customer.customerName[0].toUpperCase() +
                      customer.customerName.substring(1).toLowerCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        subtitle: Wrap(
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 4.0),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: customer.phone.substring(3),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.black54),
                    children: [
                      TextSpan(
                        text: customer.city.name.length > 15
                            ? ' - ${customer.city.name.substring(0, 15).toUpperCase()}...'
                            : ' - ${customer.city.name}'.toUpperCase(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.bookmark,
                  size: 16.0,
                  color: isCLUpdTdy()
                      ? amountPaid().color
                      : isNewCustomer().isNewCustomer
                          ? isNewCustomer().color
                          : Colors.yellow[900],
                ),
                const SizedBox(width: 4.0),
                Text(
                  '${customer.loanIdentity}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isCLUpdTdy()
                        ? amountPaid().color
                        : isNewCustomer().isNewCustomer
                            ? isNewCustomer().color
                            : Colors.yellow[900],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget colorDot() {
    return Container(
      width: 10, // Adjust the size of the container as needed
      height: 10,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCLUpdTdy()
            ? amountPaid().color.withOpacity(.2)
            : isNewCustomer().isNewCustomer
                ? isNewCustomer().color.withOpacity(.2)
                : Colors.black.withOpacity(.2),
      ),
      child: Container(
        width: 6, // Adjust the size of the container as needed
        height: 6,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCLUpdTdy()
              ? amountPaid().color.withOpacity(0.5)
              : isNewCustomer().isNewCustomer
                  ? isNewCustomer().color.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}

// ! ---Customer Options popup menu---

enum MenuItem { itemOne, itemTwo, itemThree }

class CustomerMenuOptions extends StatefulWidget {
  final Customer customer;
  const CustomerMenuOptions({super.key, required this.customer});

  @override
  State<CustomerMenuOptions> createState() => _CustomerMenuOptionsState();
}

class _CustomerMenuOptionsState extends State<CustomerMenuOptions> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

// Delete customer
  void _deleteCustomer() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Theme.of(context).colorScheme.error,
          title: Row(
            children: [
              Icon(Icons.dangerous, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.warning),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteOptionsTxt('delCustomerMsg'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<CustomerBloc>()
                    .add(DeleteCustomerEvent(customer: widget.customer));
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      onSelected: (value) {
        if (value == MenuItem.itemOne) {
          context
              .read<CustomerBloc>()
              .add(ShowCustomerProfileEvent(customer: widget.customer));
        } else if (value == MenuItem.itemTwo) {
          _makePhoneCall(widget.customer.phone);
        } else if (value == MenuItem.itemThree) {
          _deleteCustomer();
        }
      },
      icon: const Icon(Icons.more_horiz),
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: MenuItem.itemOne,
          child: Text(AppLocalizations.of(context)!.showCustomerProfile),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: MenuItem.itemTwo,
          child: Text(AppLocalizations.of(context)!.call),
        ),
        const PopupMenuDivider(),
        // delete customer item
        PopupMenuItem(
          value: MenuItem.itemThree,
          child: Text(
            AppLocalizations.of(context)!.deleteOptionsTxt('delCustomer'),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

// ! ---Search Delegate---
class CustomerSearchDelegate extends SearchDelegate {
  final CustomerBloc customerBloc;
  CustomerSearchDelegate({required this.customerBloc})
      : super(
          searchFieldLabel: 'Search by name, phone or ID',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          searchFieldStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          }
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Customer> result = [];

    final List<Customer> customers = (customerBloc.state is CustomerLoadedState)
        ? (customerBloc.state as CustomerLoadedState).customers
        : [];

    for (var customer in customers) {
      final lowercaseQuery = query.toLowerCase();
      if (lowercaseQuery.contains(RegExp(r'[a-zA-Z]'))) {
        if (customer.customerName.toLowerCase().contains(lowercaseQuery)) {
          result.add(customer);
        } else if (customer.phone.substring(3).startsWith(lowercaseQuery) ||
            (customer.loanIdentity.contains(lowercaseQuery))) {
          result.add(customer);
        }
      }
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(result[index].customerName),
          );
        },
        itemCount: result.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoadedState) {
          final List<Customer> customers = state.customers;
          String lowercaseQuery = query.toLowerCase();
          final List<Customer> suggestionList = lowercaseQuery.isEmpty
              ? customers
              : lowercaseQuery.contains(RegExp(r'[a-zA-Z]'))
                  ? customers
                      .where((element) => element.customerName
                          .toLowerCase()
                          .contains(lowercaseQuery))
                      .toList()
                  : customers
                      .where((element) => (element.phone
                              .substring(3)
                              .startsWith(lowercaseQuery) ||
                          (element.loanIdentity.contains(lowercaseQuery))))
                      .toList();
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  close(context, suggestionList[index]);
                },
                title: Text(
                  suggestionList[index].customerName.length > 20
                      ? '${suggestionList[index].customerName[0].toUpperCase() + suggestionList[index].customerName.substring(1, 20).toLowerCase()}...'
                      : suggestionList[index].customerName[0].toUpperCase() +
                          suggestionList[index]
                              .customerName
                              .substring(1)
                              .toLowerCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      suggestionList[index].phone.substring(3),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '| ID: ${suggestionList[index].loanIdentity}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              );
            },
            itemCount: suggestionList.length,
          );
        } else {
          return const Center(
            child: Text('Error'),
          );
        }
      },
    );
  }
}

class MarkCustomerInactive extends StatelessWidget {
  final Customer customer;
  const MarkCustomerInactive({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(AppLocalizations.of(context)!.noActiveLoans),
        ),
        const SizedBox(height: 32.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            AppLocalizations.of(context)!.inActiveCustomer,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 32.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
              onPressed: () {
                context
                    .read<UpdateLoanDialogBloc>()
                    .add(MarkCustomerAsInactiveEvent(customer: customer));
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.markInactive)),
        )
      ],
    );
  }
}
