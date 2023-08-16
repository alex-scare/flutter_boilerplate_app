import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:template_app/shared/components/loading.dart';
import 'package:template_app/shared/pub/global_state.dart';

class GlobalLoadingHandler extends StatelessWidget {
  final Widget child;

  const GlobalLoadingHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(children: [child, const GlobalLoadingHolder()]),
    );
  }
}

class GlobalLoadingHolder extends HookConsumerWidget {
  const GlobalLoadingHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(globalStatePod.select((value) => value.globalLoading));

    useEffect(
      () {
        if (!isLoading) return;

        ref.read(globalStatePod.notifier).setGlobalLoading(false);
        return null;
      },
      [],
    );

    return isLoading ? const Loading() : const SizedBox.shrink();
  }
}
