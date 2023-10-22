import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/ModelProvider.dart';
import '../circles_helper/screen_helper_cubit/screens_cubit.dart';
import '../config/routes/route_constants.dart';
import '../widgets/elevated_tonal_button.dart';
import '../widgets/new_circle_form.dart';
import '../widgets/page_heading.dart';
import '../widgets/tonal_filled_button.dart';
import 'circles_bloc/circle_bloc.dart';
import 'create_new_circle/create_circle_bloc.dart';

class CircleView extends StatelessWidget {
  const CircleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return Scaffold(
      body: BlocListener<ScreensCubit, ScreensState>(
        listener: (context, state) {
          if (state == ScreensState.customers) {
            GoRouter.of(context).pushNamed(RouteConstants.customers);
          }
          if (state == ScreensState.citiesView) {
            GoRouter.of(context).pushNamed(RouteConstants.citiesView);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _heading(context),
              const SizedBox(height: 8),
              _circleGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PageHeading(
          heading: AppLocalizations.of(context)!.yourCircle,
        ),
        context.watch<CircleBloc>().state is CircleEmptyState
            ? const Text('')
            : TonalFilledButton(
                onPressed: () {
                  _modalBottomSheet(context: context);
                },
                text: AppLocalizations.of(context)!.addCircle,
                icon: const Icon(Icons.add, size: 20),
              ),
      ],
    );
  }

  Widget _circleGrid() {
    return BlocBuilder<CircleBloc, CircleState>(
      builder: (context, state) {
        switch (state) {
          case CirclesLoadingState():
            return const Center(child: CircularProgressIndicator());
          case CirclesLoadedState():
            return Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.circles.length,
                    itemBuilder: (context, index) {
                      return CircleGridTileBar(circle: state.circles[index]);
                    },
                  );
                },
              ),
            );
          case CircleErrorState():
            return Center(child: Text(state.error.toString()));
          case DatastoreErrorState():
            return Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text:
                            'We are sorry for the inconvenience caused by this error: ',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 18),
                        children: [
                          TextSpan(
                            text: state.error.message,
                            style: TextStyle(
                                color: Colors.redAccent[100],
                                fontWeight: FontWeight.w500),
                          ),
                          const TextSpan(
                            text: '\nPlease try again.',
                          ),
                        ]),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedTonalButton(
                  onPressed: () {
                    context
                        .read<CircleBloc>()
                        .add(LoadCirclesEvent(appUser: state.appUser));
                  },
                  text: 'Refresh',
                  icon: const Icon(Icons.refresh),
                ),
              ],
            );
          case CircleEmptyState():
            return _emptyGridView(context: context);
          default: // CirclesLoadingState
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _emptyGridView({required BuildContext context}) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.noCircle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedTonalButton(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlue[50]),
          foregroundColor: MaterialStateProperty.all(Colors.lightBlueAccent[700]),
          shadowColor: MaterialStateProperty.all(Colors.lightBlueAccent[400]),
          onPressed: () {
            _modalBottomSheet(context: context);
          },
          text: AppLocalizations.of(context)!.createCircleBtn,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _modalBottomSheet({required BuildContext context}) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<CreateCircleBloc>(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.createCircleBtn,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: BlocListener<CreateCircleBloc, CreateCircleState>(
                  listener: (context, state) {},
                  child: const NewCircleForm(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CircleGridTileBar extends StatelessWidget {
  final Circle circle;
  const CircleGridTileBar({super.key, required this.circle});
  (Color color, Color textColor) getcolors({required Circle circle}) {
    if (circle.day == WeekDay.DAILY) {
      return (Colors.green, Colors.green.shade700);
    } else if (circle.day == WeekDay.MONTHLY) {
      return (Colors.orange, Colors.orange.shade700);
    } else {
      return (Colors.lightBlueAccent, Colors.lightBlue.shade700);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return grid tail with shadow and elevation
    return Card(
      surfaceTintColor: getcolors(circle: circle).$1,
      clipBehavior: Clip.antiAlias,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      shadowColor: getcolors(circle: circle).$1.withAlpha(100),
      child: InkWell(
        splashColor: getcolors(circle: circle).$1.withAlpha(100),
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 200), () {
            context.read<CircleBloc>().add(ShowCustomersEvent(circle: circle));
          });
        },
        child: GridTile(
          header: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CirclePopupmenuOptions(
                  circle: circle,
                  color: getcolors(circle: circle).$1,
                ),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                // new
                flex: 1,
                child: CircleAvatar(
                  backgroundColor: getcolors(circle: circle).$1,
                  child: Text(
                    circle.circleName.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                // new
                flex: 1,
                child: Text(
                  circle.circleName.length > 15
                      ? '${circle.circleName[0].toUpperCase() + circle.circleName.substring(1, 15).toLowerCase()}...'
                      : circle.circleName[0].toUpperCase() +
                          circle.circleName.substring(1).toLowerCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: getcolors(circle: circle).$2,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  AppLocalizations.of(context)!
                      .getWeekDay('${circle.day}'.split('.').last),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: getcolors(circle: circle).$2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// popup menu button

enum MenuItem { itemOne, itemTwo, itemThree }

class CirclePopupmenuOptions extends StatefulWidget {
  final Circle circle;
  final Color color;
  const CirclePopupmenuOptions(
      {super.key, required this.circle, required this.color});

  @override
  State<CirclePopupmenuOptions> createState() => _CirclePopupmenuOptionsState();
}

class _CirclePopupmenuOptionsState extends State<CirclePopupmenuOptions> {
  _deleteCircle({required Circle circle}) {
    // context.read<CircleBloc>().add(DeleteCircle(circle: circle));
    // show delete confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Theme.of(context).colorScheme.error,
          title: Row(
            children: [
              const Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
              const SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.deleteOptionsTxt('delCircle'),
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteOptionsTxt('delCircleMsg'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<CircleBloc>().add(DeleteCircle(circle: circle));
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: Colors.red),
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
      icon: Icon(Icons.more_vert, color: widget.color.withAlpha(900)),
      onSelected: (value) {
        if (value == MenuItem.itemOne) {
          context.read<CircleBloc>().add(
                ShowCities(circle: widget.circle),
              );
        } else if (value == MenuItem.itemTwo) {
          _deleteCircle(circle: widget.circle);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: MenuItem.itemOne,
          child: Text(AppLocalizations.of(context)!.allCities),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: MenuItem.itemTwo,
          child: Text(
            AppLocalizations.of(context)!.deleteOptionsTxt('delCircle'),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
