import 'package:flutter/material.dart';

class RadiusConst {
  static BorderRadius bottomNavBar = const BorderRadius.only(
    topLeft: Radius.circular(14),
    topRight: Radius.circular(14),
  );
  static BorderRadius videoPlayer = const BorderRadius.only(
    bottomLeft: Radius.circular(14),
    bottomRight: Radius.circular(14),
  );
  static BorderRadius onBoardBox = BorderRadius.circular(20);
  static BorderRadius imagePickerButton = BorderRadius.circular(20);
  static BorderRadius onBoardBoxClip = BorderRadius.circular(1);
  static BorderRadius listTile = BorderRadius.circular(14);
  static BorderRadius gridTile = BorderRadius.circular(8);
  static BorderRadius circularRadius2 = BorderRadius.circular(2);
  static BorderRadius closeOnCallTranslate = const BorderRadius.only(
    topRight: Radius.circular(25),
    bottomLeft: Radius.circular(10),
  );

  /// Rectangular RADIUS
  static BorderRadius smallestRectangular = BorderRadius.circular(3);
  static BorderRadius smallest1Rectangular = BorderRadius.circular(4);
  static BorderRadius smallest3Rectangular = BorderRadius.circular(6);
  static BorderRadius smallRectangular = BorderRadius.circular(7);
  static BorderRadius small3Rectangular = BorderRadius.circular(5);
  static BorderRadius small4Rectangular = BorderRadius.circular(4);

  static BorderRadius smallTopRectangular = const BorderRadius.vertical(
    top: Radius.circular(7),
  );
  static BorderRadius mediumTopRectangular = const BorderRadius.vertical(
    top: Radius.circular(14),
  );
  static BorderRadius smallBottomRectangular = const BorderRadius.vertical(
    bottom: Radius.circular(7),
  );

  static BorderRadius small2TopRectangular = const BorderRadius.vertical(
    top: Radius.circular(4.5),
  );
  static BorderRadius small2BottomRectangular = const BorderRadius.vertical(
    bottom: Radius.circular(4.5),
  );

  static BorderRadius mediumRectangular = BorderRadius.circular(9);
  static Radius mediumRectangularRadius = const Radius.circular(9);
  static BorderRadius medium2Rectangular = BorderRadius.circular(8);

  static BorderRadius bigRectangular = BorderRadius.circular(11);
  static const Radius bigRectangularRadius = Radius.circular(11);

  static BorderRadius bigRectangular1 = BorderRadius.circular(12);
  static Radius bigRectangular1Radius = const Radius.circular(12);

  static BorderRadius biggerRectangular = BorderRadius.circular(14);
  static BorderRadius userProfileCard = BorderRadius.circular(8);

  /// Circular
  static BorderRadius circular4 = BorderRadius.circular(4);
  static BorderRadius circular5 = BorderRadius.circular(5);
  static BorderRadius circular8 = BorderRadius.circular(8);
  static BorderRadius circular10 = BorderRadius.circular(10);
  static BorderRadius circular12 = BorderRadius.circular(12);
  static BorderRadius circular20 = BorderRadius.circular(20);
  static BorderRadius circular25 = BorderRadius.circular(25);
  static BorderRadius circular28 = BorderRadius.circular(28);
  static BorderRadius circular50 = BorderRadius.circular(50);
  static BorderRadius circular75 = BorderRadius.circular(75);
  static BorderRadius circular100 = BorderRadius.circular(100);

  /// Excluded
  static BorderRadius leftBottomExcludedListTile = _getLeftBottomExcluded(
    listTileRadius,
  );

  static BorderRadius topRightExcludedListTile = _getTopRightExcluded(
    listTileRadius,
  );

  static BorderRadius paywallCardSelected = _getTopLeftExcluded(
    const Radius.circular(13),
  );

  static BorderRadius paywallCard = _getTopLeftExcluded(
    const Radius.circular(11),
  );

