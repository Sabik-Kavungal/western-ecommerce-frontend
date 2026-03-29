class ShippingService {
  static double calculateDTDC(String state, String city) {
    // Simplified: Flat rate of 60 for all locations/states
    return 60.0;
  }

  static double calculateIndiaPost(String state, String city) {
    // Both courier options now use identical flat pricing
    return 60.0;
  }

  static Map<String, double> getShippingOptions(String state, String city) {
    return {
      'DTDC': 60.0,
      'INDIA POST': 60.0,
    };
  }
}

