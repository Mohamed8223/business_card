import 'package:easy_stepper/easy_stepper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EasyStepExtended {
  HookConsumerWidget widget;
  EasyStep step;

  // fix the class above with constructor and add the following code to the class
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EasyStepExtended &&
        other.widget == widget &&
        other.step == step;
  }

  @override
  int get hashCode => widget.hashCode ^ step.hashCode;

  @override
  String toString() => 'EasyStepExtended(widget: $widget, step: $step)';

  EasyStepExtended({
    required this.widget,
    required this.step,
  });

  EasyStepExtended copyWith({
    HookConsumerWidget? widget,
    EasyStep? step,
  }) {
    return EasyStepExtended(
      widget: widget ?? this.widget,
      step: step ?? this.step,
    );
  }
}
