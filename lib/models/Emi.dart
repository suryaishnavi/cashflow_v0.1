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


/** This is an auto generated class representing the Emi type in your schema. */
class Emi extends amplify_core.Model {
  static const classType = const _EmiModelType();
  final String id;
  final int? _emiNumber;
  final String? _sub;
  final String? _customerName;
  final String? _loanIdentity;
  final int? _emiAmount;
  final amplify_core.TemporalDate? _paidDate;
  final amplify_core.TemporalDate? _updatedDate;
  final int? _paidAmount;
  final int? _initialAmount;
  final EmiStatus? _status;
  final amplify_core.TemporalDate? _dueDate;
  final bool? _isExtraEmi;
  final String? _loanID;
  final amplify_core.TemporalTimestamp? _ttl;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  EmiModelIdentifier get modelIdentifier {
    try {
      return EmiModelIdentifier(
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
  
  int get emiNumber {
    try {
      return _emiNumber!;
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
  
  amplify_core.TemporalDate? get paidDate {
    return _paidDate;
  }
  
  amplify_core.TemporalDate? get updatedDate {
    return _updatedDate;
  }
  
  int? get paidAmount {
    return _paidAmount;
  }
  
  int? get initialAmount {
    return _initialAmount;
  }
  
  EmiStatus get status {
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
  
  amplify_core.TemporalDate get dueDate {
    try {
      return _dueDate!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool? get isExtraEmi {
    return _isExtraEmi;
  }
  
  String get loanID {
    try {
      return _loanID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
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
  
  const Emi._internal({required this.id, required emiNumber, required sub, required customerName, required loanIdentity, required emiAmount, paidDate, updatedDate, paidAmount, initialAmount, required status, required dueDate, isExtraEmi, required loanID, ttl, createdAt, updatedAt}): _emiNumber = emiNumber, _sub = sub, _customerName = customerName, _loanIdentity = loanIdentity, _emiAmount = emiAmount, _paidDate = paidDate, _updatedDate = updatedDate, _paidAmount = paidAmount, _initialAmount = initialAmount, _status = status, _dueDate = dueDate, _isExtraEmi = isExtraEmi, _loanID = loanID, _ttl = ttl, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Emi({String? id, required int emiNumber, required String sub, required String customerName, required String loanIdentity, required int emiAmount, amplify_core.TemporalDate? paidDate, amplify_core.TemporalDate? updatedDate, int? paidAmount, int? initialAmount, required EmiStatus status, required amplify_core.TemporalDate dueDate, bool? isExtraEmi, required String loanID, amplify_core.TemporalTimestamp? ttl}) {
    return Emi._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      emiNumber: emiNumber,
      sub: sub,
      customerName: customerName,
      loanIdentity: loanIdentity,
      emiAmount: emiAmount,
      paidDate: paidDate,
      updatedDate: updatedDate,
      paidAmount: paidAmount,
      initialAmount: initialAmount,
      status: status,
      dueDate: dueDate,
      isExtraEmi: isExtraEmi,
      loanID: loanID,
      ttl: ttl);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Emi &&
      id == other.id &&
      _emiNumber == other._emiNumber &&
      _sub == other._sub &&
      _customerName == other._customerName &&
      _loanIdentity == other._loanIdentity &&
      _emiAmount == other._emiAmount &&
      _paidDate == other._paidDate &&
      _updatedDate == other._updatedDate &&
      _paidAmount == other._paidAmount &&
      _initialAmount == other._initialAmount &&
      _status == other._status &&
      _dueDate == other._dueDate &&
      _isExtraEmi == other._isExtraEmi &&
      _loanID == other._loanID &&
      _ttl == other._ttl;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Emi {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("emiNumber=" + (_emiNumber != null ? _emiNumber!.toString() : "null") + ", ");
    buffer.write("sub=" + "$_sub" + ", ");
    buffer.write("customerName=" + "$_customerName" + ", ");
    buffer.write("loanIdentity=" + "$_loanIdentity" + ", ");
    buffer.write("emiAmount=" + (_emiAmount != null ? _emiAmount!.toString() : "null") + ", ");
    buffer.write("paidDate=" + (_paidDate != null ? _paidDate!.format() : "null") + ", ");
    buffer.write("updatedDate=" + (_updatedDate != null ? _updatedDate!.format() : "null") + ", ");
    buffer.write("paidAmount=" + (_paidAmount != null ? _paidAmount!.toString() : "null") + ", ");
    buffer.write("initialAmount=" + (_initialAmount != null ? _initialAmount!.toString() : "null") + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("dueDate=" + (_dueDate != null ? _dueDate!.format() : "null") + ", ");
    buffer.write("isExtraEmi=" + (_isExtraEmi != null ? _isExtraEmi!.toString() : "null") + ", ");
    buffer.write("loanID=" + "$_loanID" + ", ");
    buffer.write("ttl=" + (_ttl != null ? _ttl!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Emi copyWith({int? emiNumber, String? customerName, String? loanIdentity, int? emiAmount, amplify_core.TemporalDate? paidDate, amplify_core.TemporalDate? updatedDate, int? paidAmount, int? initialAmount, EmiStatus? status, amplify_core.TemporalDate? dueDate, bool? isExtraEmi, String? loanID, amplify_core.TemporalTimestamp? ttl}) {
    return Emi._internal(
      id: id,
      emiNumber: emiNumber ?? this.emiNumber,
      sub: sub,
      customerName: customerName ?? this.customerName,
      loanIdentity: loanIdentity ?? this.loanIdentity,
      emiAmount: emiAmount ?? this.emiAmount,
      paidDate: paidDate ?? this.paidDate,
      updatedDate: updatedDate ?? this.updatedDate,
      paidAmount: paidAmount ?? this.paidAmount,
      initialAmount: initialAmount ?? this.initialAmount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      isExtraEmi: isExtraEmi ?? this.isExtraEmi,
      loanID: loanID ?? this.loanID,
      ttl: ttl ?? this.ttl);
  }
  
  Emi copyWithModelFieldValues({
    ModelFieldValue<int>? emiNumber,
    ModelFieldValue<String>? customerName,
    ModelFieldValue<String>? loanIdentity,
    ModelFieldValue<int>? emiAmount,
    ModelFieldValue<amplify_core.TemporalDate?>? paidDate,
    ModelFieldValue<amplify_core.TemporalDate?>? updatedDate,
    ModelFieldValue<int?>? paidAmount,
    ModelFieldValue<int?>? initialAmount,
    ModelFieldValue<EmiStatus>? status,
    ModelFieldValue<amplify_core.TemporalDate>? dueDate,
    ModelFieldValue<bool?>? isExtraEmi,
    ModelFieldValue<String>? loanID,
    ModelFieldValue<amplify_core.TemporalTimestamp?>? ttl
  }) {
    return Emi._internal(
      id: id,
      emiNumber: emiNumber == null ? this.emiNumber : emiNumber.value,
      sub: sub,
      customerName: customerName == null ? this.customerName : customerName.value,
      loanIdentity: loanIdentity == null ? this.loanIdentity : loanIdentity.value,
      emiAmount: emiAmount == null ? this.emiAmount : emiAmount.value,
      paidDate: paidDate == null ? this.paidDate : paidDate.value,
      updatedDate: updatedDate == null ? this.updatedDate : updatedDate.value,
      paidAmount: paidAmount == null ? this.paidAmount : paidAmount.value,
      initialAmount: initialAmount == null ? this.initialAmount : initialAmount.value,
      status: status == null ? this.status : status.value,
      dueDate: dueDate == null ? this.dueDate : dueDate.value,
      isExtraEmi: isExtraEmi == null ? this.isExtraEmi : isExtraEmi.value,
      loanID: loanID == null ? this.loanID : loanID.value,
      ttl: ttl == null ? this.ttl : ttl.value
    );
  }
  
  Emi.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _emiNumber = (json['emiNumber'] as num?)?.toInt(),
      _sub = json['sub'],
      _customerName = json['customerName'],
      _loanIdentity = json['loanIdentity'],
      _emiAmount = (json['emiAmount'] as num?)?.toInt(),
      _paidDate = json['paidDate'] != null ? amplify_core.TemporalDate.fromString(json['paidDate']) : null,
      _updatedDate = json['updatedDate'] != null ? amplify_core.TemporalDate.fromString(json['updatedDate']) : null,
      _paidAmount = (json['paidAmount'] as num?)?.toInt(),
      _initialAmount = (json['initialAmount'] as num?)?.toInt(),
      _status = amplify_core.enumFromString<EmiStatus>(json['status'], EmiStatus.values),
      _dueDate = json['dueDate'] != null ? amplify_core.TemporalDate.fromString(json['dueDate']) : null,
      _isExtraEmi = json['isExtraEmi'],
      _loanID = json['loanID'],
      _ttl = json['ttl'] != null ? amplify_core.TemporalTimestamp.fromSeconds(json['ttl']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'emiNumber': _emiNumber, 'sub': _sub, 'customerName': _customerName, 'loanIdentity': _loanIdentity, 'emiAmount': _emiAmount, 'paidDate': _paidDate?.format(), 'updatedDate': _updatedDate?.format(), 'paidAmount': _paidAmount, 'initialAmount': _initialAmount, 'status': amplify_core.enumToString(_status), 'dueDate': _dueDate?.format(), 'isExtraEmi': _isExtraEmi, 'loanID': _loanID, 'ttl': _ttl?.toSeconds(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'emiNumber': _emiNumber,
    'sub': _sub,
    'customerName': _customerName,
    'loanIdentity': _loanIdentity,
    'emiAmount': _emiAmount,
    'paidDate': _paidDate,
    'updatedDate': _updatedDate,
    'paidAmount': _paidAmount,
    'initialAmount': _initialAmount,
    'status': _status,
    'dueDate': _dueDate,
    'isExtraEmi': _isExtraEmi,
    'loanID': _loanID,
    'ttl': _ttl,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<EmiModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<EmiModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final EMINUMBER = amplify_core.QueryField(fieldName: "emiNumber");
  static final SUB = amplify_core.QueryField(fieldName: "sub");
  static final CUSTOMERNAME = amplify_core.QueryField(fieldName: "customerName");
  static final LOANIDENTITY = amplify_core.QueryField(fieldName: "loanIdentity");
  static final EMIAMOUNT = amplify_core.QueryField(fieldName: "emiAmount");
  static final PAIDDATE = amplify_core.QueryField(fieldName: "paidDate");
  static final UPDATEDDATE = amplify_core.QueryField(fieldName: "updatedDate");
  static final PAIDAMOUNT = amplify_core.QueryField(fieldName: "paidAmount");
  static final INITIALAMOUNT = amplify_core.QueryField(fieldName: "initialAmount");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final DUEDATE = amplify_core.QueryField(fieldName: "dueDate");
  static final ISEXTRAEMI = amplify_core.QueryField(fieldName: "isExtraEmi");
  static final LOANID = amplify_core.QueryField(fieldName: "loanID");
  static final TTL = amplify_core.QueryField(fieldName: "ttl");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Emi";
    modelSchemaDefinition.pluralName = "Emis";
    
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
      amplify_core.ModelIndex(fields: const ["loanID"], name: "byLoan")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.EMINUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.SUB,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.CUSTOMERNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.LOANIDENTITY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.EMIAMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.PAIDDATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.UPDATEDDATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.PAIDAMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.INITIALAMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.STATUS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.DUEDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.ISEXTRAEMI,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.LOANID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Emi.TTL,
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

class _EmiModelType extends amplify_core.ModelType<Emi> {
  const _EmiModelType();
  
  @override
  Emi fromJson(Map<String, dynamic> jsonData) {
    return Emi.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Emi';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Emi] in your schema.
 */
class EmiModelIdentifier implements amplify_core.ModelIdentifier<Emi> {
  final String id;
  final String sub;

  /**
   * Create an instance of EmiModelIdentifier using [id] the primary key.
   * And [sub] the sort key.
   */
  const EmiModelIdentifier({
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
  String toString() => 'EmiModelIdentifier(id: $id, sub: $sub)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is EmiModelIdentifier &&
      id == other.id &&
      sub == other.sub;
  }
  
  @override
  int get hashCode =>
    id.hashCode ^
    sub.hashCode;
}