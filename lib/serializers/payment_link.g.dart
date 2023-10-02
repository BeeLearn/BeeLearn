// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaystackPaymentLink _$PaystackPaymentLinkFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['reference', 'authorization_url', 'access_code'],
  );
  return PaystackPaymentLink(
    accessCode: json['access_code'] as String,
    reference: json['reference'] as String,
    authorizationUrl: json['authorization_url'] as String,
  );
}

Map<String, dynamic> _$PaystackPaymentLinkToJson(
        PaystackPaymentLink instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'authorization_url': instance.authorizationUrl,
      'access_code': instance.accessCode,
    };

FlutterwavePaymentLink _$FlutterwavePaymentLinkFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['link'],
  );
  return FlutterwavePaymentLink(
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$FlutterwavePaymentLinkToJson(
        FlutterwavePaymentLink instance) =>
    <String, dynamic>{
      'link': instance.link,
    };
