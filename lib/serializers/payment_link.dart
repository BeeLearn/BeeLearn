import 'package:json_annotation/json_annotation.dart';

part 'payment_link.g.dart';

@JsonSerializable()
class PaystackPaymentLink {
  @JsonKey(required: true)
  final String reference;

  @JsonKey(required: true, name: "authorization_url")
  final String authorizationUrl;

  @JsonKey(required: true, name: "access_code")
  final String accessCode;

  const PaystackPaymentLink({
    required this.accessCode,
    required this.reference,
    required this.authorizationUrl,
  });

  factory PaystackPaymentLink.fromJson(Map<String, dynamic> json) => _$PaystackPaymentLinkFromJson(json);
}

@JsonSerializable()
class FlutterwavePaymentLink {
  @JsonKey(required: true)
  final String link;

  const FlutterwavePaymentLink({required this.link});

  factory FlutterwavePaymentLink.fromJson(Map<String, dynamic> json) => _$FlutterwavePaymentLinkFromJson(json);
}

enum PaymentLinkSource {
  @JsonValue("paystack")
  paystack,
  @JsonValue("flutterwave")
  flutterwave,
}

class PaymentLink<T> {
  final PaymentLinkSource source;
  final T data;

  const PaymentLink({required this.source, required this.data});

  factory PaymentLink.fromJson(Map<String, dynamic> json) {
    switch (json["source"]) {
      case "flutterwave":
        return PaymentLink<T>(
          source: PaymentLinkSource.flutterwave,
          data: FlutterwavePaymentLink.fromJson(json["data"]) as T,
        );
      case "paystack":
        return PaymentLink<T>(
          source: PaymentLinkSource.paystack,
          data: PaystackPaymentLink.fromJson(json["data"]) as T,
        );
      default:
        throw UnimplementedError("payment source ${json["sources"]} is not supported");
    }
  }
}
