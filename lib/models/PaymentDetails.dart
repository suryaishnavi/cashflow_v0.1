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


/** This is an auto generated class representing the PaymentDetails type in your schema. */
class PaymentDetails {
  final String id;
  final String? _customerID;
  final int? _emiAmount;
  final int? _paidAmount;
  final String? _loanIdentity;
  final amplify_core.TemporalDate? _paidDate;

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
  
  amplify_core.TemporalDate get paidDate {
    try {
      return _paidDate!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const PaymentDetails._internal({required this.id, required customerID, required emiAmount, required paidAmount, required loanIdentity, required paidDate}): _customerID = customerID, _emiAmount = emiAmount, _paidAmount = paidAmount, _loanIdentity = loanIdentity, _paidDate = paidDate;
  
  factory PaymentDetails({String? id, required String customerID, required int emiAmount, required int paidAmount, required String loanIdentity, required amplify_core.TemporalDate paidDate}) {
    return PaymentDetails._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      customerID: customerID,
      emiAmount: emiAmount,
      paidAmount: paidAmount,
      loanIdentity: loanIdentity,
      paidDate: paidDate);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentDetails &&
      id == other.id &&
      _customerID == other._customerID &&
      _emiAmount == other._emiAmount &&
      _paidAmount == other._paidAmount &&
      _loanIdentity == other._loanIdentity &&
      _paidDate == other._paidDate;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PaymentDetails {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("customerID=" + "$_customerID" + ", ");
    buffer.write("emiAmount=" + (_emiAmount != null ? _emiAmount!.toString() : "null") + ", ");
    buffer.write("paidAmount=" + (_paidAmount != null ? _paidAmount!.toString() : "null") + ", ");
    buffer.write("loanIdentity=" + "$_loanIdentity" + ", ");
    buffer.write("paidDate=" + (_paidDate != null ? _paidDate!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PaymentDetails copyWith({String? id, String? customerID, int? emiAmount, int? paidAmount, String? loanIdentity, amplify_core.TemporalDate? paidDate}) {
    return PaymentDetails._internal(
      id: id ?? this.id,
      customerID: customerID ?? this.customerID,
      emiAmount: emiAmount ?? this.emiAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      loanIdentity: loanIdentity ?? this.loanIdentity,
      paidDate: paidDate ?? this.paidDate);
  }
  
  PaymentDetails copyWithModelFieldValues({
    ModelFieldValue<String>? id,
    ModelFieldValue<String>? customerID,
    ModelFieldValue<int>? emiAmount,
    ModelFieldValue<int>? paidAmount,
    ModelFieldValue<String>? loanIdentity,
    ModelFieldValue<amplify_core.TemporalDate>? paidDate
  }) {
    return PaymentDetails._internal(
      id: id == null ? this.id : id.value,
      customerID: customerID == null ? this.customerID : customerID.value,
      emiAmount: emiAmount == null ? this.emiAmount : emiAmount.value,
      paidAmount: paidAmount == null ? this.paidAmount : paidAmount.value,
      loanIdentity: loanIdentity == null ? this.loanIdentity : loanIdentity.value,
      paidDate: paidDate == null ? this.paidDate : paidDate.value
    );
  }
  
  PaymentDetails.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _customerID = json['customerID'],
      _emiAmount = (json['emiAmount'] as num?)?.toInt(),
      _paidAmount = (json['paidAmount'] as num?)?.toInt(),
      _loanIdentity = json['loanIdentity'],
      _paidDate = json['paidDate'] != null ? amplify_core.TemporalDate.fromString(json['paidDate']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'customerID': _customerID, 'emiAmount': _emiAmount, 'paidAmount': _paidAmount, 'loanIdentity': _loanIdentity, 'paidDate': _paidDate?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'customerID': _customerID,
    'emiAmount': _emiAmount,
    'paidAmount': _paidAmount,
    'loanIdentity': _loanIdentity,
    'paidDate': _paidDate
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PaymentDetails";
    modelSchemaDefinition.pluralName = "PaymentDetails";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'id',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'customerID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'emiAmount',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'paidAmount',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'loanIdentity',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'paidDate',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
  });
}