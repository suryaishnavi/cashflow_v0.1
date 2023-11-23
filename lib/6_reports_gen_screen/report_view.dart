import 'package:cashflow/widgets/generate_report_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../info_helper/loading_view.dart';
import '../widgets/page_heading.dart';
import '../widgets/tonal_filled_button.dart';
import 'cubit/report_cubit.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _heading(context: context),
          const SizedBox(height: 16),
          Expanded(child: _selectCircle()),
        ],
      ),
    );
  }

  Widget _heading({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PageHeading(heading: AppLocalizations.of(context)!.generateReport),
          TonalFilledButton(
            onPressed: () {
              BlocProvider.of<ReportCubit>(context).getCircles();
            },
            text: AppLocalizations.of(context)!.retry,
            icon: const Icon(Icons.refresh, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _selectCircle() {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: LoadingView());
        } else if (state is CirclesLoadedState) {
          return state.circles.isEmpty
              ? Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.noCirclesFound,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                  ],
                )
              // form
              : GenerateReportForm(circles: state.circles);
        } else if (state is ReportError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.errorMsg),
              const SizedBox(height: 16.0),
              Text(AppLocalizations.of(context)!.tryAgain),
              const SizedBox(height: 32.0),
            ],
          );
        } else if (state is EmptyState) {
          return Column(
            children: [
              Text(
                state.message,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        } else if (state is DocsReadyState) {
          Future.delayed(Duration.zero, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(doc: state.doc),
              ),
            );
          });
          return Container();
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.errorMsg),
              const SizedBox(height: 16.0),
              Text(AppLocalizations.of(context)!.tryAgain),
            ],
          );
        }
      },
    );
  }
}

// * preview screen
class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool isPop) async {
        context.read<ReportCubit>().getCircles();
        Future.delayed(Duration.zero, () {
          Navigator.pop(context);
        });
      },
      // onWillPop: () async {
      //   context.read<ReportCubit>().getCircles();
      //   return true;
      // },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ReportCubit>().getCircles();
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.preview),
        ),
        body: PdfPreview(
          build: (format) => doc.save(),
          canChangeOrientation: false,
          canChangePageFormat: false,
          allowSharing: true,
          allowPrinting: true,
          initialPageFormat: PdfPageFormat.a4,
          pdfFileName: "mydoc.pdf",
          canDebug: false,
          onPrinted: (format) => Navigator.pop(context),
        ),
      ),
    );
  }
}
