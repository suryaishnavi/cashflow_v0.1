/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Customer type in your schema. */
class Customer extends amplify_core.Model {
  static const classType = const _CustomerModelType();
  final String id;
  final String? _sub;
  final String? _uId;
  final String? _customerName;
  final String? _phone;
  final String? _address;
  final List<String>? _loanIdentity;
  final amplify_core.TemporalDate? _dateOfCreation;
  final amplify_core.TemporalDate? _newLoanAddedDate;
  final PaymentDetails? _paymentInfo;
  final CustomerStatus? _customerStatus;
  final City? _city;
  final double? _longitude;
  final double? _latitude;
  final String? _circleID;
  final List<Loan>? _loans;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  CustomerModelIdentifier get modelIdentifier {
    try {
      return CustomerModelIdentifier(
        id: id,
        sub: _sub!
      );
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get sub {
    try {
      return _sub!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get uId {
    try {
      return _uId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get customerName {
    try {
      return _customerName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get phone {
    try {
      return _phone!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get address {
    try {
      return _address!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get loanIdentity {
    try {
      return _loanIdentity!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDate get dateOfCreation {
    try {
      return _dateOfCreation!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDate? get newLoanAddedDate {
    return _newLoanAddedDate;
  }
  
  PaymentDetails? get paymentInfo {
    return _paymentInfo;
  }
  
  CustomerStatus? get customerStatus {
    return _customerStatus;
  }
  
  City get city {
    try {
      return _city!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get longitude {
    return _longitude;
  }
  
  double? get latitude {
    return _latitude;
  }
  
  String get circleID {
    try {
      return _circleID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Loan>? get loans {
    return _loans;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Customer._internal({required this.id, required sub, required uId, required customerName, required phone, required address, required loanIdentity, required dateOfCreation, newLoanAddedDate, paymentInfo, customerStatus, required city, longitude, latitude, required circleID, loans, createdAt, updatedAt}): _sub = sub, _uId = uId, _customerName = customerName, _phone = phone, _address = address, _loanIdentity = loanIdentity, _dateOfCreation = dateOfCreation, _newLoanAddedDate = newLoanAddedDate, _paymentInfo = paymentInfo, _customerStatus = customerStatus, _city = city, _longitude = longitude, _latitude = latitude, _circleID = circleID, _loans = loans, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Customer({String? id, required String sub, required String uId, required String customerName, required String phone, required String address, required List<String> loanIdentity, required amplify_core.TemporalDate dateOfCreation, amplify_core.TemporalDate? newLoanAddedDate, PaymentDetails? paymentInfo, CustomerStatus? customerStatus, required City city, double? longitude, double? latitude, required String circleID, List<Loan>? loans}) {
    return Customer._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sub: sub,
      uId: uId,
      customerName: customerName,
      phone: phone,
      address: address,
      loanIdentity: loanIdentity != null ? List<String>.unmodifiable(loanIdentity) : loanIdentity,
      dateOfCreation: dateOfCreation,
      newLoanAddedDate: newLoanAddedDate,
      paymentInfo: paymentInfo,
      customerStatus: customerStatus,
      city: city,
      longitude: longitude,
      latitude: latitude,
      circleID: circleID,
      loans: loans != null ? List<Loan>.unmodifiable(loans) : loans);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Customer &&
      id == other.id &&
      _sub == other._sub &&
      _uId == other._uId &&
      _customerName == other._customerName &&
      _phone == other._phone &&
      _address == other._address &&
      DeepCollectionEquality().equals(_loanIdentity, other._loanIdentity) &&
      _dateOfCreation == other._dateOfCreation &&
      _newLoanAddedDate == other._newLoanAddedDate &&
      _paymentInfo == other._paymentInfo &&
      _customerStatus == other._customerStatus &&
      _city == other._city &&
      _longitude == other._longitude &&
      _latitude == other._latitude &&
      _circleID == other._circleID &&
      DeepCollectionEquality().equals(_loans, other._loans);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Customer {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sub=" + "$_sub" + ", ");
    buffer.write("uId=" + "$_uId" + ", ");
    buffer.write("customerName=" + "$_customerName" + ", ");
    buffer.write("phone=" + "$_phone" + ", ");
    buffer.write("address=" + "$_address" + ", ");
    buffer.write("loanIdentity=" + (_loanIdentity != null ? _loanIdentity!.toString() : "null") + ", ");
    buffer.write("dateOfCreation=" + (_dateOfCreation != null ? _dateOfCreation!.format() : "null") + ", ");
    buffer.write("newLoanAddedDate=" + (_newLoanAddedDate != null ? _newLoanAddedDate!.format() : "null") + ", ");
    buffer.write("paymentInfo=" + (_paymentInfo != null ? _paymentInfo!.toString() : "null") + ", ");
    buffer.write("customerStatus=" + (_customerStatus != null ? amplify_core.enumToString(_customerStatus)! : "null") + ", ");
    buffer.write("city=" + (_city != null ? _city!.toString() : "null") + ", ");
    buffer.write("longitude=" + (_longitude != null ? _longitude!.toString() : "null") + ", ");
    buffer.write("latitude=" + (_latitude != null ? _latitude!.toString() : "null") + ", ");
    buffer.write("circleID=" + "$_circleID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Customer copyWith({String? uId, String? customerName, String? phone, String? address, List<String>? loanIdentity, amplify_core.TemporalDate? dateOfCreation, amplify_core.TemporalDate? newLoanAddedDate, PaymentDetails? paymentInfo, CustomerStatus? customerStatus, City? city, double? longitude, double? latitude, String? circleID, List<Loan>? loans}) {
    return Customer._internal(
      id: id,
      sub: sub,
      uId: uId ?? this.uId,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      loanIdentity: loanIdentity ?? this.loanIdentity,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
      newLoanAddedDate: newLoanAddedDate ?? this.newLoanAddedDate,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      customerStatus: customerStatus ?? this.customerStatus,
      city: city ?? this.city,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      circleID: circleID ?? this.circleID,
      loans: loans ?? this.loans);
  }
  
  Customer copyWithModelFieldValues({
    ModelFieldValue<String>? uId,
    ModelFieldValue<String>? customerName,
    ModelFieldValue<String>? phone,
    ModelFieldValue<String>? address,
    ModelFieldValue<List<String>?>? loanIdentity,
    ModelFieldValue<amplify_core.TemporalDate>? dateOfCreation,
    ModelFieldValue<amplify_core.TemporalDate?>? newLoanAddedDate,
    ModelFieldValue<PaymentDetails?>? paymentInfo,
    ModelFieldValue<CustomerStatus?>? customerStatus,
    ModelFieldValue<City>? city,
    ModelFieldValue<double?>? longitude,
    ModelFieldValue<double?>? latitude,
    ModelFieldValue<String>? circleID,
    ModelFieldValue<List<Loan>?>? loans
  }) {
    return Customer._internal(
      id: id,
      sub: sub,
      uId: uId == null ? this.uId : uId.value,
      customerName: customerName == null ? this.customerName : customerName.value,
      phone: phone == null ? this.phone : phone.value,
      address: address == null ? this.address : address.value,
      loanIdentity: loanIdentity == null ? this.loanIdentity : loanIdentity.value,
      dateOfCreation: dateOfCreation == null ? this.dateOfCreation : dateOfCreation.value,
      newLoanAddedDate: newLoanAddedDate == null ? this.newLoanAddedDate : newLoanAddedDate.value,
      paymentInfo: paymentInfo == null ? this.paymentInfo : paymentInfo.value,
      customerStatus: customerStatus == null ? this.customerStatus : customerStatus.value,
      city: city == null ? this.city : city.value,
      longitude: longitude == null ? this.longitude : longitude.value,
      latitude: latitude == null ? this.latitude : latitude.value,
      circleID: circleID == null ? this.circleID : circleID.value,
      loans: loans == null ? this.loans : loans.value
    );
  }
  
  Customer.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sub = json['sub'],
      _uId = json['uId'],
      _customerName = json['customerName'],
      _phone = json['phone'],
      _address = json['address'],
      _loanIdentity = json['loanIdentity']?.cast<String>(),
      _dateOfCreation = json['dateOfCreation'] != null ? amplify_core.TemporalDate.fromString(json['dateOfCreation']) : null,
      _newLoanAddedDate = json['newLoanAddedDate'] != null ? amplify_core.TemporalDate.fromString(json['newLoanAddedDate']) : null,
      _paymentInfo = json['paymentInfo']?['serializedData'] != null
        ? PaymentDetails.fromJson(new Map<String, dynamic>.from(json['paymentInfo']['serializedData']))
        : null,
      _customerStatus = amplify_core.enumFromString<CustomerStatus>(json['customerStatus'], CustomerStatus.values),
      _city = json['city']?['serializedData'] != null
        ? City.fromJson(new Map<String, dynamic>.from(json['city']['serializedData']))
        : null,
      _longitude = (json['longitude'] as num?)?.toDouble(),
      _latitude = (json['latitude'] as num?)?.toDouble(),
      _circleID = json['circleID'],
      _loans = json['loans'] is List
        ? (json['loans'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Loan.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sub': _sub, 'uId': _uId, 'customerName': _customerName, 'phone': _phone, 'address': _address, 'loanIdentity': _loanIdentity, 'dateOfCreation': _dateOfCreation?.format(), 'newLoanAddedDate': _newLoanAddedDate?.format(), 'paymentInfo': _paymentInfo?.toJson(), 'customerStatus': amplify_core.enumToString(_customerStatus), 'city': _city?.toJson(), 'longitude': _longitude, 'latitude': _latitude, 'circleID': _circleID, 'loans': _loans?.map((Loan? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sub': _sub,
    'uId': _uId,
    'customerName': _customerName,
    'phone': _phone,
    'address': _address,
    'loanIdentity': _loanIdentity,
    'dateOfCreation': _dateOfCreation,
    'newLoanAddedDate': _newLoanAddedDate,
    'paymentInfo': _paymentInfo,
    'customerStatus': _customerStatus,
    'city': _city,
    'longitude': _longitude,
    'latitude': _latitude,
    'circleID': _circleID,
    'loans': _loans,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<CustomerModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<CustomerModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SUB = amplify_core.QueryField(fieldName: "sub");
  static final UID = amplify_core.QueryField(fieldName: "uId");
  static final CUSTOMERNAME = amplify_core.QueryField(fieldName: "customerName");
  static final PHONE = amplify_core.QueryField(fieldName: "phone");
  static final ADDRESS = amplify_core.QueryField(fieldName: "address");
  static final LOANIDENTITY = amplify_core.QueryField(fieldName: "loanIdentity");
  static final DATEOFCREATION = amplify_core.QueryField(fieldName: "dateOfCreation");
  static final NEWLOANADDEDDATE = amplify_core.QueryField(fieldName: "newLoanAddedDate");
  static final PAYMENTINFO = amplify_core.QueryField(fieldName: "paymentInfo");
  static final CUSTOMERSTATUS = amplify_core.QueryField(fieldName: "customerStatus");
  static final CITY = amplify_core.QueryField(
    fieldName: "city",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'City'));
  static final LONGITUDE = amplify_core.QueryField(fieldName: "longitude");
  static final LATITUDE = amplify_core.QueryField(fieldName: "latitude");
  static final CIRCLEID = amplify_core.QueryField(fieldName: "circleID");
  static final LOANS = amplify_core.QueryField(
    fieldName: "loans",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Loan'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Customer";
    modelSchemaDefinition.pluralName = "Customers";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id", "sub"], name: null),
      amplify_core.ModelIndex(fields: const ["circleID"], name: "byCircle")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.SUB,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.UID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.CUSTOMERNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.PHONE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.ADDRESS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.LOANIDENTITY,
      isRequired: true,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.DATEOFCREATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.NEWLOANADDEDDATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'paymentInfo',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embedded, ofCustomTypeName: 'PaymentDetails')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.CUSTOMERSTATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Customer.CITY,
      isRequired: true,
      targetNames: ['cityCustomerId', 'cityCustomerCircleID'],
      ofModelName: 'City'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.LONGITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.LATITUDE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Customer.CIRCLEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Customer.LOANS,
      isRequired: false,
      ofModelName: 'Loan',
      associatedKey: Loan.CUSTOMERID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _CustomerModelType extends amplify_core.ModelType<Customer> {
  const _CustomerModelType();
  
  @override
  Customer fromJson(Map<String, dynamic> jsonData) {
    return Customer.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Customer';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Customer] in your schema.
 */
class CustomerModelIdentifier implements amplify_core.ModelIdentifier<Customer> {
  final String id;
  final String sub;

  /**
   * Create an instance of CustomerModelIdentifier using [id] the primary key.
   * And [sub] the sort key.
   */
  const CustomerModelIdentifier({
    required this.id,
    required this.sub});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id,
    'sub': sub
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'CustomerModelIdentifier(id: $id, sub: $sub)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is CustomerModelIdentifier &&
      id == other.id &&
      sub == other.sub;
  }
  
  @override
  int get hashCode =>
    id.hashCode ^
    sub.hashCode;
}