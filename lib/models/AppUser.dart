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


/** This is an auto generated class representing the AppUser type in your schema. */
class AppUser extends amplify_core.Model {
  static const classType = const _AppUserModelType();
  final String id;
  final String? _name;
  final String? _owner;
  final String? _emailId;
  final String? _phoneNumber;
  final AppUserSubscriptionDetails? _appUserSubscriptionDetails;
  final List<Circle>? _circles;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AppUserModelIdentifier get modelIdentifier {
    try {
      return AppUserModelIdentifier(
        id: id,
        phoneNumber: _phoneNumber!
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
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get owner {
    try {
      return _owner!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get emailId {
    try {
      return _emailId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get phoneNumber {
    try {
      return _phoneNumber!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  AppUserSubscriptionDetails get appUserSubscriptionDetails {
    try {
      return _appUserSubscriptionDetails!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Circle>? get circles {
    return _circles;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const AppUser._internal({required this.id, required name, required owner, required emailId, required phoneNumber, required appUserSubscriptionDetails, circles, createdAt, updatedAt}): _name = name, _owner = owner, _emailId = emailId, _phoneNumber = phoneNumber, _appUserSubscriptionDetails = appUserSubscriptionDetails, _circles = circles, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory AppUser({String? id, required String name, required String owner, required String emailId, required String phoneNumber, required AppUserSubscriptionDetails appUserSubscriptionDetails, List<Circle>? circles}) {
    return AppUser._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      owner: owner,
      emailId: emailId,
      phoneNumber: phoneNumber,
      appUserSubscriptionDetails: appUserSubscriptionDetails,
      circles: circles != null ? List<Circle>.unmodifiable(circles) : circles);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppUser &&
      id == other.id &&
      _name == other._name &&
      _owner == other._owner &&
      _emailId == other._emailId &&
      _phoneNumber == other._phoneNumber &&
      _appUserSubscriptionDetails == other._appUserSubscriptionDetails &&
      DeepCollectionEquality().equals(_circles, other._circles);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AppUser {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("emailId=" + "$_emailId" + ", ");
    buffer.write("phoneNumber=" + "$_phoneNumber" + ", ");
    buffer.write("appUserSubscriptionDetails=" + (_appUserSubscriptionDetails != null ? _appUserSubscriptionDetails!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AppUser copyWith({String? name, String? owner, String? emailId, AppUserSubscriptionDetails? appUserSubscriptionDetails, List<Circle>? circles}) {
    return AppUser._internal(
      id: id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      emailId: emailId ?? this.emailId,
      phoneNumber: phoneNumber,
      appUserSubscriptionDetails: appUserSubscriptionDetails ?? this.appUserSubscriptionDetails,
      circles: circles ?? this.circles);
  }
  
  AppUser copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? owner,
    ModelFieldValue<String>? emailId,
    ModelFieldValue<AppUserSubscriptionDetails>? appUserSubscriptionDetails,
    ModelFieldValue<List<Circle>?>? circles
  }) {
    return AppUser._internal(
      id: id,
      name: name == null ? this.name : name.value,
      owner: owner == null ? this.owner : owner.value,
      emailId: emailId == null ? this.emailId : emailId.value,
      phoneNumber: phoneNumber,
      appUserSubscriptionDetails: appUserSubscriptionDetails == null ? this.appUserSubscriptionDetails : appUserSubscriptionDetails.value,
      circles: circles == null ? this.circles : circles.value
    );
  }
  
  AppUser.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _owner = json['owner'],
      _emailId = json['emailId'],
      _phoneNumber = json['phoneNumber'],
      _appUserSubscriptionDetails = json['appUserSubscriptionDetails']?['serializedData'] != null
        ? AppUserSubscriptionDetails.fromJson(new Map<String, dynamic>.from(json['appUserSubscriptionDetails']['serializedData']))
        : null,
      _circles = json['circles'] is List
        ? (json['circles'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Circle.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'owner': _owner, 'emailId': _emailId, 'phoneNumber': _phoneNumber, 'appUserSubscriptionDetails': _appUserSubscriptionDetails?.toJson(), 'circles': _circles?.map((Circle? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'owner': _owner,
    'emailId': _emailId,
    'phoneNumber': _phoneNumber,
    'appUserSubscriptionDetails': _appUserSubscriptionDetails,
    'circles': _circles,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AppUserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AppUserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final OWNER = amplify_core.QueryField(fieldName: "owner");
  static final EMAILID = amplify_core.QueryField(fieldName: "emailId");
  static final PHONENUMBER = amplify_core.QueryField(fieldName: "phoneNumber");
  static final APPUSERSUBSCRIPTIONDETAILS = amplify_core.QueryField(fieldName: "appUserSubscriptionDetails");
  static final CIRCLES = amplify_core.QueryField(
    fieldName: "circles",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Circle'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AppUser";
    modelSchemaDefinition.pluralName = "AppUsers";
    
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
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id", "phoneNumber"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AppUser.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AppUser.OWNER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AppUser.EMAILID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AppUser.PHONENUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'appUserSubscriptionDetails',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embedded, ofCustomTypeName: 'AppUserSubscriptionDetails')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: AppUser.CIRCLES,
      isRequired: false,
      ofModelName: 'Circle',
      associatedKey: Circle.APPUSERID
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

class _AppUserModelType extends amplify_core.ModelType<AppUser> {
  const _AppUserModelType();
  
  @override
  AppUser fromJson(Map<String, dynamic> jsonData) {
    return AppUser.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'AppUser';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [AppUser] in your schema.
 */
class AppUserModelIdentifier implements amplify_core.ModelIdentifier<AppUser> {
  final String id;
  final String phoneNumber;

  /**
   * Create an instance of AppUserModelIdentifier using [id] the primary key.
   * And [phoneNumber] the sort key.
   */
  const AppUserModelIdentifier({
    required this.id,
    required this.phoneNumber});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id,
    'phoneNumber': phoneNumber
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'AppUserModelIdentifier(id: $id, phoneNumber: $phoneNumber)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AppUserModelIdentifier &&
      id == other.id &&
      phoneNumber == other.phoneNumber;
  }
  
  @override
  int get hashCode =>
    id.hashCode ^
    phoneNumber.hashCode;
}