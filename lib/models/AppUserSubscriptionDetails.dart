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


/** This is an auto generated class representing the AppUserSubscriptionDetails type in your schema. */
class AppUserSubscriptionDetails {
  final amplify_core.TemporalDate? _startDate;
  final amplify_core.TemporalDate? _endDate;
  final bool? _isActive;
  final bool? _subscribed;

  amplify_core.TemporalDate get startDate {
    try {
      return _startDate!;
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
  
  bool get isActive {
    try {
      return _isActive!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get subscribed {
    try {
      return _subscribed!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const AppUserSubscriptionDetails._internal({required startDate, required endDate, required isActive, required subscribed}): _startDate = startDate, _endDate = endDate, _isActive = isActive, _subscribed = subscribed;
  
  factory AppUserSubscriptionDetails({required amplify_core.TemporalDate startDate, required amplify_core.TemporalDate endDate, required bool isActive, required bool subscribed}) {
    return AppUserSubscriptionDetails._internal(
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      subscribed: subscribed);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppUserSubscriptionDetails &&
      _startDate == other._startDate &&
      _endDate == other._endDate &&
      _isActive == other._isActive &&
      _subscribed == other._subscribed;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AppUserSubscriptionDetails {");
    buffer.write("startDate=" + (_startDate != null ? _startDate!.format() : "null") + ", ");
    buffer.write("endDate=" + (_endDate != null ? _endDate!.format() : "null") + ", ");
    buffer.write("isActive=" + (_isActive != null ? _isActive!.toString() : "null") + ", ");
    buffer.write("subscribed=" + (_subscribed != null ? _subscribed!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AppUserSubscriptionDetails copyWith({amplify_core.TemporalDate? startDate, amplify_core.TemporalDate? endDate, bool? isActive, bool? subscribed}) {
    return AppUserSubscriptionDetails._internal(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      subscribed: subscribed ?? this.subscribed);
  }
  
  AppUserSubscriptionDetails copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDate>? startDate,
    ModelFieldValue<amplify_core.TemporalDate>? endDate,
    ModelFieldValue<bool>? isActive,
    ModelFieldValue<bool>? subscribed
  }) {
    return AppUserSubscriptionDetails._internal(
      startDate: startDate == null ? this.startDate : startDate.value,
      endDate: endDate == null ? this.endDate : endDate.value,
      isActive: isActive == null ? this.isActive : isActive.value,
      subscribed: subscribed == null ? this.subscribed : subscribed.value
    );
  }
  
  AppUserSubscriptionDetails.fromJson(Map<String, dynamic> json)  
    : _startDate = json['startDate'] != null ? amplify_core.TemporalDate.fromString(json['startDate']) : null,
      _endDate = json['endDate'] != null ? amplify_core.TemporalDate.fromString(json['endDate']) : null,
      _isActive = json['isActive'],
      _subscribed = json['subscribed'];
  
  Map<String, dynamic> toJson() => {
    'startDate': _startDate?.format(), 'endDate': _endDate?.format(), 'isActive': _isActive, 'subscribed': _subscribed
  };
  
  Map<String, Object?> toMap() => {
    'startDate': _startDate,
    'endDate': _endDate,
    'isActive': _isActive,
    'subscribed': _subscribed
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AppUserSubscriptionDetails";
    modelSchemaDefinition.pluralName = "AppUserSubscriptionDetails";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'startDate',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'endDate',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'isActive',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'subscribed',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
  });
}