import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core.dart';

final requestResponseProvider =
    StateProvider.autoDispose<RequestResponseModel>((ref) {
  return RequestResponseModel.init();
});
