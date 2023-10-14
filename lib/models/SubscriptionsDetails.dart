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


/** This is an auto generated class representing the SubscriptionsDetails type in your schema. */
class SubscriptionsDetails extends amplify_core.Model {
  static const classType = const _SubscriptionsDetailsModelType();
  final String id;
  final amplify_core.TemporalDate? _startDate;
  final amplify_core.TemporalDate? _endDate;
  final bool? _isActive;
  final String? _appUser;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SubscriptionsDetailsModelIdentifier get modelIdentifier {
    try {
      return SubscriptionsDetailsModelIdentifier(
        id: id,
        startDate: _startDate!
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
  
  String? get appUser {
    return _appUser;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SubscriptionsDetails._internal({required this.id, required startDate, required endDate, required isActive, appUser, createdAt, updatedAt}): _startDate = startDate, _endDate = endDate, _isActive = isActive, _appUser = appUser, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SubscriptionsDetails({String? id, required amplify_core.TemporalDate startDate, required amplify_core.TemporalDate endDate, required bool isActive, String? appUser}) {
    return SubscriptionsDetails._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      appUser: appUser);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubscriptionsDetails &&
      id == other.id &&
      _startDate == other._startDate &&
      _endDate == other._endDate &&
      _isActive == other._isActive &&
      _appUser == other._appUser;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SubscriptionsDetails {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("startDate=" + (_startDate != null ? _startDate!.format() : "null") + ", ");
    buffer.write("endDate=" + (_endDate != null ? _endDate!.format() : "null") + ", ");
    buffer.write("isActive=" + (_isActive != null ? _isActive!.toString() : "null") + ", ");
    buffer.write("appUser=" + "$_appUser" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SubscriptionsDetails copyWith({amplify_core.TemporalDate? endDate, bool? isActive, String? appUser}) {
    return SubscriptionsDetails._internal(
      id: id,
      startDate: startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      appUser: appUser ?? this.appUser);
  }
  
  SubscriptionsDetails copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDate>? endDate,
    ModelFieldValue<bool>? isActive,
    ModelFieldValue<String?>? appUser
  }) {
    return SubscriptionsDetails._internal(
      id: id,
      startDate: startDate,
      endDate: endDate == null ? this.endDate : endDate.value,
      isActive: isActive == null ? this.isActive : isActive.value,
      appUser: appUser == null ? this.appUser : appUser.value
    );
  }
  
  SubscriptionsDetails.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _startDate = json['startDate'] != null ? amplify_core.TemporalDate.fromString(json['startDate']) : null,
      _endDate = json['endDate'] != null ? amplify_core.TemporalDate.fromString(json['endDate']) : null,
      _isActive = json['isActive'],
      _appUser = json['appUser'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'startDate': _startDate?.format(), 'endDate': _endDate?.format(), 'isActive': _isActive, 'appUser': _appUser, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'startDate': _startDate,
    'endDate': _endDate,
    'isActive': _isActive,
    'appUser': _appUser,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SubscriptionsDetailsModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SubscriptionsDetailsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final STARTDATE = amplify_core.QueryField(fieldName: "startDate");
  static final ENDDATE = amplify_core.QueryField(fieldName: "endDate");
  static final ISACTIVE = amplify_core.QueryField(fieldName: "isActive");
  static final APPUSER = amplify_core.QueryField(fieldName: "appUser");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SubscriptionsDetails";
    modelSchemaDefinition.pluralName = "SubscriptionsDetails";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        provider: amplify_core.AuthRuleProvider.IAM,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id", "startDate"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubscriptionsDetails.STARTDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubscriptionsDetails.ENDDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubscriptionsDetails.ISACTIVE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SubscriptionsDetails.APPUSER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _SubscriptionsDetailsModelType extends amplify_core.ModelType<SubscriptionsDetails> {
  const _SubscriptionsDetailsModelType();
  
  @override
  SubscriptionsDetails fromJson(Map<String, dynamic> jsonData) {
    return SubscriptionsDetails.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SubscriptionsDetails';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SubscriptionsDetails] in your schema.
 */
class SubscriptionsDetailsModelIdentifier implements amplify_core.ModelIdentifier<SubscriptionsDetails> {
  final String id;
  final amplify_core.TemporalDate startDate;

  /**
   * Create an instance of SubscriptionsDetailsModelIdentifier using [id] the primary key.
   * And [startDate] the sort key.
   */
  const SubscriptionsDetailsModelIdentifier({
    required this.id,
    required this.startDate});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id,
    'startDate': startDate
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'SubscriptionsDetailsModelIdentifier(id: $id, startDate: $startDate)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SubscriptionsDetailsModelIdentifier &&
      id == other.id &&
      startDate == other.startDate;
  }
  
  @override
  int get hashCode =>
    id.hashCode ^
    startDate.hashCode;
}