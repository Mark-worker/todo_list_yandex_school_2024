enum Flavor {
  staging,
  production
}

class FlavorConfig {
  final Flavor flavor;

  static late FlavorConfig _instance;

  factory FlavorConfig({required Flavor flavor}) {
    _instance = FlavorConfig._internal(flavor);
    return _instance;
  }

  FlavorConfig._internal(this.flavor);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.production;
  static bool isStaging() => _instance.flavor == Flavor.staging;
}