  static BorderRadius paywallCardLeftBoxSelected = BorderRadius.only(
    topRight: bigRectangularRadius,
    bottomLeft: mediumRectangularRadius,
  );

  static BorderRadius leftBottomExcludedBigRadius = _getLeftBottomExcluded(
    bigRectangularRadius,
  );

  /// TopLeft BottomRight Radius
  static BorderRadius topLeftBottomRightListTile = _getTopLeftBottomRight(
    listTileRadius,
  );

  static BorderRadius topLeftBottomRightBigRadius = _getTopLeftBottomRight(
    bigRectangularRadius,
  );

  static BorderRadius topLeftBottomRightPaywallPayLess = _getTopLeftBottomRight(
    const Radius.circular(12),
  );

  /// TopRight BottomLeft Radius
  static BorderRadius topRightBottomLeftListTile = _getTopRightBottomLeft(
    listTileRadius,
  );

  static BorderRadius topRightBottomLeftBigRadius = _getTopRightBottomLeft(
    bigRectangularRadius,
  );

  /// Top Border Radius
  static BorderRadius topNotificationBox = _getTopRadius(bigRectangularRadius);

  /// Bottom Border Radius
  static BorderRadius bottomNotificationBox = _getBottomRadius(
    bigRectangularRadius,
  );
  static BorderRadius bottom25 = _getBottomRadius(const Radius.circular(25));

  // /// Circular
  // static const double circular25Double = 25;
  // static const double circular50Double = 50;
  // static const double circular75Double = 75;

  ///Button
  static BorderRadius elevatedButton = BorderRadius.circular(14);
  static BorderRadius smallSquaredButton = BorderRadius.circular(8);
  static BorderRadius smallestSquaredButton = BorderRadius.circular(5);

  static const Radius scrollBar = Radius.circular(20);

  static const BorderRadius bigRectangularRadiusLeft = BorderRadius.only(
    topLeft: bigRectangularRadius,
    bottomLeft: bigRectangularRadius,
  );

  static const BorderRadius bigRectangularRadiusRight = BorderRadius.only(
    topRight: bigRectangularRadius,
    bottomRight: bigRectangularRadius,
  );

  static const Radius listTileRadius = Radius.circular(14);

  ///
  static BorderRadius getImageRadius(bool? isMedium) {
    return (isMedium == null
        ? circular25
        : (isMedium ? circular50 : circular100));
  }

  static BorderRadius _getTopRadius(Radius listTileRadius) {
    return BorderRadius.only(topLeft: listTileRadius, topRight: listTileRadius);
  }

  static BorderRadius _getBottomRadius(Radius listTileRadius) {
    return BorderRadius.only(
      bottomLeft: listTileRadius,
      bottomRight: listTileRadius,
    );
  }

  static BorderRadius _getLeftBottomExcluded(Radius listTileRadius) {
    return BorderRadius.only(
      bottomRight: listTileRadius,
      topLeft: listTileRadius,
      topRight: listTileRadius,
    );
  }

  static BorderRadius _getTopLeftExcluded(Radius listTileRadius) {
    return BorderRadius.only(
      bottomRight: listTileRadius,
      bottomLeft: listTileRadius,
      topRight: listTileRadius,
    );
  }

  static BorderRadius _getTopRightExcluded(Radius listTileRadius) {
    return BorderRadius.only(
      bottomRight: listTileRadius,
      bottomLeft: listTileRadius,
      topLeft: listTileRadius,
    );
  }

  static BorderRadius _getTopLeftBottomRight(Radius listTileRadius) {
    return BorderRadius.only(
      topLeft: listTileRadius,
      bottomRight: listTileRadius,
    );
  }

  static BorderRadius _getTopRightBottomLeft(Radius listTileRadius) {
    return BorderRadius.only(
      topRight: listTileRadius,
      bottomLeft: listTileRadius,
    );
  }
}
