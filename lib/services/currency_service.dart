class CurrencyRates {
  static const Map<String, double> currencyRates = {
    "DKK_TO_RON": 1.53,
    "RON_TO_DKK": 0.65,
  };
}

class CurrencyService {
  static double convertDKKToRON(double amount) {
    return amount * CurrencyRates.currencyRates["DKK_TO_RON"]!;
  }

  static double convertRONToDKK(double amount) {
    return amount * CurrencyRates.currencyRates["RON_TO_DKK"]!;
  }
}
