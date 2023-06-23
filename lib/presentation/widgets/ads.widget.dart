import 'package:flutter/material.dart';
import 'package:videodown/infrastructure/themes.dart';

int adsworking = 1;


class MyAdsOnVideoPage extends StatelessWidget {
  const MyAdsOnVideoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (adsworking == 1) ...[
          //  MyAdmostBanner(),
          const MyAdmostBanner(),
        ]
      ],
    );
  }
}

class MyAdmostBanner extends StatelessWidget {
  const MyAdmostBanner({super.key});

  @override
  Widget build(BuildContext context) {
    print("/////------------------render MyAdmostBanner--------");
    return Card(
      elevation: 0,
      color: MyColors.opp1.withOpacity(0),
      clipBehavior: Clip.hardEdge,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        // color: Colors.blue[700],
      ),
    );
  }

  // Banner Callbacks
  @override
  void onBannerClicked() {
    print('MAIN.DART >>>> onBannerClicked');
  }

  @override
  void onBannerAllProvidersFailedToLoad() {
    print('MAIN.DART >>>> onBannerAllProvidersFailedToLoad');

    // _adCelBannerController.setRefreshInterval(35);
    // _adCelBannerController.loadNextAd();
  }

  @override
  void onBannerFailedToLoad() {
    print('MAIN.DART >>>> onBannerFailedToLoad');
  }

  @override
  void onBannerFailedToLoadProvider(String provider) {
    print('MAIN.DART >>>> onBannerFailedToLoadProvider: $provider');
  }

  @override
  void onBannerLoad() {
    print('MAIN.DART >>>> onBannerLoad');
  }
}
