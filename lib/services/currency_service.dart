/// Represents the four currencies supported by this app.
enum Currency { eur, dkk, ron, usd }

/// Static exchange rates from EUR to other currencies.
/// We use EUR as the "base" - all conversions go through EUR first.
class CurrencyRates {
  static const Map<String, double> currencyRates = {
    // Rates as of 19/03/2026
    "EUR_TO_DKK": 7.4720,
    "EUR_TO_RON": 5.0938,
    "EUR_TO_USD": 1.1500,
    "EUR_TO_EUR": 1.00,
  };
}

/// Holds the converted amounts for all four currencies.
/// Used as the return type when we convert from one currency to all others.
class ConvertedCurrencyAmounts {
  double? eurAmount;
  double? dkkAmount;
  double? ronAmount;
  double? usdAmount;
}

/// Service that handles all currency conversions.
/// Uses a two-step approach: any currency -> EUR -> all other currencies.
class CurrencyService {
  /// Converts an amount from any currency into EUR (Euro).
  /// Since our rates are stored as "EUR to X", we use the inverse when
  /// converting TO EUR: divide by the rate instead of multiply.
  /// Example: 100 DKK -> EUR = 100 / 7.46 ≈ 13.4 EUR
  static double convertToEUR(Currency currency, double amount) {
    switch (currency) {
      case Currency.eur:
        return amount; // Already in EUR
      case Currency.dkk:
        return amount / CurrencyRates.currencyRates["EUR_TO_DKK"]!;
      case Currency.ron:
        return amount / CurrencyRates.currencyRates["EUR_TO_RON"]!;
      case Currency.usd:
        return amount / CurrencyRates.currencyRates["EUR_TO_USD"]!;
    }
  }

  /// Converts an amount in EUR to the given target currency.
  /// Formula: amount_in_EUR * rate = amount_in_target
  static double convertEURToDKK(double amount) {
    return amount * CurrencyRates.currencyRates["EUR_TO_DKK"]!;
  }

  static double convertEURToRON(double amount) {
    return amount * CurrencyRates.currencyRates["EUR_TO_RON"]!;
  }

  static double convertEURToUSD(double amount) {
    return amount * CurrencyRates.currencyRates["EUR_TO_USD"]!;
  }

  static double convertEURToEUR(double amount) {
    return amount;
  }

  /// Main conversion method: takes user input (currency + value string),
  /// converts to EUR first, then converts from EUR to all other currencies.
  /// Returns a ConvertedCurrencyAmounts object with all four values.
  /// Empty or invalid input is treated as 0.
  static ConvertedCurrencyAmounts convertAllFrom(
    Currency sourceCurrency,
    String value,
  ) {
    // Parse the text input - empty or invalid becomes 0
    final amount = double.tryParse(value) ?? 0.0;

    // Step 1: Convert from source currency to EUR (our base)
    final amountInEUR = convertToEUR(sourceCurrency, amount);

    // Step 2: Convert from EUR to all other currencies
    final result = ConvertedCurrencyAmounts();
    result.eurAmount = convertEURToEUR(amountInEUR);
    result.dkkAmount = convertEURToDKK(amountInEUR);
    result.ronAmount = convertEURToRON(amountInEUR);
    result.usdAmount = convertEURToUSD(amountInEUR);

    return result;
  }
}
