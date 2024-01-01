import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class AttatechmentViewerView extends StatelessWidget {
  const AttatechmentViewerView(
      {Key? key, required this.url, required this.attatchmentType})
      : super(key: key);

  final String url;
  final AttatchmentType attatchmentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AttatechmentViewerView_View_file),
      ),
      body: attatchmentType == AttatchmentType.pdf
          ? SfPdfViewer.network(url)
          : Center(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
              ),
            ),
    );
  }
}
