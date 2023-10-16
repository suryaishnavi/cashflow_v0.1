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


/** This is an auto generated class representing the Circle type in your schema. */
class Circle extends amplify_core.Model {
  static const classType = const _CircleModelType();
  final String id;
  final String? _sub;
  final String? _circleName;
  final WeekDay? _day;
  final String? _appuserID;
  final List<City>? _cities;
  final List<Customer>? _customers;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  CircleModelIdentifier get modelIdentifier {
    try {
      return CircleModelIdentifier(
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
  
  String get circleName {
    try {
      return _circleName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  WeekDay get day {
    try {
      return _day!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get appuserID {
    try {
      return _appuserID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<City>? get cities {
    return _cities;
  }
  
  List<Customer>? get customers {
    return _customers;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Circle._internal({required this.id, required sub, required circleName, required day, required appuserID, cities, customers, createdAt, updatedAt}): _sub = sub, _circleName = circleName, _day = day, _appuserID = appuserID, _cities = cities, _customers = customers, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Circle({String? id, required String sub, required String circleName, required WeekDay day, required String appuserID, List<City>? cities, List<Customer>? customers}) {
    return Circle._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sub: sub,
      circleName: circleName,
      day: day,
      appuserID: appuserID,
      cities: cities != null ? List<City>.unmodifiable(cities) : cities,
      customers: customers != null ? List<Customer>.unmodifiable(customers) : customers);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Circle &&
      id == other.id &&
      _sub == other._sub &&
      _circleName == other._circleName &&
      _day == other._day &&
      _appuserID == other._appuserID &&
      DeepCollectionEquality().equals(_cities, other._cities) &&
      DeepCollectionEquality().equals(_customers, other._customers);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Circle {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sub=" + "$_sub" + ", ");
    buffer.write("circleName=" + "$_circleName" + ", ");
    buffer.write("day=" + (_day != null ? amplify_core.enumToString(_day)! : "null") + ", ");
    buffer.write("appuserID=" + "$_appuserID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Circle copyWith({String? circleName, WeekDay? day, String? appuserID, List<City>? cities, List<Customer>? customers}) {
    return Circle._internal(
      id: id,
      sub: sub,
      circleName: circleName ?? this.circleName,
      day: day ?? this.day,
      appuserID: appuserID ?? this.appuserID,
      cities: cities ?? this.cities,
      customers: customers ?? this.customers);
  }
  
  Circle copyWithModelFieldValues({
    ModelFieldValue<String>? circleName,
    ModelFieldValue<WeekDay>? day,
    ModelFieldValue<String>? appuserID,
    ModelFieldValue<List<City>?>? cities,
    ModelFieldValue<List<Customer>?>? customers
  }) {
    return Circle._internal(
      id: id,
      sub: sub,
      circleName: circleName == null ? this.circleName : circleName.value,
      day: day == null ? this.day : day.value,
      appuserID: appuserID == null ? this.appuserID : appuserID.value,
      cities: cities == null ? this.cities : cities.value,
      customers: customers == null ? this.customers : customers.value
    );
  }
  
  Circle.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sub = json['sub'],
      _circleName = json['circleName'],
      _day = amplify_core.enumFromString<WeekDay>(json['day'], WeekDay.values),
      _appuserID = json['appuserID'],
      _cities = json['cities'] is List
        ? (json['cities'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => City.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _customers = json['customers'] is List
        ? (json['customers'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Customer.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sub': _sub, 'circleName': _circleName, 'day': amplify_core.enumToString(_day), 'appuserID': _appuserID, 'cities': _cities?.map((City? e) => e?.toJson()).toList(), 'customers': _customers?.map((Customer? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sub': _sub,
    'circleName': _circleName,
    'day': _day,
    'appuserID': _appuserID,
    'cities': _cities,
    'customers': _customers,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<CircleModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<CircleModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SUB = amplify_core.QueryField(fieldName: "sub");
  static final CIRCLENAME = amplify_core.QueryField(fieldName: "circleName");
  static final DAY = amplify_core.QueryField(fieldName: "day");
  static final APPUSERID = amplify_core.QueryField(fieldName: "appuserID");
  static final CITIES = amplify_core.QueryField(
    fieldName: "cities",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'City'));
  static final CUSTOMERS = amplify_core.QueryField(
    fieldName: "customers",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Customer'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Circle";
    modelSchemaDefinition.pluralName = "Circles";
    
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
      amplify_core.ModelIndex(fields: const ["appuserID"], name: "byAppUser")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Circle.SUB,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Circle.CIRCLENAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Circle.DAY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Circle.APPUSERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Circle.CITIES,
      isRequired: false,
      ofModelName: 'City',
      associatedKey: City.CIRCLEID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Circle.CUSTOMERS,
      isRequired: false,
      ofModelName: 'Customer',
      associatedKey: Customer.CIRCLEID
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

class _CircleModelType extends amplify_core.ModelType<Circle> {
  const _CircleModelType();
  
  @override
  Circle fromJson(Map<String, dynamic> jsonData) {
    return Circle.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Circle';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Circle] in your schema.
 */
class CircleModelIdentifier implements amplify_core.ModelIdentifier<Circle> {
  final String id;
  final String sub;

  /**
   * Create an instance of CircleModelIdentifier using [id] the primary key.
   * And [sub] the sort key.
   */
  const CircleModelIdentifier({
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
  String toString() => 'CircleModelIdentifier(id: $id, sub: $sub)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is CircleModelIdentifier &&
      id == other.id &&
      sub == other.sub;
  }
  
  @override
  int get hashCode =>
    id.hashCode ^
    sub.hashCode;
}