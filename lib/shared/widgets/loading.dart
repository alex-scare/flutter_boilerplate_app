import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:template_app/shared/helpers/asset_lottie_path.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        AssetLottiePath.loadingDots.path,
        width: 200,
      ),
    );
  }
}
