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

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'AppUser.dart';
import 'Circle.dart';
import 'City.dart';
import 'Customer.dart';
import 'Emi.dart';
import 'Loan.dart';
import 'LoanSerialNumber.dart';
import 'SubscriptionsDetails.dart';
import 'AppUserSubscriptionDetails.dart';
import 'CityDetails.dart';
import 'PaymentDetails.dart';

export 'AppUser.dart';
export 'AppUserSubscriptionDetails.dart';
export 'Circle.dart';
export 'City.dart';
export 'CityDetails.dart';
export 'Customer.dart';
export 'CustomerStatus.dart';
export 'Emi.dart';
export 'EmiStatus.dart';
export 'EmiType.dart';
export 'Loan.dart';
export 'LoanSerialNumber.dart';
export 'LoanStatus.dart';
export 'PaymentDetails.dart';
export 'SubscriptionsDetails.dart';
export 'WeekDay.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "a5daa589d2fc12c4bce424580b1bf44f";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [AppUser.schema, Circle.schema, City.schema, Customer.schema, Emi.schema, Loan.schema, LoanSerialNumber.schema, SubscriptionsDetails.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [AppUserSubscriptionDetails.schema, CityDetails.schema, PaymentDetails.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "AppUser":
        return AppUser.classType;
      case "Circle":
        return Circle.classType;
      case "City":
        return City.classType;
      case "Customer":
        return Customer.classType;
      case "Emi":
        return Emi.classType;
      case "Loan":
        return Loan.classType;
      case "LoanSerialNumber":
        return LoanSerialNumber.classType;
      case "SubscriptionsDetails":
        return SubscriptionsDetails.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
