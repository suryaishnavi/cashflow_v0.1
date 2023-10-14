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


/** This is an auto generated class representing the Loan type in your schema. */
class Loan extends amplify_core.Model {
  static const classType = const _LoanModelType();
  final String id;
  final String? _sub;
  final int? _givenAmount;
  final int? _collectibleAmount;
  final int? _paidAmount;
  final EmiType? _emiType;
  final int? _emiAmount;
  final int? _totalEmis;
  final int? _paidEmis;
  final amplify_core.TemporalDate? _dateOfCreation;
  final amplify_core.TemporalDate? _nextDueDate;
  final String? _loanIdentity;
  final amplify_core.TemporalDate? _endDate;
  final LoanStatus? _status;
  final String? _reasonForLoanTermination;
  final String? _customerID;
  final List<Emi>? _emis;
  final amplify_core.TemporalTimestamp? _ttl;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  LoanModelIdentifier get modelIdentifier {
    try {
      return LoanModelIdentifier(
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
  
  int get givenAmount {
    try {
      return _givenAmount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get collectibleAmount {
    try {
      return _collectibleAmount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get paidAmount {
    try {
      return _paidAmount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  EmiType get emiType {
    try {
      return _emiType!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get emiAmount {
    try {
      return _emiAmount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get totalEmis {
    try {
      return _totalEmis!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get paidEmis {
    try {
      return _paidEmis!;
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
  
  amplify_core.TemporalDate get nextDueDate {
    try {
      return _nextDueDate!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get loanIdentity {
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
  
  amplify_core.TemporalDate get endDate {
    try {
      return _endDate!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  LoanStatus get status {
    try {
      return _status!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get reasonForLoanTermination {
    return _reasonForLoanTermination;
  }
  
  String get customerID {
    try {
      return _customerID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Emi>? get emis {
    return _emis;
  }
  
  amplify_core.TemporalTimestamp? get ttl {
    return _ttl;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Loan._internal({required this.id, required sub, required givenAmount, required collectibleAmount, required paidAmount, required emiType, required emiAmount, required totalEmis, required paidEmis, required dateOfCreation, required nextDueDate, required loanIdentity, required endDate, required status, reasonForLoanTermination, required customerID, emis, ttl, createdAt, updatedAt}): _sub = sub, _givenAmount = givenAmount, _collectibleAmount = collectibleAmount, _paidAmount = paidAmount, _emiType = emiType, _emiAmount = emiAmount, _totalEmis = totalEmis, _paidEmis = paidEmis, _dateOfCreation = dateOfCreation, _nextDueDate = nextDueDate, _loanIdentity = loanIdentity, _endDate = endDate, _status = status, _reasonForLoanTermination = reasonForLoanTermination, _customerID = customerID, _emis = emis, _ttl = ttl, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Loan({String? id, required String sub, required int givenAmount, required int collectibleAmount, required int paidAmount, required EmiType emiType, required int emiAmount, required int totalEmis, required int paidEmis, required amplify_core.TemporalDate dateOfCreation, required amplify_core.TemporalDate nextDueDate, required String loanIdentity, required amplify_core.TemporalDate endDate, required LoanStatus status, String? reasonForLoanTermination, required String customerID, List<Emi>? emis, amplify_core.TemporalTimestamp? ttl}) {
    return Loan._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sub: sub,
      givenAmount: givenAmount,
      collectibleAmount: collectibleAmount,
      paidAmount: paidAmount,
      emiType: emiType,
      emiAmount: emiAmount,
      totalEmis: totalEmis,
      paidEmis: paidEmis,
      dateOfCreation: dateOfCreation,
      nextDueDate: nextDueDate,
      loanIdentity: loanIdentity,
      endDate: endDate,
      status: status,
      reasonForLoanTermination: reasonForLoanTermination,
      customerID: customerID,
      emis: emis != null ? List<Emi>.unmodifiable(emis) : emis,
      ttl: ttl);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Loan &&
      id == other.id &&
      _sub == other._sub &&
      _givenAmount == other._givenAmount &&
      _collectibleAmount == other._collectibleAmount &&
      _paidAmount == other._paidAmount &&
      _emiType == other._emiType &&
      _emiAmount == other._emiAmount &&
      _totalEmis == other._totalEmis &&
      _paidEmis == other._paidEmis &&
      _dateOfCreation == other._dateOfCreation &&
      _nextDueDate == other._nextDueDate &&
      _loanIdentity == other._loanIdentity &&
      _endDate == other._endDate &&
      _status == other._status &&
      _reasonForLoanTermination == other._reasonForLoanTermination &&
      _customerID == other._customerID &&
      DeepCollectionEquality().equals(_emis, other._emis) &&
      _ttl == other._ttl;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Loan {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sub=" + "$_sub" + ", ");
    buffer.write("givenAmount=" + (_givenAmount != null ? _givenAmount!.toString() : "null") + ", ");
    buffer.write("collectibleAmount=" + (_collectibleAmount != null ? _collectibleAmount!.toString() : "null") + ", ");
    buffer.write("paidAmount=" + (_paidAmount != null ? _paidAmount!.toString() : "null") + ", ");
    buffer.write("emiType=" + (_emiType != null ? amplify_core.enumToString(_emiType)! : "null") + ", ");
    buffer.write("emiAmount=" + (_emiAmount != null ? _emiAmount!.toString() : "null") + ", ");
    buffer.write("totalEmis=" + (_totalEmis != null ? _totalEmis!.toString() : "null") + ", ");
    buffer.write("paidEmis=" + (_paidEmis != null ? _paidEmis!.toString() : "null") + ", ");
    buffer.write("dateOfCreation=" + (_dateOfCreation != null ? _dateOfCreation!.format() : "null") + ", ");
    buffer.write("nextDueDate=" + (_nextDueDate != null ? _nextDueDate!.format() : "null") + ", ");
    buffer.write("loanIdentity=" + "$_loanIdentity" + ", ");
    buffer.write("endDate=" + (_endDate != null ? _endDate!.format() : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("reasonForLoanTermination=" + "$_reasonForLoanTermination" + ", ");
    buffer.write("customerID=" + "$_customerID" + ", ");
    buffer.write("ttl=" + (_ttl != null ? _ttl!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Loan copyWith({int? givenAmount, int? collectibleAmount, int? paidAmount, EmiType? emiType, int? emiAmount, int? totalEmis, int? paidEmis, amplify_core.TemporalDate? dateOfCreation, amplify_core.TemporalDate? nextDueDate, String? loanIdentity, amplify_core.TemporalDate? endDate, LoanStatus? status, String? reasonForLoanTermination, String? customerID, List<Emi>? emis, amplify_core.TemporalTimestamp? ttl}) {
    return Loan._internal(
      id: id,
      sub: sub,
      givenAmount: givenAmount ?? this.givenAmount,
      collectibleAmount: collectibleAmount ?? this.collectibleAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      emiType: emiType ?? this.emiType,
      emiAmount: emiAmount ?? this.emiAmount,
      totalEmis: totalEmis ?? this.totalEmis,
      paidEmis: paidEmis ?? this.paidEmis,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      loanIdentity: loanIdentity ?? this.loanIdentity,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      reasonForLoanTermination: reasonForLoanTermination ?? this.reasonForLoanTermination,
      customerID: customerID ?? this.customerID,
      emis: emis ?? this.emis,
      ttl: ttl ?? this.ttl);
  }
  
  Loan copyWithModelFieldValues({
    ModelFieldValue<int>? givenAmount,
    ModelFieldValue<int>? collectibleAmount,
    ModelFieldValue<int>? paidAmount,
    ModelFieldValue<EmiType>? emiType,
    ModelFieldValue<int>? emiAmount,
    ModelFieldValue<int>? totalEmis,
    ModelFieldValue<int>? paidEmis,
    ModelFieldValue<amplify_core.TemporalDate>? dateOfCreation,
    ModelFieldValue<amplify_core.TemporalDate>? nextDueDate,
    ModelFieldValue<String>? loanIdentity,
    ModelFieldValue<amplify_core.TemporalDate>? endDate,
    ModelFieldValue<LoanStatus>? status,
    ModelFieldValue<String?>? reasonForLoanTermination,
    ModelFieldValue<String>? customerID,
    ModelFieldValue<List<Emi>?>? emis,
    ModelFieldValue<amplify_core.TemporalTimestamp?>? ttl
  }) {
    return Loan._internal(
      id: id,
      sub: sub,
      givenAmount: givenAmount == null ? this.givenAmount : givenAmount.value,
      collectibleAmount: collectibleAmount == null ? this.collectibleAmount : collectibleAmount.value,
      paidAmount: paidAmount == null ? this.paidAmount : paidAmount.value,
      emiType: emiType == null ? this.emiType : emiType.value,
      emiAmount: emiAmount == null ? this.emiAmount : emiAmount.value,
      totalEmis: totalEmis == null ? this.totalEmis : totalEmis.value,
      paidEmis: paidEmis == null ? this.paidEmis : paidEmis.value,
      dateOfCreation: dateOfCreation == null ? this.dateOfCreation : dateOfCreation.value,
      nextDueDate: nextDueDate == null ? this.nextDueDate : nextDueDate.value,
      loanIdentity: loanIdentity == null ? this.loanIdentity : loanIdentity.value,
      endDate: endDate == null ? this.endDate : endDate.value,
      status: status == null ? this.status : status.value,
      reasonForLoanTermination: reasonForLoanTermination == null ? this.reasonForLoanTermination : reasonForLoanTermination.value,
      customerID: customerID == null ? this.customerID : customerID.value,
      emis: emis == null ? this.emis : emis.value,
      ttl: ttl == null ? this.ttl : ttl.value
    );
  }
  
  Loan.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sub = json['sub'],
      _givenAmount = (json['givenAmount'] as num?)?.toInt(),
      _collectibleAmount = (json['collectibleAmount'] as num?)?.toInt(),
      _paidAmount = (json['paidAmount'] as num?)?.toInt(),
      _emiType = amplify_core.enumFromString<EmiType>(json['emiType'], EmiType.values),
      _emiAmount = (json['emiAmount'] as num?)?.toInt(),
      _totalEmis = (json['totalEmis'] as num?)?.toInt(),
      _paidEmis = (json['paidEmis'] as num?)?.toInt(),
      _dateOfCreation = json['dateOfCreation'] != null ? amplify_core.TemporalDate.fromString(json['dateOfCreation']) : null,
      _nextDueDate = json['nextDueDate'] != null ? amplify_core.TemporalDate.fromString(json['nextDueDate']) : null,
      _loanIdentity = json['loanIdentity'],
      _endDate = json['endDate'] != null ? amplify_core.TemporalDate.fromString(json['endDate']) : null,
      _status = amplify_core.enumFromString<LoanStatus>(json['status'], LoanStatus.values),
      _reasonForLoanTermination = json['reasonForLoanTermination'],
      _customerID = json['customerID'],
      _emis = json['emis'] is List
        ? (json['emis'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Emi.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _ttl = json['ttl'] != null ? amplify_core.TemporalTimestamp.fromSeconds(json['ttl']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sub': _sub, 'givenAmount': _givenAmount, 'collectibleAmount': _collectibleAmount, 'paidAmount': _paidAmount, 'emiType': amplify_core.enumToString(_emiType), 'emiAmount': _emiAmount, 'totalEmis': _totalEmis, 'paidEmis': _paidEmis, 'dateOfCreation': _dateOfCreation?.format(), 'nextDueDate': _nextDueDate?.format(), 'loanIdentity': _loanIdentity, 'endDate': _endDate?.format(), 'status': amplify_core.enumToString(_status), 'reasonForLoanTermination': _reasonForLoanTermination, 'customerID': _customerID, 'emis': _emis?.map((Emi? e) => e?.toJson()).toList(), 'ttl': _ttl?.toSeconds(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sub': _sub,
    'givenAmount': _givenAmount,
    'collectibleAmount': _collectibleAmount,
    'paidAmount': _paidAmount,
    'emiType': _emiType,
    'emiAmount': _emiAmount,
    'totalEmis': _totalEmis,
    'paidEmis': _paidEmis,
    'dateOfCreation': _dateOfCreation,
    'nextDueDate': _nextDueDate,
    'loanIdentity': _loanIdentity,
    'endDate': _endDate,
    'status': _status,
    'reasonForLoanTermination': _reasonForLoanTermination,
    'customerID': _customerID,
    'emis': _emis,
    'ttl': _ttl,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<LoanModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<LoanModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SUB = amplify_core.QueryField(fieldName: "sub");
  static final GIVENAMOUNT = amplify_core.QueryField(fieldName: "givenAmount");
  static final COLLECTIBLEAMOUNT = amplify_core.QueryField(fieldName: "collectibleAmount");
  static final PAIDAMOUNT = amplify_core.QueryField(fieldName: "paidAmount");
  static final EMITYPE = amplify_core.QueryField(fieldName: "emiType");
  static final EMIAMOUNT = amplify_core.QueryField(fieldName: "emiAmount");
  static final TOTALEMIS = amplify_core.QueryField(fieldName: "totalEmis");
  static final PAIDEMIS = amplify_core.QueryField(fieldName: "paidEmis");
  static final DATEOFCREATION = amplify_core.QueryField(fieldName: "dateOfCreation");
  static final NEXTDUEDATE = amplify_core.QueryField(fieldName: "nextDueDate");
  static final LOANIDENTITY = amplify_core.QueryField(fieldName: "loanIdentity");
  static final ENDDATE = amplify_core.QueryField(fieldName: "endDate");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final REASONFORLOANTERMINATION = amplify_core.QueryField(fieldName: "reasonForLoanTermination");
  static final CUSTOMERID = amplify_core.QueryField(fieldName: "customerID");
  static final EMIS = amplify_core.QueryField(
    fieldName: "emis",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Emi'));
  static final TTL = amplify_core.QueryField(fieldName: "ttl");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Loan";
    modelSchemaDefinition.pluralName = "Loans";
    
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
      amplify_core.ModelIndex(fields: const ["customerID"], name: "byCustomer")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.SUB,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.GIVENAMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.COLLECTIBLEAMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.PAIDAMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.EMITYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.EMIAMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.TOTALEMIS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.PAIDEMIS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.DATEOFCREATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.NEXTDUEDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.LOANIDENTITY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.ENDDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.STATUS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.REASONFORLOANTERMINATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.CUSTOMERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Loan.EMIS,
      isRequired: false,
      ofModelName: 'Emi',
      associatedKey: Emi.LOANID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Loan.TTL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.timestamp)
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

class _LoanModelType extends amplify_core.ModelType<Loan> {
  const _LoanModelType();
  
  @override
  Loan fromJson(Map<String, dynamic> jsonData) {
    return Loan.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Loan';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Loan] in your schema.
 */
class LoanModelIdentifier implements amplify_core.ModelIdentifier<Loan> {
  final String id;
  final String sub;

  /**
   * Create an instance of LoanModelIdentifier using [id] the primary key.
   * And [sub] the sort key.
   */
  const LoanModelIdentifier({
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
  String toString() => 'LoanModelIdentifier(id: $id, sub: $sub)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is LoanModelIdentifier &&
      id == other.id &&
      sub == other.sub;
  }
  
  @override
  int get hashCode =>
    id.hashCode ^
    sub.hashCode;
}