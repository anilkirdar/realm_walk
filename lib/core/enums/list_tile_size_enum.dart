

enum ListTileSize {
  xlarge,
  large,
  medium,
  small;

  double get height {
    switch (this) {
      case ListTileSize.xlarge:
        return 60;
      case ListTileSize.large:
        return 48;
      case ListTileSize.medium:
        return 44;
      case ListTileSize.small:
        return 36;
    }
  }

  double get iconSize {
    switch (this) {
      case ListTileSize.xlarge:
        return 32;
      case ListTileSize.large:
        return 24;
      case ListTileSize.medium:
        return 20;
      case ListTileSize.small:
        return 20;
    }
  }
}
