// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubscriptionPlansTableTable extends SubscriptionPlansTable
    with TableInfo<$SubscriptionPlansTableTable, SubscriptionPlansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionPlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _maxUsersMeta =
      const VerificationMeta('maxUsers');
  @override
  late final GeneratedColumn<int> maxUsers = GeneratedColumn<int>(
      'max_users', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _maxProductsMeta =
      const VerificationMeta('maxProducts');
  @override
  late final GeneratedColumn<int> maxProducts = GeneratedColumn<int>(
      'max_products', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _featuresMeta =
      const VerificationMeta('features');
  @override
  late final GeneratedColumn<String> features = GeneratedColumn<String>(
      'features', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, maxUsers, maxProducts, features, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscription_plans';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubscriptionPlansTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('max_users')) {
      context.handle(_maxUsersMeta,
          maxUsers.isAcceptableOrUnknown(data['max_users']!, _maxUsersMeta));
    }
    if (data.containsKey('max_products')) {
      context.handle(
          _maxProductsMeta,
          maxProducts.isAcceptableOrUnknown(
              data['max_products']!, _maxProductsMeta));
    }
    if (data.containsKey('features')) {
      context.handle(_featuresMeta,
          features.isAcceptableOrUnknown(data['features']!, _featuresMeta));
    } else if (isInserting) {
      context.missing(_featuresMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionPlansTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionPlansTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      maxUsers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_users']),
      maxProducts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_products']),
      features: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}features'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SubscriptionPlansTableTable createAlias(String alias) {
    return $SubscriptionPlansTableTable(attachedDatabase, alias);
  }
}

class SubscriptionPlansTableData extends DataClass
    implements Insertable<SubscriptionPlansTableData> {
  final String id;
  final String name;
  final int? maxUsers;
  final int? maxProducts;
  final String features;
  final DateTime createdAt;
  const SubscriptionPlansTableData(
      {required this.id,
      required this.name,
      this.maxUsers,
      this.maxProducts,
      required this.features,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || maxUsers != null) {
      map['max_users'] = Variable<int>(maxUsers);
    }
    if (!nullToAbsent || maxProducts != null) {
      map['max_products'] = Variable<int>(maxProducts);
    }
    map['features'] = Variable<String>(features);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SubscriptionPlansTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionPlansTableCompanion(
      id: Value(id),
      name: Value(name),
      maxUsers: maxUsers == null && nullToAbsent
          ? const Value.absent()
          : Value(maxUsers),
      maxProducts: maxProducts == null && nullToAbsent
          ? const Value.absent()
          : Value(maxProducts),
      features: Value(features),
      createdAt: Value(createdAt),
    );
  }

  factory SubscriptionPlansTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionPlansTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      maxUsers: serializer.fromJson<int?>(json['maxUsers']),
      maxProducts: serializer.fromJson<int?>(json['maxProducts']),
      features: serializer.fromJson<String>(json['features']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'maxUsers': serializer.toJson<int?>(maxUsers),
      'maxProducts': serializer.toJson<int?>(maxProducts),
      'features': serializer.toJson<String>(features),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SubscriptionPlansTableData copyWith(
          {String? id,
          String? name,
          Value<int?> maxUsers = const Value.absent(),
          Value<int?> maxProducts = const Value.absent(),
          String? features,
          DateTime? createdAt}) =>
      SubscriptionPlansTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        maxUsers: maxUsers.present ? maxUsers.value : this.maxUsers,
        maxProducts: maxProducts.present ? maxProducts.value : this.maxProducts,
        features: features ?? this.features,
        createdAt: createdAt ?? this.createdAt,
      );
  SubscriptionPlansTableData copyWithCompanion(
      SubscriptionPlansTableCompanion data) {
    return SubscriptionPlansTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      maxUsers: data.maxUsers.present ? data.maxUsers.value : this.maxUsers,
      maxProducts:
          data.maxProducts.present ? data.maxProducts.value : this.maxProducts,
      features: data.features.present ? data.features.value : this.features,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionPlansTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maxUsers: $maxUsers, ')
          ..write('maxProducts: $maxProducts, ')
          ..write('features: $features, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, maxUsers, maxProducts, features, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionPlansTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.maxUsers == this.maxUsers &&
          other.maxProducts == this.maxProducts &&
          other.features == this.features &&
          other.createdAt == this.createdAt);
}

class SubscriptionPlansTableCompanion
    extends UpdateCompanion<SubscriptionPlansTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> maxUsers;
  final Value<int?> maxProducts;
  final Value<String> features;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SubscriptionPlansTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.maxUsers = const Value.absent(),
    this.maxProducts = const Value.absent(),
    this.features = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionPlansTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.maxUsers = const Value.absent(),
    this.maxProducts = const Value.absent(),
    required String features,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        features = Value(features);
  static Insertable<SubscriptionPlansTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? maxUsers,
    Expression<int>? maxProducts,
    Expression<String>? features,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (maxUsers != null) 'max_users': maxUsers,
      if (maxProducts != null) 'max_products': maxProducts,
      if (features != null) 'features': features,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionPlansTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int?>? maxUsers,
      Value<int?>? maxProducts,
      Value<String>? features,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SubscriptionPlansTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      maxUsers: maxUsers ?? this.maxUsers,
      maxProducts: maxProducts ?? this.maxProducts,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (maxUsers.present) {
      map['max_users'] = Variable<int>(maxUsers.value);
    }
    if (maxProducts.present) {
      map['max_products'] = Variable<int>(maxProducts.value);
    }
    if (features.present) {
      map['features'] = Variable<String>(features.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionPlansTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maxUsers: $maxUsers, ')
          ..write('maxProducts: $maxProducts, ')
          ..write('features: $features, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TenantsTableTable extends TenantsTable
    with TableInfo<$TenantsTableTable, TenantsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _storeTypeMeta =
      const VerificationMeta('storeType');
  @override
  late final GeneratedColumn<String> storeType = GeneratedColumn<String>(
      'store_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
      'plan_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _defaultLangMeta =
      const VerificationMeta('defaultLang');
  @override
  late final GeneratedColumn<String> defaultLang = GeneratedColumn<String>(
      'default_lang', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('lo'));
  static const VerificationMeta _baseCurrencyMeta =
      const VerificationMeta('baseCurrency');
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
      'base_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('LAK'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        storeType,
        planId,
        status,
        defaultLang,
        baseCurrency,
        createdAt,
        expiresAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(Insertable<TenantsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('store_type')) {
      context.handle(_storeTypeMeta,
          storeType.isAcceptableOrUnknown(data['store_type']!, _storeTypeMeta));
    } else if (isInserting) {
      context.missing(_storeTypeMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('default_lang')) {
      context.handle(
          _defaultLangMeta,
          defaultLang.isAcceptableOrUnknown(
              data['default_lang']!, _defaultLangMeta));
    }
    if (data.containsKey('base_currency')) {
      context.handle(
          _baseCurrencyMeta,
          baseCurrency.isAcceptableOrUnknown(
              data['base_currency']!, _baseCurrencyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TenantsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TenantsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      storeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store_type'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      defaultLang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_lang'])!,
      baseCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_currency'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $TenantsTableTable createAlias(String alias) {
    return $TenantsTableTable(attachedDatabase, alias);
  }
}

class TenantsTableData extends DataClass
    implements Insertable<TenantsTableData> {
  final String id;
  final String name;
  final String storeType;
  final String? planId;
  final String status;
  final String defaultLang;
  final String baseCurrency;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const TenantsTableData(
      {required this.id,
      required this.name,
      required this.storeType,
      this.planId,
      required this.status,
      required this.defaultLang,
      required this.baseCurrency,
      required this.createdAt,
      this.expiresAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['store_type'] = Variable<String>(storeType);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<String>(planId);
    }
    map['status'] = Variable<String>(status);
    map['default_lang'] = Variable<String>(defaultLang);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  TenantsTableCompanion toCompanion(bool nullToAbsent) {
    return TenantsTableCompanion(
      id: Value(id),
      name: Value(name),
      storeType: Value(storeType),
      planId:
          planId == null && nullToAbsent ? const Value.absent() : Value(planId),
      status: Value(status),
      defaultLang: Value(defaultLang),
      baseCurrency: Value(baseCurrency),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory TenantsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TenantsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      storeType: serializer.fromJson<String>(json['storeType']),
      planId: serializer.fromJson<String?>(json['planId']),
      status: serializer.fromJson<String>(json['status']),
      defaultLang: serializer.fromJson<String>(json['defaultLang']),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'storeType': serializer.toJson<String>(storeType),
      'planId': serializer.toJson<String?>(planId),
      'status': serializer.toJson<String>(status),
      'defaultLang': serializer.toJson<String>(defaultLang),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  TenantsTableData copyWith(
          {String? id,
          String? name,
          String? storeType,
          Value<String?> planId = const Value.absent(),
          String? status,
          String? defaultLang,
          String? baseCurrency,
          DateTime? createdAt,
          Value<DateTime?> expiresAt = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      TenantsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        storeType: storeType ?? this.storeType,
        planId: planId.present ? planId.value : this.planId,
        status: status ?? this.status,
        defaultLang: defaultLang ?? this.defaultLang,
        baseCurrency: baseCurrency ?? this.baseCurrency,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  TenantsTableData copyWithCompanion(TenantsTableCompanion data) {
    return TenantsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      storeType: data.storeType.present ? data.storeType.value : this.storeType,
      planId: data.planId.present ? data.planId.value : this.planId,
      status: data.status.present ? data.status.value : this.status,
      defaultLang:
          data.defaultLang.present ? data.defaultLang.value : this.defaultLang,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TenantsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('storeType: $storeType, ')
          ..write('planId: $planId, ')
          ..write('status: $status, ')
          ..write('defaultLang: $defaultLang, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      storeType,
      planId,
      status,
      defaultLang,
      baseCurrency,
      createdAt,
      expiresAt,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TenantsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.storeType == this.storeType &&
          other.planId == this.planId &&
          other.status == this.status &&
          other.defaultLang == this.defaultLang &&
          other.baseCurrency == this.baseCurrency &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class TenantsTableCompanion extends UpdateCompanion<TenantsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> storeType;
  final Value<String?> planId;
  final Value<String> status;
  final Value<String> defaultLang;
  final Value<String> baseCurrency;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const TenantsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.storeType = const Value.absent(),
    this.planId = const Value.absent(),
    this.status = const Value.absent(),
    this.defaultLang = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String storeType,
    this.planId = const Value.absent(),
    this.status = const Value.absent(),
    this.defaultLang = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        storeType = Value(storeType);
  static Insertable<TenantsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? storeType,
    Expression<String>? planId,
    Expression<String>? status,
    Expression<String>? defaultLang,
    Expression<String>? baseCurrency,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (storeType != null) 'store_type': storeType,
      if (planId != null) 'plan_id': planId,
      if (status != null) 'status': status,
      if (defaultLang != null) 'default_lang': defaultLang,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? storeType,
      Value<String?>? planId,
      Value<String>? status,
      Value<String>? defaultLang,
      Value<String>? baseCurrency,
      Value<DateTime>? createdAt,
      Value<DateTime?>? expiresAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return TenantsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      storeType: storeType ?? this.storeType,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      defaultLang: defaultLang ?? this.defaultLang,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (storeType.present) {
      map['store_type'] = Variable<String>(storeType.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (defaultLang.present) {
      map['default_lang'] = Variable<String>(defaultLang.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('storeType: $storeType, ')
          ..write('planId: $planId, ')
          ..write('status: $status, ')
          ..write('defaultLang: $defaultLang, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _failedPinAttemptsMeta =
      const VerificationMeta('failedPinAttempts');
  @override
  late final GeneratedColumn<int> failedPinAttempts = GeneratedColumn<int>(
      'failed_pin_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lockedUntilMeta =
      const VerificationMeta('lockedUntil');
  @override
  late final GeneratedColumn<DateTime> lockedUntil = GeneratedColumn<DateTime>(
      'locked_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        username,
        displayName,
        role,
        pinHash,
        isActive,
        failedPinAttempts,
        lockedUntil,
        createdAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<UsersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('failed_pin_attempts')) {
      context.handle(
          _failedPinAttemptsMeta,
          failedPinAttempts.isAcceptableOrUnknown(
              data['failed_pin_attempts']!, _failedPinAttemptsMeta));
    }
    if (data.containsKey('locked_until')) {
      context.handle(
          _lockedUntilMeta,
          lockedUntil.isAcceptableOrUnknown(
              data['locked_until']!, _lockedUntilMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      failedPinAttempts: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}failed_pin_attempts'])!,
      lockedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}locked_until']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String tenantId;
  final String username;
  final String displayName;
  final String role;
  final String pinHash;
  final bool isActive;
  final int failedPinAttempts;
  final DateTime? lockedUntil;
  final DateTime createdAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const UsersTableData(
      {required this.id,
      required this.tenantId,
      required this.username,
      required this.displayName,
      required this.role,
      required this.pinHash,
      required this.isActive,
      required this.failedPinAttempts,
      this.lockedUntil,
      required this.createdAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    map['is_active'] = Variable<bool>(isActive);
    map['failed_pin_attempts'] = Variable<int>(failedPinAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<DateTime>(lockedUntil);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      username: Value(username),
      displayName: Value(displayName),
      role: Value(role),
      pinHash: Value(pinHash),
      isActive: Value(isActive),
      failedPinAttempts: Value(failedPinAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory UsersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String>(json['displayName']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      failedPinAttempts: serializer.fromJson<int>(json['failedPinAttempts']),
      lockedUntil: serializer.fromJson<DateTime?>(json['lockedUntil']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String>(displayName),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'isActive': serializer.toJson<bool>(isActive),
      'failedPinAttempts': serializer.toJson<int>(failedPinAttempts),
      'lockedUntil': serializer.toJson<DateTime?>(lockedUntil),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  UsersTableData copyWith(
          {String? id,
          String? tenantId,
          String? username,
          String? displayName,
          String? role,
          String? pinHash,
          bool? isActive,
          int? failedPinAttempts,
          Value<DateTime?> lockedUntil = const Value.absent(),
          DateTime? createdAt,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      UsersTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        role: role ?? this.role,
        pinHash: pinHash ?? this.pinHash,
        isActive: isActive ?? this.isActive,
        failedPinAttempts: failedPinAttempts ?? this.failedPinAttempts,
        lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      username: data.username.present ? data.username.value : this.username,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      failedPinAttempts: data.failedPinAttempts.present
          ? data.failedPinAttempts.value
          : this.failedPinAttempts,
      lockedUntil:
          data.lockedUntil.present ? data.lockedUntil.value : this.lockedUntil,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('failedPinAttempts: $failedPinAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      username,
      displayName,
      role,
      pinHash,
      isActive,
      failedPinAttempts,
      lockedUntil,
      createdAt,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.isActive == this.isActive &&
          other.failedPinAttempts == this.failedPinAttempts &&
          other.lockedUntil == this.lockedUntil &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<bool> isActive;
  final Value<int> failedPinAttempts;
  final Value<DateTime?> lockedUntil;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.failedPinAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String username,
    required String displayName,
    required String role,
    required String pinHash,
    this.isActive = const Value.absent(),
    this.failedPinAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        username = Value(username),
        displayName = Value(displayName),
        role = Value(role),
        pinHash = Value(pinHash);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<bool>? isActive,
    Expression<int>? failedPinAttempts,
    Expression<DateTime>? lockedUntil,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (isActive != null) 'is_active': isActive,
      if (failedPinAttempts != null) 'failed_pin_attempts': failedPinAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? username,
      Value<String>? displayName,
      Value<String>? role,
      Value<String>? pinHash,
      Value<bool>? isActive,
      Value<int>? failedPinAttempts,
      Value<DateTime?>? lockedUntil,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return UsersTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      isActive: isActive ?? this.isActive,
      failedPinAttempts: failedPinAttempts ?? this.failedPinAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (failedPinAttempts.present) {
      map['failed_pin_attempts'] = Variable<int>(failedPinAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<DateTime>(lockedUntil.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('failedPinAttempts: $failedPinAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        parentId,
        name,
        sortOrder,
        isActive,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String id;
  final String tenantId;
  final String? parentId;
  final String name;
  final int sortOrder;
  final bool isActive;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const CategoriesTableData(
      {required this.id,
      required this.tenantId,
      this.parentId,
      required this.name,
      required this.sortOrder,
      required this.isActive,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  CategoriesTableData copyWith(
          {String? id,
          String? tenantId,
          Value<String?> parentId = const Value.absent(),
          String? name,
          int? sortOrder,
          bool? isActive,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      CategoriesTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        parentId: parentId.present ? parentId.value : this.parentId,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, parentId, name, sortOrder,
      isActive, isSynced, localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    this.parentId = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        name = Value(name);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String?>? parentId,
      Value<String>? name,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sellPriceMeta =
      const VerificationMeta('sellPrice');
  @override
  late final GeneratedColumn<double> sellPrice = GeneratedColumn<double>(
      'sell_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _minStockMeta =
      const VerificationMeta('minStock');
  @override
  late final GeneratedColumn<int> minStock = GeneratedColumn<int>(
      'min_stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _hasVariantsMeta =
      const VerificationMeta('hasVariants');
  @override
  late final GeneratedColumn<bool> hasVariants = GeneratedColumn<bool>(
      'has_variants', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_variants" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        name,
        description,
        barcode,
        sellPrice,
        costPrice,
        unit,
        minStock,
        isActive,
        hasVariants,
        createdAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<ProductsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('sell_price')) {
      context.handle(_sellPriceMeta,
          sellPrice.isAcceptableOrUnknown(data['sell_price']!, _sellPriceMeta));
    } else if (isInserting) {
      context.missing(_sellPriceMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('min_stock')) {
      context.handle(_minStockMeta,
          minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('has_variants')) {
      context.handle(
          _hasVariantsMeta,
          hasVariants.isAcceptableOrUnknown(
              data['has_variants']!, _hasVariantsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      sellPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sell_price'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      minStock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}min_stock'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      hasVariants: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_variants'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductsTableData extends DataClass
    implements Insertable<ProductsTableData> {
  final String id;
  final String tenantId;
  final String name;
  final String? description;
  final String? barcode;
  final double sellPrice;
  final double? costPrice;
  final String? unit;
  final int minStock;
  final bool isActive;
  final bool hasVariants;
  final DateTime createdAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const ProductsTableData(
      {required this.id,
      required this.tenantId,
      required this.name,
      this.description,
      this.barcode,
      required this.sellPrice,
      this.costPrice,
      this.unit,
      required this.minStock,
      required this.isActive,
      required this.hasVariants,
      required this.createdAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['sell_price'] = Variable<double>(sellPrice);
    if (!nullToAbsent || costPrice != null) {
      map['cost_price'] = Variable<double>(costPrice);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['min_stock'] = Variable<int>(minStock);
    map['is_active'] = Variable<bool>(isActive);
    map['has_variants'] = Variable<bool>(hasVariants);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      sellPrice: Value(sellPrice),
      costPrice: costPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(costPrice),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      minStock: Value(minStock),
      isActive: Value(isActive),
      hasVariants: Value(hasVariants),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory ProductsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      sellPrice: serializer.fromJson<double>(json['sellPrice']),
      costPrice: serializer.fromJson<double?>(json['costPrice']),
      unit: serializer.fromJson<String?>(json['unit']),
      minStock: serializer.fromJson<int>(json['minStock']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      hasVariants: serializer.fromJson<bool>(json['hasVariants']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'barcode': serializer.toJson<String?>(barcode),
      'sellPrice': serializer.toJson<double>(sellPrice),
      'costPrice': serializer.toJson<double?>(costPrice),
      'unit': serializer.toJson<String?>(unit),
      'minStock': serializer.toJson<int>(minStock),
      'isActive': serializer.toJson<bool>(isActive),
      'hasVariants': serializer.toJson<bool>(hasVariants),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  ProductsTableData copyWith(
          {String? id,
          String? tenantId,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          double? sellPrice,
          Value<double?> costPrice = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          int? minStock,
          bool? isActive,
          bool? hasVariants,
          DateTime? createdAt,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      ProductsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        barcode: barcode.present ? barcode.value : this.barcode,
        sellPrice: sellPrice ?? this.sellPrice,
        costPrice: costPrice.present ? costPrice.value : this.costPrice,
        unit: unit.present ? unit.value : this.unit,
        minStock: minStock ?? this.minStock,
        isActive: isActive ?? this.isActive,
        hasVariants: hasVariants ?? this.hasVariants,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  ProductsTableData copyWithCompanion(ProductsTableCompanion data) {
    return ProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      sellPrice: data.sellPrice.present ? data.sellPrice.value : this.sellPrice,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      unit: data.unit.present ? data.unit.value : this.unit,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      hasVariants:
          data.hasVariants.present ? data.hasVariants.value : this.hasVariants,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('barcode: $barcode, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('unit: $unit, ')
          ..write('minStock: $minStock, ')
          ..write('isActive: $isActive, ')
          ..write('hasVariants: $hasVariants, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      name,
      description,
      barcode,
      sellPrice,
      costPrice,
      unit,
      minStock,
      isActive,
      hasVariants,
      createdAt,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.description == this.description &&
          other.barcode == this.barcode &&
          other.sellPrice == this.sellPrice &&
          other.costPrice == this.costPrice &&
          other.unit == this.unit &&
          other.minStock == this.minStock &&
          other.isActive == this.isActive &&
          other.hasVariants == this.hasVariants &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class ProductsTableCompanion extends UpdateCompanion<ProductsTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> barcode;
  final Value<double> sellPrice;
  final Value<double?> costPrice;
  final Value<String?> unit;
  final Value<int> minStock;
  final Value<bool> isActive;
  final Value<bool> hasVariants;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.barcode = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.unit = const Value.absent(),
    this.minStock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hasVariants = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String name,
    this.description = const Value.absent(),
    this.barcode = const Value.absent(),
    required double sellPrice,
    this.costPrice = const Value.absent(),
    this.unit = const Value.absent(),
    this.minStock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hasVariants = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        name = Value(name),
        sellPrice = Value(sellPrice);
  static Insertable<ProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? barcode,
    Expression<double>? sellPrice,
    Expression<double>? costPrice,
    Expression<String>? unit,
    Expression<int>? minStock,
    Expression<bool>? isActive,
    Expression<bool>? hasVariants,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (barcode != null) 'barcode': barcode,
      if (sellPrice != null) 'sell_price': sellPrice,
      if (costPrice != null) 'cost_price': costPrice,
      if (unit != null) 'unit': unit,
      if (minStock != null) 'min_stock': minStock,
      if (isActive != null) 'is_active': isActive,
      if (hasVariants != null) 'has_variants': hasVariants,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? barcode,
      Value<double>? sellPrice,
      Value<double?>? costPrice,
      Value<String?>? unit,
      Value<int>? minStock,
      Value<bool>? isActive,
      Value<bool>? hasVariants,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      sellPrice: sellPrice ?? this.sellPrice,
      costPrice: costPrice ?? this.costPrice,
      unit: unit ?? this.unit,
      minStock: minStock ?? this.minStock,
      isActive: isActive ?? this.isActive,
      hasVariants: hasVariants ?? this.hasVariants,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (sellPrice.present) {
      map['sell_price'] = Variable<double>(sellPrice.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<int>(minStock.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (hasVariants.present) {
      map['has_variants'] = Variable<bool>(hasVariants.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('barcode: $barcode, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('unit: $unit, ')
          ..write('minStock: $minStock, ')
          ..write('isActive: $isActive, ')
          ..write('hasVariants: $hasVariants, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductVariantsTableTable extends ProductVariantsTable
    with TableInfo<$ProductVariantsTableTable, ProductVariantsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductVariantsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sellPriceMeta =
      const VerificationMeta('sellPrice');
  @override
  late final GeneratedColumn<double> sellPrice = GeneratedColumn<double>(
      'sell_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stockQtyMeta =
      const VerificationMeta('stockQty');
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
      'stock_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        tenantId,
        name,
        barcode,
        sellPrice,
        costPrice,
        stockQty,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_variants';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductVariantsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('sell_price')) {
      context.handle(_sellPriceMeta,
          sellPrice.isAcceptableOrUnknown(data['sell_price']!, _sellPriceMeta));
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    }
    if (data.containsKey('stock_qty')) {
      context.handle(_stockQtyMeta,
          stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductVariantsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductVariantsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      sellPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sell_price']),
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price']),
      stockQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_qty'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $ProductVariantsTableTable createAlias(String alias) {
    return $ProductVariantsTableTable(attachedDatabase, alias);
  }
}

class ProductVariantsTableData extends DataClass
    implements Insertable<ProductVariantsTableData> {
  final String id;
  final String productId;
  final String tenantId;
  final String name;
  final String? barcode;
  final double? sellPrice;
  final double? costPrice;
  final int stockQty;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const ProductVariantsTableData(
      {required this.id,
      required this.productId,
      required this.tenantId,
      required this.name,
      this.barcode,
      this.sellPrice,
      this.costPrice,
      required this.stockQty,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['tenant_id'] = Variable<String>(tenantId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || sellPrice != null) {
      map['sell_price'] = Variable<double>(sellPrice);
    }
    if (!nullToAbsent || costPrice != null) {
      map['cost_price'] = Variable<double>(costPrice);
    }
    map['stock_qty'] = Variable<int>(stockQty);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  ProductVariantsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductVariantsTableCompanion(
      id: Value(id),
      productId: Value(productId),
      tenantId: Value(tenantId),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      sellPrice: sellPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(sellPrice),
      costPrice: costPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(costPrice),
      stockQty: Value(stockQty),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory ProductVariantsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductVariantsTableData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      sellPrice: serializer.fromJson<double?>(json['sellPrice']),
      costPrice: serializer.fromJson<double?>(json['costPrice']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'tenantId': serializer.toJson<String>(tenantId),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'sellPrice': serializer.toJson<double?>(sellPrice),
      'costPrice': serializer.toJson<double?>(costPrice),
      'stockQty': serializer.toJson<int>(stockQty),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  ProductVariantsTableData copyWith(
          {String? id,
          String? productId,
          String? tenantId,
          String? name,
          Value<String?> barcode = const Value.absent(),
          Value<double?> sellPrice = const Value.absent(),
          Value<double?> costPrice = const Value.absent(),
          int? stockQty,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      ProductVariantsTableData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        tenantId: tenantId ?? this.tenantId,
        name: name ?? this.name,
        barcode: barcode.present ? barcode.value : this.barcode,
        sellPrice: sellPrice.present ? sellPrice.value : this.sellPrice,
        costPrice: costPrice.present ? costPrice.value : this.costPrice,
        stockQty: stockQty ?? this.stockQty,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  ProductVariantsTableData copyWithCompanion(
      ProductVariantsTableCompanion data) {
    return ProductVariantsTableData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      sellPrice: data.sellPrice.present ? data.sellPrice.value : this.sellPrice,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantsTableData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, tenantId, name, barcode,
      sellPrice, costPrice, stockQty, isSynced, localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductVariantsTableData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.sellPrice == this.sellPrice &&
          other.costPrice == this.costPrice &&
          other.stockQty == this.stockQty &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class ProductVariantsTableCompanion
    extends UpdateCompanion<ProductVariantsTableData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> tenantId;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<double?> sellPrice;
  final Value<double?> costPrice;
  final Value<int> stockQty;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const ProductVariantsTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductVariantsTableCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    required String tenantId,
    required String name,
    this.barcode = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : productId = Value(productId),
        tenantId = Value(tenantId),
        name = Value(name);
  static Insertable<ProductVariantsTableData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? tenantId,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<double>? sellPrice,
    Expression<double>? costPrice,
    Expression<int>? stockQty,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (sellPrice != null) 'sell_price': sellPrice,
      if (costPrice != null) 'cost_price': costPrice,
      if (stockQty != null) 'stock_qty': stockQty,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductVariantsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? tenantId,
      Value<String>? name,
      Value<String?>? barcode,
      Value<double?>? sellPrice,
      Value<double?>? costPrice,
      Value<int>? stockQty,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return ProductVariantsTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      sellPrice: sellPrice ?? this.sellPrice,
      costPrice: costPrice ?? this.costPrice,
      stockQty: stockQty ?? this.stockQty,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (sellPrice.present) {
      map['sell_price'] = Variable<double>(sellPrice.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantsTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderNumberMeta =
      const VerificationMeta('orderNumber');
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
      'order_number', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<String> tableId = GeneratedColumn<String>(
      'table_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cashierIdMeta =
      const VerificationMeta('cashierId');
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
      'cashier_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        orderNumber,
        tableId,
        cashierId,
        shiftId,
        status,
        subtotal,
        discountAmount,
        taxAmount,
        total,
        notes,
        idempotencyKey,
        createdAt,
        paidAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<OrdersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('order_number')) {
      context.handle(
          _orderNumberMeta,
          orderNumber.isAcceptableOrUnknown(
              data['order_number']!, _orderNumberMeta));
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    }
    if (data.containsKey('cashier_id')) {
      context.handle(_cashierIdMeta,
          cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta));
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      orderNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_number'])!,
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_id']),
      cashierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cashier_id'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shift_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      idempotencyKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}idempotency_key']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrdersTableData extends DataClass implements Insertable<OrdersTableData> {
  final String id;
  final String tenantId;
  final String orderNumber;
  final String? tableId;
  final String cashierId;
  final String? shiftId;
  final String status;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double total;
  final String? notes;
  final String? idempotencyKey;
  final DateTime createdAt;
  final DateTime? paidAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const OrdersTableData(
      {required this.id,
      required this.tenantId,
      required this.orderNumber,
      this.tableId,
      required this.cashierId,
      this.shiftId,
      required this.status,
      required this.subtotal,
      required this.discountAmount,
      required this.taxAmount,
      required this.total,
      this.notes,
      this.idempotencyKey,
      required this.createdAt,
      this.paidAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['order_number'] = Variable<String>(orderNumber);
    if (!nullToAbsent || tableId != null) {
      map['table_id'] = Variable<String>(tableId);
    }
    map['cashier_id'] = Variable<String>(cashierId);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<String>(shiftId);
    }
    map['status'] = Variable<String>(status);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['total'] = Variable<double>(total);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || idempotencyKey != null) {
      map['idempotency_key'] = Variable<String>(idempotencyKey);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      orderNumber: Value(orderNumber),
      tableId: tableId == null && nullToAbsent
          ? const Value.absent()
          : Value(tableId),
      cashierId: Value(cashierId),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      status: Value(status),
      subtotal: Value(subtotal),
      discountAmount: Value(discountAmount),
      taxAmount: Value(taxAmount),
      total: Value(total),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      idempotencyKey: idempotencyKey == null && nullToAbsent
          ? const Value.absent()
          : Value(idempotencyKey),
      createdAt: Value(createdAt),
      paidAt:
          paidAt == null && nullToAbsent ? const Value.absent() : Value(paidAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory OrdersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      tableId: serializer.fromJson<String?>(json['tableId']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      shiftId: serializer.fromJson<String?>(json['shiftId']),
      status: serializer.fromJson<String>(json['status']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      total: serializer.fromJson<double>(json['total']),
      notes: serializer.fromJson<String?>(json['notes']),
      idempotencyKey: serializer.fromJson<String?>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'tableId': serializer.toJson<String?>(tableId),
      'cashierId': serializer.toJson<String>(cashierId),
      'shiftId': serializer.toJson<String?>(shiftId),
      'status': serializer.toJson<String>(status),
      'subtotal': serializer.toJson<double>(subtotal),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'total': serializer.toJson<double>(total),
      'notes': serializer.toJson<String?>(notes),
      'idempotencyKey': serializer.toJson<String?>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  OrdersTableData copyWith(
          {String? id,
          String? tenantId,
          String? orderNumber,
          Value<String?> tableId = const Value.absent(),
          String? cashierId,
          Value<String?> shiftId = const Value.absent(),
          String? status,
          double? subtotal,
          double? discountAmount,
          double? taxAmount,
          double? total,
          Value<String?> notes = const Value.absent(),
          Value<String?> idempotencyKey = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> paidAt = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      OrdersTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        orderNumber: orderNumber ?? this.orderNumber,
        tableId: tableId.present ? tableId.value : this.tableId,
        cashierId: cashierId ?? this.cashierId,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
        status: status ?? this.status,
        subtotal: subtotal ?? this.subtotal,
        discountAmount: discountAmount ?? this.discountAmount,
        taxAmount: taxAmount ?? this.taxAmount,
        total: total ?? this.total,
        notes: notes.present ? notes.value : this.notes,
        idempotencyKey:
            idempotencyKey.present ? idempotencyKey.value : this.idempotencyKey,
        createdAt: createdAt ?? this.createdAt,
        paidAt: paidAt.present ? paidAt.value : this.paidAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  OrdersTableData copyWithCompanion(OrdersTableCompanion data) {
    return OrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      orderNumber:
          data.orderNumber.present ? data.orderNumber.value : this.orderNumber,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      status: data.status.present ? data.status.value : this.status,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      total: data.total.present ? data.total.value : this.total,
      notes: data.notes.present ? data.notes.value : this.notes,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('tableId: $tableId, ')
          ..write('cashierId: $cashierId, ')
          ..write('shiftId: $shiftId, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('total: $total, ')
          ..write('notes: $notes, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      orderNumber,
      tableId,
      cashierId,
      shiftId,
      status,
      subtotal,
      discountAmount,
      taxAmount,
      total,
      notes,
      idempotencyKey,
      createdAt,
      paidAt,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.orderNumber == this.orderNumber &&
          other.tableId == this.tableId &&
          other.cashierId == this.cashierId &&
          other.shiftId == this.shiftId &&
          other.status == this.status &&
          other.subtotal == this.subtotal &&
          other.discountAmount == this.discountAmount &&
          other.taxAmount == this.taxAmount &&
          other.total == this.total &&
          other.notes == this.notes &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt &&
          other.paidAt == this.paidAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class OrdersTableCompanion extends UpdateCompanion<OrdersTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> orderNumber;
  final Value<String?> tableId;
  final Value<String> cashierId;
  final Value<String?> shiftId;
  final Value<String> status;
  final Value<double> subtotal;
  final Value<double> discountAmount;
  final Value<double> taxAmount;
  final Value<double> total;
  final Value<String?> notes;
  final Value<String?> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<DateTime?> paidAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.tableId = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.total = const Value.absent(),
    this.notes = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String orderNumber,
    this.tableId = const Value.absent(),
    required String cashierId,
    this.shiftId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.total = const Value.absent(),
    this.notes = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        orderNumber = Value(orderNumber),
        cashierId = Value(cashierId);
  static Insertable<OrdersTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? orderNumber,
    Expression<String>? tableId,
    Expression<String>? cashierId,
    Expression<String>? shiftId,
    Expression<String>? status,
    Expression<double>? subtotal,
    Expression<double>? discountAmount,
    Expression<double>? taxAmount,
    Expression<double>? total,
    Expression<String>? notes,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? paidAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (orderNumber != null) 'order_number': orderNumber,
      if (tableId != null) 'table_id': tableId,
      if (cashierId != null) 'cashier_id': cashierId,
      if (shiftId != null) 'shift_id': shiftId,
      if (status != null) 'status': status,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (total != null) 'total': total,
      if (notes != null) 'notes': notes,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (paidAt != null) 'paid_at': paidAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? orderNumber,
      Value<String?>? tableId,
      Value<String>? cashierId,
      Value<String?>? shiftId,
      Value<String>? status,
      Value<double>? subtotal,
      Value<double>? discountAmount,
      Value<double>? taxAmount,
      Value<double>? total,
      Value<String?>? notes,
      Value<String?>? idempotencyKey,
      Value<DateTime>? createdAt,
      Value<DateTime?>? paidAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      orderNumber: orderNumber ?? this.orderNumber,
      tableId: tableId ?? this.tableId,
      cashierId: cashierId ?? this.cashierId,
      shiftId: shiftId ?? this.shiftId,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<String>(tableId.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('tableId: $tableId, ')
          ..write('cashierId: $cashierId, ')
          ..write('shiftId: $shiftId, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('total: $total, ')
          ..write('notes: $notes, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTableTable extends OrderItemsTable
    with TableInfo<$OrderItemsTableTable, OrderItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
      'order_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _variantIdMeta =
      const VerificationMeta('variantId');
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
      'variant_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _modifiersMeta =
      const VerificationMeta('modifiers');
  @override
  late final GeneratedColumn<String> modifiers = GeneratedColumn<String>(
      'modifiers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kdsStatusMeta =
      const VerificationMeta('kdsStatus');
  @override
  late final GeneratedColumn<String> kdsStatus = GeneratedColumn<String>(
      'kds_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        tenantId,
        productId,
        variantId,
        productName,
        unitPrice,
        quantity,
        discount,
        lineTotal,
        modifiers,
        notes,
        kdsStatus,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<OrderItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta,
          variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('modifiers')) {
      context.handle(_modifiersMeta,
          modifiers.isAcceptableOrUnknown(data['modifiers']!, _modifiersMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('kds_status')) {
      context.handle(_kdsStatusMeta,
          kdsStatus.isAcceptableOrUnknown(data['kds_status']!, _kdsStatusMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      variantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variant_id']),
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      modifiers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modifiers']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      kdsStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kds_status'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $OrderItemsTableTable createAlias(String alias) {
    return $OrderItemsTableTable(attachedDatabase, alias);
  }
}

class OrderItemsTableData extends DataClass
    implements Insertable<OrderItemsTableData> {
  final String id;
  final String orderId;
  final String tenantId;
  final String productId;
  final String? variantId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double discount;
  final double lineTotal;
  final String? modifiers;
  final String? notes;
  final String kdsStatus;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const OrderItemsTableData(
      {required this.id,
      required this.orderId,
      required this.tenantId,
      required this.productId,
      this.variantId,
      required this.productName,
      required this.unitPrice,
      required this.quantity,
      required this.discount,
      required this.lineTotal,
      this.modifiers,
      this.notes,
      required this.kdsStatus,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['tenant_id'] = Variable<String>(tenantId);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    map['product_name'] = Variable<String>(productName);
    map['unit_price'] = Variable<double>(unitPrice);
    map['quantity'] = Variable<int>(quantity);
    map['discount'] = Variable<double>(discount);
    map['line_total'] = Variable<double>(lineTotal);
    if (!nullToAbsent || modifiers != null) {
      map['modifiers'] = Variable<String>(modifiers);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['kds_status'] = Variable<String>(kdsStatus);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  OrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsTableCompanion(
      id: Value(id),
      orderId: Value(orderId),
      tenantId: Value(tenantId),
      productId: Value(productId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      productName: Value(productName),
      unitPrice: Value(unitPrice),
      quantity: Value(quantity),
      discount: Value(discount),
      lineTotal: Value(lineTotal),
      modifiers: modifiers == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiers),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      kdsStatus: Value(kdsStatus),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory OrderItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      productId: serializer.fromJson<String>(json['productId']),
      variantId: serializer.fromJson<String?>(json['variantId']),
      productName: serializer.fromJson<String>(json['productName']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      discount: serializer.fromJson<double>(json['discount']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      modifiers: serializer.fromJson<String?>(json['modifiers']),
      notes: serializer.fromJson<String?>(json['notes']),
      kdsStatus: serializer.fromJson<String>(json['kdsStatus']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'tenantId': serializer.toJson<String>(tenantId),
      'productId': serializer.toJson<String>(productId),
      'variantId': serializer.toJson<String?>(variantId),
      'productName': serializer.toJson<String>(productName),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'quantity': serializer.toJson<int>(quantity),
      'discount': serializer.toJson<double>(discount),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'modifiers': serializer.toJson<String?>(modifiers),
      'notes': serializer.toJson<String?>(notes),
      'kdsStatus': serializer.toJson<String>(kdsStatus),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  OrderItemsTableData copyWith(
          {String? id,
          String? orderId,
          String? tenantId,
          String? productId,
          Value<String?> variantId = const Value.absent(),
          String? productName,
          double? unitPrice,
          int? quantity,
          double? discount,
          double? lineTotal,
          Value<String?> modifiers = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? kdsStatus,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      OrderItemsTableData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        tenantId: tenantId ?? this.tenantId,
        productId: productId ?? this.productId,
        variantId: variantId.present ? variantId.value : this.variantId,
        productName: productName ?? this.productName,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        discount: discount ?? this.discount,
        lineTotal: lineTotal ?? this.lineTotal,
        modifiers: modifiers.present ? modifiers.value : this.modifiers,
        notes: notes.present ? notes.value : this.notes,
        kdsStatus: kdsStatus ?? this.kdsStatus,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  OrderItemsTableData copyWithCompanion(OrderItemsTableCompanion data) {
    return OrderItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      productId: data.productId.present ? data.productId.value : this.productId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      discount: data.discount.present ? data.discount.value : this.discount,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      modifiers: data.modifiers.present ? data.modifiers.value : this.modifiers,
      notes: data.notes.present ? data.notes.value : this.notes,
      kdsStatus: data.kdsStatus.present ? data.kdsStatus.value : this.kdsStatus,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('tenantId: $tenantId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('discount: $discount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('modifiers: $modifiers, ')
          ..write('notes: $notes, ')
          ..write('kdsStatus: $kdsStatus, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderId,
      tenantId,
      productId,
      variantId,
      productName,
      unitPrice,
      quantity,
      discount,
      lineTotal,
      modifiers,
      notes,
      kdsStatus,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.tenantId == this.tenantId &&
          other.productId == this.productId &&
          other.variantId == this.variantId &&
          other.productName == this.productName &&
          other.unitPrice == this.unitPrice &&
          other.quantity == this.quantity &&
          other.discount == this.discount &&
          other.lineTotal == this.lineTotal &&
          other.modifiers == this.modifiers &&
          other.notes == this.notes &&
          other.kdsStatus == this.kdsStatus &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class OrderItemsTableCompanion extends UpdateCompanion<OrderItemsTableData> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> tenantId;
  final Value<String> productId;
  final Value<String?> variantId;
  final Value<String> productName;
  final Value<double> unitPrice;
  final Value<int> quantity;
  final Value<double> discount;
  final Value<double> lineTotal;
  final Value<String?> modifiers;
  final Value<String?> notes;
  final Value<String> kdsStatus;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const OrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.productId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.productName = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.discount = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.modifiers = const Value.absent(),
    this.notes = const Value.absent(),
    this.kdsStatus = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsTableCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String tenantId,
    required String productId,
    this.variantId = const Value.absent(),
    required String productName,
    required double unitPrice,
    required int quantity,
    this.discount = const Value.absent(),
    required double lineTotal,
    this.modifiers = const Value.absent(),
    this.notes = const Value.absent(),
    this.kdsStatus = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : orderId = Value(orderId),
        tenantId = Value(tenantId),
        productId = Value(productId),
        productName = Value(productName),
        unitPrice = Value(unitPrice),
        quantity = Value(quantity),
        lineTotal = Value(lineTotal);
  static Insertable<OrderItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? tenantId,
    Expression<String>? productId,
    Expression<String>? variantId,
    Expression<String>? productName,
    Expression<double>? unitPrice,
    Expression<int>? quantity,
    Expression<double>? discount,
    Expression<double>? lineTotal,
    Expression<String>? modifiers,
    Expression<String>? notes,
    Expression<String>? kdsStatus,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (productId != null) 'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      if (productName != null) 'product_name': productName,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (quantity != null) 'quantity': quantity,
      if (discount != null) 'discount': discount,
      if (lineTotal != null) 'line_total': lineTotal,
      if (modifiers != null) 'modifiers': modifiers,
      if (notes != null) 'notes': notes,
      if (kdsStatus != null) 'kds_status': kdsStatus,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? orderId,
      Value<String>? tenantId,
      Value<String>? productId,
      Value<String?>? variantId,
      Value<String>? productName,
      Value<double>? unitPrice,
      Value<int>? quantity,
      Value<double>? discount,
      Value<double>? lineTotal,
      Value<String?>? modifiers,
      Value<String?>? notes,
      Value<String>? kdsStatus,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return OrderItemsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      tenantId: tenantId ?? this.tenantId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      lineTotal: lineTotal ?? this.lineTotal,
      modifiers: modifiers ?? this.modifiers,
      notes: notes ?? this.notes,
      kdsStatus: kdsStatus ?? this.kdsStatus,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (modifiers.present) {
      map['modifiers'] = Variable<String>(modifiers.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (kdsStatus.present) {
      map['kds_status'] = Variable<String>(kdsStatus.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('tenantId: $tenantId, ')
          ..write('productId: $productId, ')
          ..write('variantId: $variantId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('discount: $discount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('modifiers: $modifiers, ')
          ..write('notes: $notes, ')
          ..write('kdsStatus: $kdsStatus, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTableTable extends PaymentsTable
    with TableInfo<$PaymentsTableTable, PaymentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
      'order_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountLakMeta =
      const VerificationMeta('amountLak');
  @override
  late final GeneratedColumn<double> amountLak = GeneratedColumn<double>(
      'amount_lak', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _changeAmountMeta =
      const VerificationMeta('changeAmount');
  @override
  late final GeneratedColumn<double> changeAmount = GeneratedColumn<double>(
      'change_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _confirmedByMeta =
      const VerificationMeta('confirmedBy');
  @override
  late final GeneratedColumn<String> confirmedBy = GeneratedColumn<String>(
      'confirmed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        tenantId,
        method,
        currency,
        amount,
        amountLak,
        exchangeRate,
        changeAmount,
        confirmedBy,
        createdAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('amount_lak')) {
      context.handle(_amountLakMeta,
          amountLak.isAcceptableOrUnknown(data['amount_lak']!, _amountLakMeta));
    } else if (isInserting) {
      context.missing(_amountLakMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    if (data.containsKey('change_amount')) {
      context.handle(
          _changeAmountMeta,
          changeAmount.isAcceptableOrUnknown(
              data['change_amount']!, _changeAmountMeta));
    }
    if (data.containsKey('confirmed_by')) {
      context.handle(
          _confirmedByMeta,
          confirmedBy.isAcceptableOrUnknown(
              data['confirmed_by']!, _confirmedByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      amountLak: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_lak'])!,
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate'])!,
      changeAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change_amount'])!,
      confirmedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}confirmed_by']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $PaymentsTableTable createAlias(String alias) {
    return $PaymentsTableTable(attachedDatabase, alias);
  }
}

class PaymentsTableData extends DataClass
    implements Insertable<PaymentsTableData> {
  final String id;
  final String orderId;
  final String tenantId;
  final String method;
  final String currency;
  final double amount;
  final double amountLak;
  final double exchangeRate;
  final double changeAmount;
  final String? confirmedBy;
  final DateTime createdAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const PaymentsTableData(
      {required this.id,
      required this.orderId,
      required this.tenantId,
      required this.method,
      required this.currency,
      required this.amount,
      required this.amountLak,
      required this.exchangeRate,
      required this.changeAmount,
      this.confirmedBy,
      required this.createdAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['tenant_id'] = Variable<String>(tenantId);
    map['method'] = Variable<String>(method);
    map['currency'] = Variable<String>(currency);
    map['amount'] = Variable<double>(amount);
    map['amount_lak'] = Variable<double>(amountLak);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    map['change_amount'] = Variable<double>(changeAmount);
    if (!nullToAbsent || confirmedBy != null) {
      map['confirmed_by'] = Variable<String>(confirmedBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  PaymentsTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentsTableCompanion(
      id: Value(id),
      orderId: Value(orderId),
      tenantId: Value(tenantId),
      method: Value(method),
      currency: Value(currency),
      amount: Value(amount),
      amountLak: Value(amountLak),
      exchangeRate: Value(exchangeRate),
      changeAmount: Value(changeAmount),
      confirmedBy: confirmedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedBy),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory PaymentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentsTableData(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      method: serializer.fromJson<String>(json['method']),
      currency: serializer.fromJson<String>(json['currency']),
      amount: serializer.fromJson<double>(json['amount']),
      amountLak: serializer.fromJson<double>(json['amountLak']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      changeAmount: serializer.fromJson<double>(json['changeAmount']),
      confirmedBy: serializer.fromJson<String?>(json['confirmedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'tenantId': serializer.toJson<String>(tenantId),
      'method': serializer.toJson<String>(method),
      'currency': serializer.toJson<String>(currency),
      'amount': serializer.toJson<double>(amount),
      'amountLak': serializer.toJson<double>(amountLak),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'changeAmount': serializer.toJson<double>(changeAmount),
      'confirmedBy': serializer.toJson<String?>(confirmedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  PaymentsTableData copyWith(
          {String? id,
          String? orderId,
          String? tenantId,
          String? method,
          String? currency,
          double? amount,
          double? amountLak,
          double? exchangeRate,
          double? changeAmount,
          Value<String?> confirmedBy = const Value.absent(),
          DateTime? createdAt,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      PaymentsTableData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        tenantId: tenantId ?? this.tenantId,
        method: method ?? this.method,
        currency: currency ?? this.currency,
        amount: amount ?? this.amount,
        amountLak: amountLak ?? this.amountLak,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        changeAmount: changeAmount ?? this.changeAmount,
        confirmedBy: confirmedBy.present ? confirmedBy.value : this.confirmedBy,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  PaymentsTableData copyWithCompanion(PaymentsTableCompanion data) {
    return PaymentsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      method: data.method.present ? data.method.value : this.method,
      currency: data.currency.present ? data.currency.value : this.currency,
      amount: data.amount.present ? data.amount.value : this.amount,
      amountLak: data.amountLak.present ? data.amountLak.value : this.amountLak,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      changeAmount: data.changeAmount.present
          ? data.changeAmount.value
          : this.changeAmount,
      confirmedBy:
          data.confirmedBy.present ? data.confirmedBy.value : this.confirmedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('tenantId: $tenantId, ')
          ..write('method: $method, ')
          ..write('currency: $currency, ')
          ..write('amount: $amount, ')
          ..write('amountLak: $amountLak, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderId,
      tenantId,
      method,
      currency,
      amount,
      amountLak,
      exchangeRate,
      changeAmount,
      confirmedBy,
      createdAt,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.tenantId == this.tenantId &&
          other.method == this.method &&
          other.currency == this.currency &&
          other.amount == this.amount &&
          other.amountLak == this.amountLak &&
          other.exchangeRate == this.exchangeRate &&
          other.changeAmount == this.changeAmount &&
          other.confirmedBy == this.confirmedBy &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class PaymentsTableCompanion extends UpdateCompanion<PaymentsTableData> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> tenantId;
  final Value<String> method;
  final Value<String> currency;
  final Value<double> amount;
  final Value<double> amountLak;
  final Value<double> exchangeRate;
  final Value<double> changeAmount;
  final Value<String?> confirmedBy;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const PaymentsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.method = const Value.absent(),
    this.currency = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountLak = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.confirmedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsTableCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String tenantId,
    required String method,
    required String currency,
    required double amount,
    required double amountLak,
    this.exchangeRate = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.confirmedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : orderId = Value(orderId),
        tenantId = Value(tenantId),
        method = Value(method),
        currency = Value(currency),
        amount = Value(amount),
        amountLak = Value(amountLak);
  static Insertable<PaymentsTableData> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? tenantId,
    Expression<String>? method,
    Expression<String>? currency,
    Expression<double>? amount,
    Expression<double>? amountLak,
    Expression<double>? exchangeRate,
    Expression<double>? changeAmount,
    Expression<String>? confirmedBy,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (method != null) 'method': method,
      if (currency != null) 'currency': currency,
      if (amount != null) 'amount': amount,
      if (amountLak != null) 'amount_lak': amountLak,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (changeAmount != null) 'change_amount': changeAmount,
      if (confirmedBy != null) 'confirmed_by': confirmedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? orderId,
      Value<String>? tenantId,
      Value<String>? method,
      Value<String>? currency,
      Value<double>? amount,
      Value<double>? amountLak,
      Value<double>? exchangeRate,
      Value<double>? changeAmount,
      Value<String?>? confirmedBy,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return PaymentsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      tenantId: tenantId ?? this.tenantId,
      method: method ?? this.method,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      amountLak: amountLak ?? this.amountLak,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      changeAmount: changeAmount ?? this.changeAmount,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (amountLak.present) {
      map['amount_lak'] = Variable<double>(amountLak.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (changeAmount.present) {
      map['change_amount'] = Variable<double>(changeAmount.value);
    }
    if (confirmedBy.present) {
      map['confirmed_by'] = Variable<String>(confirmedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('tenantId: $tenantId, ')
          ..write('method: $method, ')
          ..write('currency: $currency, ')
          ..write('amount: $amount, ')
          ..write('amountLak: $amountLak, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RestaurantTablesTableTable extends RestaurantTablesTable
    with TableInfo<$RestaurantTablesTableTable, RestaurantTablesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestaurantTablesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
      'zone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tableNumberMeta =
      const VerificationMeta('tableNumber');
  @override
  late final GeneratedColumn<String> tableNumber = GeneratedColumn<String>(
      'table_number', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('available'));
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        zone,
        tableNumber,
        capacity,
        status,
        openedAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restaurant_tables';
  @override
  VerificationContext validateIntegrity(
      Insertable<RestaurantTablesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('zone')) {
      context.handle(
          _zoneMeta, zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta));
    }
    if (data.containsKey('table_number')) {
      context.handle(
          _tableNumberMeta,
          tableNumber.isAcceptableOrUnknown(
              data['table_number']!, _tableNumberMeta));
    } else if (isInserting) {
      context.missing(_tableNumberMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantTablesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantTablesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      zone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone']),
      tableNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_number'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $RestaurantTablesTableTable createAlias(String alias) {
    return $RestaurantTablesTableTable(attachedDatabase, alias);
  }
}

class RestaurantTablesTableData extends DataClass
    implements Insertable<RestaurantTablesTableData> {
  final String id;
  final String tenantId;
  final String? zone;
  final String tableNumber;
  final int? capacity;
  final String status;
  final DateTime? openedAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const RestaurantTablesTableData(
      {required this.id,
      required this.tenantId,
      this.zone,
      required this.tableNumber,
      this.capacity,
      required this.status,
      this.openedAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    if (!nullToAbsent || zone != null) {
      map['zone'] = Variable<String>(zone);
    }
    map['table_number'] = Variable<String>(tableNumber);
    if (!nullToAbsent || capacity != null) {
      map['capacity'] = Variable<int>(capacity);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || openedAt != null) {
      map['opened_at'] = Variable<DateTime>(openedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  RestaurantTablesTableCompanion toCompanion(bool nullToAbsent) {
    return RestaurantTablesTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      zone: zone == null && nullToAbsent ? const Value.absent() : Value(zone),
      tableNumber: Value(tableNumber),
      capacity: capacity == null && nullToAbsent
          ? const Value.absent()
          : Value(capacity),
      status: Value(status),
      openedAt: openedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(openedAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory RestaurantTablesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantTablesTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      zone: serializer.fromJson<String?>(json['zone']),
      tableNumber: serializer.fromJson<String>(json['tableNumber']),
      capacity: serializer.fromJson<int?>(json['capacity']),
      status: serializer.fromJson<String>(json['status']),
      openedAt: serializer.fromJson<DateTime?>(json['openedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'zone': serializer.toJson<String?>(zone),
      'tableNumber': serializer.toJson<String>(tableNumber),
      'capacity': serializer.toJson<int?>(capacity),
      'status': serializer.toJson<String>(status),
      'openedAt': serializer.toJson<DateTime?>(openedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  RestaurantTablesTableData copyWith(
          {String? id,
          String? tenantId,
          Value<String?> zone = const Value.absent(),
          String? tableNumber,
          Value<int?> capacity = const Value.absent(),
          String? status,
          Value<DateTime?> openedAt = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      RestaurantTablesTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        zone: zone.present ? zone.value : this.zone,
        tableNumber: tableNumber ?? this.tableNumber,
        capacity: capacity.present ? capacity.value : this.capacity,
        status: status ?? this.status,
        openedAt: openedAt.present ? openedAt.value : this.openedAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  RestaurantTablesTableData copyWithCompanion(
      RestaurantTablesTableCompanion data) {
    return RestaurantTablesTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      zone: data.zone.present ? data.zone.value : this.zone,
      tableNumber:
          data.tableNumber.present ? data.tableNumber.value : this.tableNumber,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      status: data.status.present ? data.status.value : this.status,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTablesTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('zone: $zone, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, zone, tableNumber, capacity,
      status, openedAt, isSynced, localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantTablesTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.zone == this.zone &&
          other.tableNumber == this.tableNumber &&
          other.capacity == this.capacity &&
          other.status == this.status &&
          other.openedAt == this.openedAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class RestaurantTablesTableCompanion
    extends UpdateCompanion<RestaurantTablesTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String?> zone;
  final Value<String> tableNumber;
  final Value<int?> capacity;
  final Value<String> status;
  final Value<DateTime?> openedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const RestaurantTablesTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.zone = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestaurantTablesTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    this.zone = const Value.absent(),
    required String tableNumber,
    this.capacity = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        tableNumber = Value(tableNumber);
  static Insertable<RestaurantTablesTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? zone,
    Expression<String>? tableNumber,
    Expression<int>? capacity,
    Expression<String>? status,
    Expression<DateTime>? openedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (zone != null) 'zone': zone,
      if (tableNumber != null) 'table_number': tableNumber,
      if (capacity != null) 'capacity': capacity,
      if (status != null) 'status': status,
      if (openedAt != null) 'opened_at': openedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestaurantTablesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String?>? zone,
      Value<String>? tableNumber,
      Value<int?>? capacity,
      Value<String>? status,
      Value<DateTime?>? openedAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return RestaurantTablesTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      zone: zone ?? this.zone,
      tableNumber: tableNumber ?? this.tableNumber,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<String>(tableNumber.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTablesTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('zone: $zone, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('capacity: $capacity, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTableTable extends ShiftsTable
    with TableInfo<$ShiftsTableTable, ShiftsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cashierIdMeta =
      const VerificationMeta('cashierId');
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
      'cashier_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closingBalanceMeta =
      const VerificationMeta('closingBalance');
  @override
  late final GeneratedColumn<double> closingBalance = GeneratedColumn<double>(
      'closing_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        cashierId,
        deviceId,
        openingBalance,
        closingBalance,
        status,
        openedAt,
        closedAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(Insertable<ShiftsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('cashier_id')) {
      context.handle(_cashierIdMeta,
          cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta));
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    } else if (isInserting) {
      context.missing(_openingBalanceMeta);
    }
    if (data.containsKey('closing_balance')) {
      context.handle(
          _closingBalanceMeta,
          closingBalance.isAcceptableOrUnknown(
              data['closing_balance']!, _closingBalanceMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      cashierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cashier_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      closingBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}closing_balance']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $ShiftsTableTable createAlias(String alias) {
    return $ShiftsTableTable(attachedDatabase, alias);
  }
}

class ShiftsTableData extends DataClass implements Insertable<ShiftsTableData> {
  final String id;
  final String tenantId;
  final String cashierId;
  final String? deviceId;
  final double openingBalance;
  final double? closingBalance;
  final String status;
  final DateTime openedAt;
  final DateTime? closedAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const ShiftsTableData(
      {required this.id,
      required this.tenantId,
      required this.cashierId,
      this.deviceId,
      required this.openingBalance,
      this.closingBalance,
      required this.status,
      required this.openedAt,
      this.closedAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['cashier_id'] = Variable<String>(cashierId);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['opening_balance'] = Variable<double>(openingBalance);
    if (!nullToAbsent || closingBalance != null) {
      map['closing_balance'] = Variable<double>(closingBalance);
    }
    map['status'] = Variable<String>(status);
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  ShiftsTableCompanion toCompanion(bool nullToAbsent) {
    return ShiftsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      cashierId: Value(cashierId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      openingBalance: Value(openingBalance),
      closingBalance: closingBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(closingBalance),
      status: Value(status),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory ShiftsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftsTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      closingBalance: serializer.fromJson<double?>(json['closingBalance']),
      status: serializer.fromJson<String>(json['status']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'cashierId': serializer.toJson<String>(cashierId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'closingBalance': serializer.toJson<double?>(closingBalance),
      'status': serializer.toJson<String>(status),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  ShiftsTableData copyWith(
          {String? id,
          String? tenantId,
          String? cashierId,
          Value<String?> deviceId = const Value.absent(),
          double? openingBalance,
          Value<double?> closingBalance = const Value.absent(),
          String? status,
          DateTime? openedAt,
          Value<DateTime?> closedAt = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      ShiftsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        cashierId: cashierId ?? this.cashierId,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        openingBalance: openingBalance ?? this.openingBalance,
        closingBalance:
            closingBalance.present ? closingBalance.value : this.closingBalance,
        status: status ?? this.status,
        openedAt: openedAt ?? this.openedAt,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  ShiftsTableData copyWithCompanion(ShiftsTableCompanion data) {
    return ShiftsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      closingBalance: data.closingBalance.present
          ? data.closingBalance.value
          : this.closingBalance,
      status: data.status.present ? data.status.value : this.status,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('cashierId: $cashierId, ')
          ..write('deviceId: $deviceId, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      cashierId,
      deviceId,
      openingBalance,
      closingBalance,
      status,
      openedAt,
      closedAt,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.cashierId == this.cashierId &&
          other.deviceId == this.deviceId &&
          other.openingBalance == this.openingBalance &&
          other.closingBalance == this.closingBalance &&
          other.status == this.status &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class ShiftsTableCompanion extends UpdateCompanion<ShiftsTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> cashierId;
  final Value<String?> deviceId;
  final Value<double> openingBalance;
  final Value<double?> closingBalance;
  final Value<String> status;
  final Value<DateTime> openedAt;
  final Value<DateTime?> closedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const ShiftsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.closingBalance = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String cashierId,
    this.deviceId = const Value.absent(),
    required double openingBalance,
    this.closingBalance = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        cashierId = Value(cashierId),
        openingBalance = Value(openingBalance);
  static Insertable<ShiftsTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? cashierId,
    Expression<String>? deviceId,
    Expression<double>? openingBalance,
    Expression<double>? closingBalance,
    Expression<String>? status,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (cashierId != null) 'cashier_id': cashierId,
      if (deviceId != null) 'device_id': deviceId,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (closingBalance != null) 'closing_balance': closingBalance,
      if (status != null) 'status': status,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? cashierId,
      Value<String?>? deviceId,
      Value<double>? openingBalance,
      Value<double?>? closingBalance,
      Value<String>? status,
      Value<DateTime>? openedAt,
      Value<DateTime?>? closedAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return ShiftsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      cashierId: cashierId ?? this.cashierId,
      deviceId: deviceId ?? this.deviceId,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (closingBalance.present) {
      map['closing_balance'] = Variable<double>(closingBalance.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('cashierId: $cashierId, ')
          ..write('deviceId: $deviceId, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('closingBalance: $closingBalance, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        deviceId,
        entityType,
        entityId,
        operation,
        payload,
        idempotencyKey,
        status,
        createdAt,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends DataClass
    implements Insertable<SyncQueueTableData> {
  final String id;
  final String tenantId;
  final String? deviceId;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final String idempotencyKey;
  final String status;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const SyncQueueTableData(
      {required this.id,
      required this.tenantId,
      this.deviceId,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payload,
      required this.idempotencyKey,
      required this.status,
      required this.createdAt,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      idempotencyKey: Value(idempotencyKey),
      status: Value(status),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncQueueTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SyncQueueTableData copyWith(
          {String? id,
          String? tenantId,
          Value<String?> deviceId = const Value.absent(),
          String? entityType,
          String? entityId,
          String? operation,
          String? payload,
          String? idempotencyKey,
          String? status,
          DateTime? createdAt,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      SyncQueueTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('deviceId: $deviceId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, deviceId, entityType, entityId,
      operation, payload, idempotencyKey, status, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.deviceId == this.deviceId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.idempotencyKey == this.idempotencyKey &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String?> deviceId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String> idempotencyKey;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    this.deviceId = const Value.absent(),
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    required String idempotencyKey,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payload = Value(payload),
        idempotencyKey = Value(idempotencyKey);
  static Insertable<SyncQueueTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? deviceId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? idempotencyKey,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (deviceId != null) 'device_id': deviceId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String?>? deviceId,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? payload,
      Value<String>? idempotencyKey,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      deviceId: deviceId ?? this.deviceId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('deviceId: $deviceId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConflictLogsTableTable extends ConflictLogsTable
    with TableInfo<$ConflictLogsTableTable, ConflictLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConflictLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localValueMeta =
      const VerificationMeta('localValue');
  @override
  late final GeneratedColumn<String> localValue = GeneratedColumn<String>(
      'local_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serverValueMeta =
      const VerificationMeta('serverValue');
  @override
  late final GeneratedColumn<String> serverValue = GeneratedColumn<String>(
      'server_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resolvedByMeta =
      const VerificationMeta('resolvedBy');
  @override
  late final GeneratedColumn<String> resolvedBy = GeneratedColumn<String>(
      'resolved_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _resolvedAtMeta =
      const VerificationMeta('resolvedAt');
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
      'resolved_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        entityType,
        entityId,
        localValue,
        serverValue,
        resolution,
        resolvedBy,
        createdAt,
        resolvedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conflict_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConflictLogsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('local_value')) {
      context.handle(
          _localValueMeta,
          localValue.isAcceptableOrUnknown(
              data['local_value']!, _localValueMeta));
    }
    if (data.containsKey('server_value')) {
      context.handle(
          _serverValueMeta,
          serverValue.isAcceptableOrUnknown(
              data['server_value']!, _serverValueMeta));
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    }
    if (data.containsKey('resolved_by')) {
      context.handle(
          _resolvedByMeta,
          resolvedBy.isAcceptableOrUnknown(
              data['resolved_by']!, _resolvedByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
          _resolvedAtMeta,
          resolvedAt.isAcceptableOrUnknown(
              data['resolved_at']!, _resolvedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConflictLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConflictLogsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      localValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_value']),
      serverValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_value']),
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution']),
      resolvedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolved_by']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      resolvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}resolved_at']),
    );
  }

  @override
  $ConflictLogsTableTable createAlias(String alias) {
    return $ConflictLogsTableTable(attachedDatabase, alias);
  }
}

class ConflictLogsTableData extends DataClass
    implements Insertable<ConflictLogsTableData> {
  final String id;
  final String tenantId;
  final String entityType;
  final String entityId;
  final String? localValue;
  final String? serverValue;
  final String? resolution;
  final String? resolvedBy;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  const ConflictLogsTableData(
      {required this.id,
      required this.tenantId,
      required this.entityType,
      required this.entityId,
      this.localValue,
      this.serverValue,
      this.resolution,
      this.resolvedBy,
      required this.createdAt,
      this.resolvedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || localValue != null) {
      map['local_value'] = Variable<String>(localValue);
    }
    if (!nullToAbsent || serverValue != null) {
      map['server_value'] = Variable<String>(serverValue);
    }
    if (!nullToAbsent || resolution != null) {
      map['resolution'] = Variable<String>(resolution);
    }
    if (!nullToAbsent || resolvedBy != null) {
      map['resolved_by'] = Variable<String>(resolvedBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  ConflictLogsTableCompanion toCompanion(bool nullToAbsent) {
    return ConflictLogsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      localValue: localValue == null && nullToAbsent
          ? const Value.absent()
          : Value(localValue),
      serverValue: serverValue == null && nullToAbsent
          ? const Value.absent()
          : Value(serverValue),
      resolution: resolution == null && nullToAbsent
          ? const Value.absent()
          : Value(resolution),
      resolvedBy: resolvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedBy),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory ConflictLogsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConflictLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      localValue: serializer.fromJson<String?>(json['localValue']),
      serverValue: serializer.fromJson<String?>(json['serverValue']),
      resolution: serializer.fromJson<String?>(json['resolution']),
      resolvedBy: serializer.fromJson<String?>(json['resolvedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'localValue': serializer.toJson<String?>(localValue),
      'serverValue': serializer.toJson<String?>(serverValue),
      'resolution': serializer.toJson<String?>(resolution),
      'resolvedBy': serializer.toJson<String?>(resolvedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  ConflictLogsTableData copyWith(
          {String? id,
          String? tenantId,
          String? entityType,
          String? entityId,
          Value<String?> localValue = const Value.absent(),
          Value<String?> serverValue = const Value.absent(),
          Value<String?> resolution = const Value.absent(),
          Value<String?> resolvedBy = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> resolvedAt = const Value.absent()}) =>
      ConflictLogsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        localValue: localValue.present ? localValue.value : this.localValue,
        serverValue: serverValue.present ? serverValue.value : this.serverValue,
        resolution: resolution.present ? resolution.value : this.resolution,
        resolvedBy: resolvedBy.present ? resolvedBy.value : this.resolvedBy,
        createdAt: createdAt ?? this.createdAt,
        resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
      );
  ConflictLogsTableData copyWithCompanion(ConflictLogsTableCompanion data) {
    return ConflictLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      localValue:
          data.localValue.present ? data.localValue.value : this.localValue,
      serverValue:
          data.serverValue.present ? data.serverValue.value : this.serverValue,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
      resolvedBy:
          data.resolvedBy.present ? data.resolvedBy.value : this.resolvedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt:
          data.resolvedAt.present ? data.resolvedAt.value : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConflictLogsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('localValue: $localValue, ')
          ..write('serverValue: $serverValue, ')
          ..write('resolution: $resolution, ')
          ..write('resolvedBy: $resolvedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, entityType, entityId,
      localValue, serverValue, resolution, resolvedBy, createdAt, resolvedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConflictLogsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.localValue == this.localValue &&
          other.serverValue == this.serverValue &&
          other.resolution == this.resolution &&
          other.resolvedBy == this.resolvedBy &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class ConflictLogsTableCompanion
    extends UpdateCompanion<ConflictLogsTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String?> localValue;
  final Value<String?> serverValue;
  final Value<String?> resolution;
  final Value<String?> resolvedBy;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  final Value<int> rowid;
  const ConflictLogsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.localValue = const Value.absent(),
    this.serverValue = const Value.absent(),
    this.resolution = const Value.absent(),
    this.resolvedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConflictLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String entityType,
    required String entityId,
    this.localValue = const Value.absent(),
    this.serverValue = const Value.absent(),
    this.resolution = const Value.absent(),
    this.resolvedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        entityType = Value(entityType),
        entityId = Value(entityId);
  static Insertable<ConflictLogsTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? localValue,
    Expression<String>? serverValue,
    Expression<String>? resolution,
    Expression<String>? resolvedBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (localValue != null) 'local_value': localValue,
      if (serverValue != null) 'server_value': serverValue,
      if (resolution != null) 'resolution': resolution,
      if (resolvedBy != null) 'resolved_by': resolvedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConflictLogsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String?>? localValue,
      Value<String?>? serverValue,
      Value<String?>? resolution,
      Value<String?>? resolvedBy,
      Value<DateTime>? createdAt,
      Value<DateTime?>? resolvedAt,
      Value<int>? rowid}) {
    return ConflictLogsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      localValue: localValue ?? this.localValue,
      serverValue: serverValue ?? this.serverValue,
      resolution: resolution ?? this.resolution,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (localValue.present) {
      map['local_value'] = Variable<String>(localValue.value);
    }
    if (serverValue.present) {
      map['server_value'] = Variable<String>(serverValue.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (resolvedBy.present) {
      map['resolved_by'] = Variable<String>(resolvedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConflictLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('localValue: $localValue, ')
          ..write('serverValue: $serverValue, ')
          ..write('resolution: $resolution, ')
          ..write('resolvedBy: $resolvedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTableTable extends ExchangeRatesTable
    with TableInfo<$ExchangeRatesTableTable, ExchangeRatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _setByMeta = const VerificationMeta('setBy');
  @override
  late final GeneratedColumn<String> setBy = GeneratedColumn<String>(
      'set_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _effectiveAtMeta =
      const VerificationMeta('effectiveAt');
  @override
  late final GeneratedColumn<DateTime> effectiveAt = GeneratedColumn<DateTime>(
      'effective_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        currency,
        rate,
        setBy,
        effectiveAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExchangeRatesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('set_by')) {
      context.handle(
          _setByMeta, setBy.isAcceptableOrUnknown(data['set_by']!, _setByMeta));
    }
    if (data.containsKey('effective_at')) {
      context.handle(
          _effectiveAtMeta,
          effectiveAt.isAcceptableOrUnknown(
              data['effective_at']!, _effectiveAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRatesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRatesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
      setBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_by']),
      effectiveAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}effective_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $ExchangeRatesTableTable createAlias(String alias) {
    return $ExchangeRatesTableTable(attachedDatabase, alias);
  }
}

class ExchangeRatesTableData extends DataClass
    implements Insertable<ExchangeRatesTableData> {
  final String id;
  final String tenantId;
  final String currency;
  final double rate;
  final String? setBy;
  final DateTime effectiveAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const ExchangeRatesTableData(
      {required this.id,
      required this.tenantId,
      required this.currency,
      required this.rate,
      this.setBy,
      required this.effectiveAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['currency'] = Variable<String>(currency);
    map['rate'] = Variable<double>(rate);
    if (!nullToAbsent || setBy != null) {
      map['set_by'] = Variable<String>(setBy);
    }
    map['effective_at'] = Variable<DateTime>(effectiveAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  ExchangeRatesTableCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      currency: Value(currency),
      rate: Value(rate),
      setBy:
          setBy == null && nullToAbsent ? const Value.absent() : Value(setBy),
      effectiveAt: Value(effectiveAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory ExchangeRatesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRatesTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      currency: serializer.fromJson<String>(json['currency']),
      rate: serializer.fromJson<double>(json['rate']),
      setBy: serializer.fromJson<String?>(json['setBy']),
      effectiveAt: serializer.fromJson<DateTime>(json['effectiveAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'currency': serializer.toJson<String>(currency),
      'rate': serializer.toJson<double>(rate),
      'setBy': serializer.toJson<String?>(setBy),
      'effectiveAt': serializer.toJson<DateTime>(effectiveAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  ExchangeRatesTableData copyWith(
          {String? id,
          String? tenantId,
          String? currency,
          double? rate,
          Value<String?> setBy = const Value.absent(),
          DateTime? effectiveAt,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      ExchangeRatesTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        currency: currency ?? this.currency,
        rate: rate ?? this.rate,
        setBy: setBy.present ? setBy.value : this.setBy,
        effectiveAt: effectiveAt ?? this.effectiveAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  ExchangeRatesTableData copyWithCompanion(ExchangeRatesTableCompanion data) {
    return ExchangeRatesTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      currency: data.currency.present ? data.currency.value : this.currency,
      rate: data.rate.present ? data.rate.value : this.rate,
      setBy: data.setBy.present ? data.setBy.value : this.setBy,
      effectiveAt:
          data.effectiveAt.present ? data.effectiveAt.value : this.effectiveAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('currency: $currency, ')
          ..write('rate: $rate, ')
          ..write('setBy: $setBy, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, currency, rate, setBy,
      effectiveAt, isSynced, localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRatesTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.currency == this.currency &&
          other.rate == this.rate &&
          other.setBy == this.setBy &&
          other.effectiveAt == this.effectiveAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class ExchangeRatesTableCompanion
    extends UpdateCompanion<ExchangeRatesTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> currency;
  final Value<double> rate;
  final Value<String?> setBy;
  final Value<DateTime> effectiveAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const ExchangeRatesTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.currency = const Value.absent(),
    this.rate = const Value.absent(),
    this.setBy = const Value.absent(),
    this.effectiveAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String currency,
    required double rate,
    this.setBy = const Value.absent(),
    this.effectiveAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        currency = Value(currency),
        rate = Value(rate);
  static Insertable<ExchangeRatesTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? currency,
    Expression<double>? rate,
    Expression<String>? setBy,
    Expression<DateTime>? effectiveAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (currency != null) 'currency': currency,
      if (rate != null) 'rate': rate,
      if (setBy != null) 'set_by': setBy,
      if (effectiveAt != null) 'effective_at': effectiveAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? currency,
      Value<double>? rate,
      Value<String?>? setBy,
      Value<DateTime>? effectiveAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return ExchangeRatesTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      currency: currency ?? this.currency,
      rate: rate ?? this.rate,
      setBy: setBy ?? this.setBy,
      effectiveAt: effectiveAt ?? this.effectiveAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (setBy.present) {
      map['set_by'] = Variable<String>(setBy.value);
    }
    if (effectiveAt.present) {
      map['effective_at'] = Variable<DateTime>(effectiveAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('currency: $currency, ')
          ..write('rate: $rate, ')
          ..write('setBy: $setBy, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiscountsTableTable extends DiscountsTable
    with TableInfo<$DiscountsTableTable, DiscountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
      'scope', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startsAtMeta =
      const VerificationMeta('startsAt');
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
      'starts_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
      'ends_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _requiresApprovalMeta =
      const VerificationMeta('requiresApproval');
  @override
  late final GeneratedColumn<bool> requiresApproval = GeneratedColumn<bool>(
      'requires_approval', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_approval" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        name,
        type,
        value,
        scope,
        productId,
        startsAt,
        endsAt,
        isActive,
        requiresApproval,
        createdBy,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discounts';
  @override
  VerificationContext validateIntegrity(Insertable<DiscountsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
          _scopeMeta, scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta));
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('starts_at')) {
      context.handle(_startsAtMeta,
          startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta));
    }
    if (data.containsKey('ends_at')) {
      context.handle(_endsAtMeta,
          endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('requires_approval')) {
      context.handle(
          _requiresApprovalMeta,
          requiresApproval.isAcceptableOrUnknown(
              data['requires_approval']!, _requiresApprovalMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscountsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      scope: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      startsAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}starts_at']),
      endsAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ends_at']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      requiresApproval: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}requires_approval'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $DiscountsTableTable createAlias(String alias) {
    return $DiscountsTableTable(attachedDatabase, alias);
  }
}

class DiscountsTableData extends DataClass
    implements Insertable<DiscountsTableData> {
  final String id;
  final String tenantId;
  final String name;
  final String type;
  final double value;
  final String scope;
  final String? productId;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isActive;
  final bool requiresApproval;
  final String? createdBy;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const DiscountsTableData(
      {required this.id,
      required this.tenantId,
      required this.name,
      required this.type,
      required this.value,
      required this.scope,
      this.productId,
      this.startsAt,
      this.endsAt,
      required this.isActive,
      required this.requiresApproval,
      this.createdBy,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<double>(value);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || startsAt != null) {
      map['starts_at'] = Variable<DateTime>(startsAt);
    }
    if (!nullToAbsent || endsAt != null) {
      map['ends_at'] = Variable<DateTime>(endsAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['requires_approval'] = Variable<bool>(requiresApproval);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  DiscountsTableCompanion toCompanion(bool nullToAbsent) {
    return DiscountsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      name: Value(name),
      type: Value(type),
      value: Value(value),
      scope: Value(scope),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      startsAt: startsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startsAt),
      endsAt:
          endsAt == null && nullToAbsent ? const Value.absent() : Value(endsAt),
      isActive: Value(isActive),
      requiresApproval: Value(requiresApproval),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory DiscountsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscountsTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<double>(json['value']),
      scope: serializer.fromJson<String>(json['scope']),
      productId: serializer.fromJson<String?>(json['productId']),
      startsAt: serializer.fromJson<DateTime?>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime?>(json['endsAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      requiresApproval: serializer.fromJson<bool>(json['requiresApproval']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<double>(value),
      'scope': serializer.toJson<String>(scope),
      'productId': serializer.toJson<String?>(productId),
      'startsAt': serializer.toJson<DateTime?>(startsAt),
      'endsAt': serializer.toJson<DateTime?>(endsAt),
      'isActive': serializer.toJson<bool>(isActive),
      'requiresApproval': serializer.toJson<bool>(requiresApproval),
      'createdBy': serializer.toJson<String?>(createdBy),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  DiscountsTableData copyWith(
          {String? id,
          String? tenantId,
          String? name,
          String? type,
          double? value,
          String? scope,
          Value<String?> productId = const Value.absent(),
          Value<DateTime?> startsAt = const Value.absent(),
          Value<DateTime?> endsAt = const Value.absent(),
          bool? isActive,
          bool? requiresApproval,
          Value<String?> createdBy = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      DiscountsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        name: name ?? this.name,
        type: type ?? this.type,
        value: value ?? this.value,
        scope: scope ?? this.scope,
        productId: productId.present ? productId.value : this.productId,
        startsAt: startsAt.present ? startsAt.value : this.startsAt,
        endsAt: endsAt.present ? endsAt.value : this.endsAt,
        isActive: isActive ?? this.isActive,
        requiresApproval: requiresApproval ?? this.requiresApproval,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  DiscountsTableData copyWithCompanion(DiscountsTableCompanion data) {
    return DiscountsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      scope: data.scope.present ? data.scope.value : this.scope,
      productId: data.productId.present ? data.productId.value : this.productId,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      requiresApproval: data.requiresApproval.present
          ? data.requiresApproval.value
          : this.requiresApproval,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscountsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('scope: $scope, ')
          ..write('productId: $productId, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('isActive: $isActive, ')
          ..write('requiresApproval: $requiresApproval, ')
          ..write('createdBy: $createdBy, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      name,
      type,
      value,
      scope,
      productId,
      startsAt,
      endsAt,
      isActive,
      requiresApproval,
      createdBy,
      isSynced,
      localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscountsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.type == this.type &&
          other.value == this.value &&
          other.scope == this.scope &&
          other.productId == this.productId &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.isActive == this.isActive &&
          other.requiresApproval == this.requiresApproval &&
          other.createdBy == this.createdBy &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class DiscountsTableCompanion extends UpdateCompanion<DiscountsTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> name;
  final Value<String> type;
  final Value<double> value;
  final Value<String> scope;
  final Value<String?> productId;
  final Value<DateTime?> startsAt;
  final Value<DateTime?> endsAt;
  final Value<bool> isActive;
  final Value<bool> requiresApproval;
  final Value<String?> createdBy;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const DiscountsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.scope = const Value.absent(),
    this.productId = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.requiresApproval = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscountsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String name,
    required String type,
    required double value,
    required String scope,
    this.productId = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.requiresApproval = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        name = Value(name),
        type = Value(type),
        value = Value(value),
        scope = Value(scope);
  static Insertable<DiscountsTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? value,
    Expression<String>? scope,
    Expression<String>? productId,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<bool>? isActive,
    Expression<bool>? requiresApproval,
    Expression<String>? createdBy,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (scope != null) 'scope': scope,
      if (productId != null) 'product_id': productId,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (isActive != null) 'is_active': isActive,
      if (requiresApproval != null) 'requires_approval': requiresApproval,
      if (createdBy != null) 'created_by': createdBy,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscountsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? name,
      Value<String>? type,
      Value<double>? value,
      Value<String>? scope,
      Value<String?>? productId,
      Value<DateTime?>? startsAt,
      Value<DateTime?>? endsAt,
      Value<bool>? isActive,
      Value<bool>? requiresApproval,
      Value<String?>? createdBy,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return DiscountsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      scope: scope ?? this.scope,
      productId: productId ?? this.productId,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      isActive: isActive ?? this.isActive,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      createdBy: createdBy ?? this.createdBy,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (requiresApproval.present) {
      map['requires_approval'] = Variable<bool>(requiresApproval.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscountsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('scope: $scope, ')
          ..write('productId: $productId, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('isActive: $isActive, ')
          ..write('requiresApproval: $requiresApproval, ')
          ..write('createdBy: $createdBy, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RefundsTableTable extends RefundsTable
    with TableInfo<$RefundsTableTable, RefundsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefundsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalOrderIdMeta =
      const VerificationMeta('originalOrderId');
  @override
  late final GeneratedColumn<String> originalOrderId = GeneratedColumn<String>(
      'original_order_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _approvedByMeta =
      const VerificationMeta('approvedBy');
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
      'approved_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalRefundMeta =
      const VerificationMeta('totalRefund');
  @override
  late final GeneratedColumn<double> totalRefund = GeneratedColumn<double>(
      'total_refund', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        originalOrderId,
        reason,
        approvedBy,
        totalRefund,
        currency,
        createdAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refunds';
  @override
  VerificationContext validateIntegrity(Insertable<RefundsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('original_order_id')) {
      context.handle(
          _originalOrderIdMeta,
          originalOrderId.isAcceptableOrUnknown(
              data['original_order_id']!, _originalOrderIdMeta));
    } else if (isInserting) {
      context.missing(_originalOrderIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('approved_by')) {
      context.handle(
          _approvedByMeta,
          approvedBy.isAcceptableOrUnknown(
              data['approved_by']!, _approvedByMeta));
    } else if (isInserting) {
      context.missing(_approvedByMeta);
    }
    if (data.containsKey('total_refund')) {
      context.handle(
          _totalRefundMeta,
          totalRefund.isAcceptableOrUnknown(
              data['total_refund']!, _totalRefundMeta));
    } else if (isInserting) {
      context.missing(_totalRefundMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefundsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefundsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      originalOrderId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}original_order_id'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      approvedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approved_by'])!,
      totalRefund: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_refund'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $RefundsTableTable createAlias(String alias) {
    return $RefundsTableTable(attachedDatabase, alias);
  }
}

class RefundsTableData extends DataClass
    implements Insertable<RefundsTableData> {
  final String id;
  final String tenantId;
  final String originalOrderId;
  final String reason;
  final String approvedBy;
  final double totalRefund;
  final String currency;
  final DateTime createdAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const RefundsTableData(
      {required this.id,
      required this.tenantId,
      required this.originalOrderId,
      required this.reason,
      required this.approvedBy,
      required this.totalRefund,
      required this.currency,
      required this.createdAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['original_order_id'] = Variable<String>(originalOrderId);
    map['reason'] = Variable<String>(reason);
    map['approved_by'] = Variable<String>(approvedBy);
    map['total_refund'] = Variable<double>(totalRefund);
    map['currency'] = Variable<String>(currency);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  RefundsTableCompanion toCompanion(bool nullToAbsent) {
    return RefundsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      originalOrderId: Value(originalOrderId),
      reason: Value(reason),
      approvedBy: Value(approvedBy),
      totalRefund: Value(totalRefund),
      currency: Value(currency),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory RefundsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefundsTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      originalOrderId: serializer.fromJson<String>(json['originalOrderId']),
      reason: serializer.fromJson<String>(json['reason']),
      approvedBy: serializer.fromJson<String>(json['approvedBy']),
      totalRefund: serializer.fromJson<double>(json['totalRefund']),
      currency: serializer.fromJson<String>(json['currency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'originalOrderId': serializer.toJson<String>(originalOrderId),
      'reason': serializer.toJson<String>(reason),
      'approvedBy': serializer.toJson<String>(approvedBy),
      'totalRefund': serializer.toJson<double>(totalRefund),
      'currency': serializer.toJson<String>(currency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  RefundsTableData copyWith(
          {String? id,
          String? tenantId,
          String? originalOrderId,
          String? reason,
          String? approvedBy,
          double? totalRefund,
          String? currency,
          DateTime? createdAt,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      RefundsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        originalOrderId: originalOrderId ?? this.originalOrderId,
        reason: reason ?? this.reason,
        approvedBy: approvedBy ?? this.approvedBy,
        totalRefund: totalRefund ?? this.totalRefund,
        currency: currency ?? this.currency,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  RefundsTableData copyWithCompanion(RefundsTableCompanion data) {
    return RefundsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      originalOrderId: data.originalOrderId.present
          ? data.originalOrderId.value
          : this.originalOrderId,
      reason: data.reason.present ? data.reason.value : this.reason,
      approvedBy:
          data.approvedBy.present ? data.approvedBy.value : this.approvedBy,
      totalRefund:
          data.totalRefund.present ? data.totalRefund.value : this.totalRefund,
      currency: data.currency.present ? data.currency.value : this.currency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefundsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('originalOrderId: $originalOrderId, ')
          ..write('reason: $reason, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('totalRefund: $totalRefund, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, originalOrderId, reason,
      approvedBy, totalRefund, currency, createdAt, isSynced, localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefundsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.originalOrderId == this.originalOrderId &&
          other.reason == this.reason &&
          other.approvedBy == this.approvedBy &&
          other.totalRefund == this.totalRefund &&
          other.currency == this.currency &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class RefundsTableCompanion extends UpdateCompanion<RefundsTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> originalOrderId;
  final Value<String> reason;
  final Value<String> approvedBy;
  final Value<double> totalRefund;
  final Value<String> currency;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const RefundsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.originalOrderId = const Value.absent(),
    this.reason = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.totalRefund = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RefundsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String originalOrderId,
    required String reason,
    required String approvedBy,
    required double totalRefund,
    required String currency,
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        originalOrderId = Value(originalOrderId),
        reason = Value(reason),
        approvedBy = Value(approvedBy),
        totalRefund = Value(totalRefund),
        currency = Value(currency);
  static Insertable<RefundsTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? originalOrderId,
    Expression<String>? reason,
    Expression<String>? approvedBy,
    Expression<double>? totalRefund,
    Expression<String>? currency,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (originalOrderId != null) 'original_order_id': originalOrderId,
      if (reason != null) 'reason': reason,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (totalRefund != null) 'total_refund': totalRefund,
      if (currency != null) 'currency': currency,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RefundsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? originalOrderId,
      Value<String>? reason,
      Value<String>? approvedBy,
      Value<double>? totalRefund,
      Value<String>? currency,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return RefundsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      originalOrderId: originalOrderId ?? this.originalOrderId,
      reason: reason ?? this.reason,
      approvedBy: approvedBy ?? this.approvedBy,
      totalRefund: totalRefund ?? this.totalRefund,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (originalOrderId.present) {
      map['original_order_id'] = Variable<String>(originalOrderId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (totalRefund.present) {
      map['total_refund'] = Variable<double>(totalRefund.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefundsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('originalOrderId: $originalOrderId, ')
          ..write('reason: $reason, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('totalRefund: $totalRefund, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VoidLogsTableTable extends VoidLogsTable
    with TableInfo<$VoidLogsTableTable, VoidLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoidLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid());
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
      'order_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voidedByMeta =
      const VerificationMeta('voidedBy');
  @override
  late final GeneratedColumn<String> voidedBy = GeneratedColumn<String>(
      'voided_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        orderId,
        reason,
        voidedBy,
        shiftId,
        createdAt,
        isSynced,
        localUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'void_logs';
  @override
  VerificationContext validateIntegrity(Insertable<VoidLogsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('voided_by')) {
      context.handle(_voidedByMeta,
          voidedBy.isAcceptableOrUnknown(data['voided_by']!, _voidedByMeta));
    } else if (isInserting) {
      context.missing(_voidedByMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoidLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoidLogsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_id'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      voidedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voided_by'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shift_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at']),
    );
  }

  @override
  $VoidLogsTableTable createAlias(String alias) {
    return $VoidLogsTableTable(attachedDatabase, alias);
  }
}

class VoidLogsTableData extends DataClass
    implements Insertable<VoidLogsTableData> {
  final String id;
  final String tenantId;
  final String orderId;
  final String reason;
  final String voidedBy;
  final String? shiftId;
  final DateTime createdAt;
  final bool isSynced;
  final DateTime? localUpdatedAt;
  const VoidLogsTableData(
      {required this.id,
      required this.tenantId,
      required this.orderId,
      required this.reason,
      required this.voidedBy,
      this.shiftId,
      required this.createdAt,
      required this.isSynced,
      this.localUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['order_id'] = Variable<String>(orderId);
    map['reason'] = Variable<String>(reason);
    map['voided_by'] = Variable<String>(voidedBy);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<String>(shiftId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    return map;
  }

  VoidLogsTableCompanion toCompanion(bool nullToAbsent) {
    return VoidLogsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      orderId: Value(orderId),
      reason: Value(reason),
      voidedBy: Value(voidedBy),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
    );
  }

  factory VoidLogsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoidLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      orderId: serializer.fromJson<String>(json['orderId']),
      reason: serializer.fromJson<String>(json['reason']),
      voidedBy: serializer.fromJson<String>(json['voidedBy']),
      shiftId: serializer.fromJson<String?>(json['shiftId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'orderId': serializer.toJson<String>(orderId),
      'reason': serializer.toJson<String>(reason),
      'voidedBy': serializer.toJson<String>(voidedBy),
      'shiftId': serializer.toJson<String?>(shiftId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
    };
  }

  VoidLogsTableData copyWith(
          {String? id,
          String? tenantId,
          String? orderId,
          String? reason,
          String? voidedBy,
          Value<String?> shiftId = const Value.absent(),
          DateTime? createdAt,
          bool? isSynced,
          Value<DateTime?> localUpdatedAt = const Value.absent()}) =>
      VoidLogsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        orderId: orderId ?? this.orderId,
        reason: reason ?? this.reason,
        voidedBy: voidedBy ?? this.voidedBy,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
        localUpdatedAt:
            localUpdatedAt.present ? localUpdatedAt.value : this.localUpdatedAt,
      );
  VoidLogsTableData copyWithCompanion(VoidLogsTableCompanion data) {
    return VoidLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      reason: data.reason.present ? data.reason.value : this.reason,
      voidedBy: data.voidedBy.present ? data.voidedBy.value : this.voidedBy,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoidLogsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('orderId: $orderId, ')
          ..write('reason: $reason, ')
          ..write('voidedBy: $voidedBy, ')
          ..write('shiftId: $shiftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, orderId, reason, voidedBy,
      shiftId, createdAt, isSynced, localUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoidLogsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.orderId == this.orderId &&
          other.reason == this.reason &&
          other.voidedBy == this.voidedBy &&
          other.shiftId == this.shiftId &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.localUpdatedAt == this.localUpdatedAt);
}

class VoidLogsTableCompanion extends UpdateCompanion<VoidLogsTableData> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> orderId;
  final Value<String> reason;
  final Value<String> voidedBy;
  final Value<String?> shiftId;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<DateTime?> localUpdatedAt;
  final Value<int> rowid;
  const VoidLogsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.reason = const Value.absent(),
    this.voidedBy = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoidLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String orderId,
    required String reason,
    required String voidedBy,
    this.shiftId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        orderId = Value(orderId),
        reason = Value(reason),
        voidedBy = Value(voidedBy);
  static Insertable<VoidLogsTableData> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? orderId,
    Expression<String>? reason,
    Expression<String>? voidedBy,
    Expression<String>? shiftId,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (orderId != null) 'order_id': orderId,
      if (reason != null) 'reason': reason,
      if (voidedBy != null) 'voided_by': voidedBy,
      if (shiftId != null) 'shift_id': shiftId,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoidLogsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? orderId,
      Value<String>? reason,
      Value<String>? voidedBy,
      Value<String?>? shiftId,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<DateTime?>? localUpdatedAt,
      Value<int>? rowid}) {
    return VoidLogsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      orderId: orderId ?? this.orderId,
      reason: reason ?? this.reason,
      voidedBy: voidedBy ?? this.voidedBy,
      shiftId: shiftId ?? this.shiftId,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (voidedBy.present) {
      map['voided_by'] = Variable<String>(voidedBy.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoidLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('orderId: $orderId, ')
          ..write('reason: $reason, ')
          ..write('voidedBy: $voidedBy, ')
          ..write('shiftId: $shiftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubscriptionPlansTableTable subscriptionPlansTable =
      $SubscriptionPlansTableTable(this);
  late final $TenantsTableTable tenantsTable = $TenantsTableTable(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $ProductVariantsTableTable productVariantsTable =
      $ProductVariantsTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $OrderItemsTableTable orderItemsTable =
      $OrderItemsTableTable(this);
  late final $PaymentsTableTable paymentsTable = $PaymentsTableTable(this);
  late final $RestaurantTablesTableTable restaurantTablesTable =
      $RestaurantTablesTableTable(this);
  late final $ShiftsTableTable shiftsTable = $ShiftsTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $ConflictLogsTableTable conflictLogsTable =
      $ConflictLogsTableTable(this);
  late final $ExchangeRatesTableTable exchangeRatesTable =
      $ExchangeRatesTableTable(this);
  late final $DiscountsTableTable discountsTable = $DiscountsTableTable(this);
  late final $RefundsTableTable refundsTable = $RefundsTableTable(this);
  late final $VoidLogsTableTable voidLogsTable = $VoidLogsTableTable(this);
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final OrdersDao ordersDao = OrdersDao(this as AppDatabase);
  late final SyncDao syncDao = SyncDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        subscriptionPlansTable,
        tenantsTable,
        usersTable,
        categoriesTable,
        productsTable,
        productVariantsTable,
        ordersTable,
        orderItemsTable,
        paymentsTable,
        restaurantTablesTable,
        shiftsTable,
        syncQueueTable,
        conflictLogsTable,
        exchangeRatesTable,
        discountsTable,
        refundsTable,
        voidLogsTable
      ];
}

typedef $$SubscriptionPlansTableTableCreateCompanionBuilder
    = SubscriptionPlansTableCompanion Function({
  Value<String> id,
  required String name,
  Value<int?> maxUsers,
  Value<int?> maxProducts,
  required String features,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SubscriptionPlansTableTableUpdateCompanionBuilder
    = SubscriptionPlansTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> maxUsers,
  Value<int?> maxProducts,
  Value<String> features,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SubscriptionPlansTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionPlansTableTable> {
  $$SubscriptionPlansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxUsers => $composableBuilder(
      column: $table.maxUsers, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxProducts => $composableBuilder(
      column: $table.maxProducts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get features => $composableBuilder(
      column: $table.features, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SubscriptionPlansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionPlansTableTable> {
  $$SubscriptionPlansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxUsers => $composableBuilder(
      column: $table.maxUsers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxProducts => $composableBuilder(
      column: $table.maxProducts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get features => $composableBuilder(
      column: $table.features, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SubscriptionPlansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionPlansTableTable> {
  $$SubscriptionPlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get maxUsers =>
      $composableBuilder(column: $table.maxUsers, builder: (column) => column);

  GeneratedColumn<int> get maxProducts => $composableBuilder(
      column: $table.maxProducts, builder: (column) => column);

  GeneratedColumn<String> get features =>
      $composableBuilder(column: $table.features, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SubscriptionPlansTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionPlansTableTable,
    SubscriptionPlansTableData,
    $$SubscriptionPlansTableTableFilterComposer,
    $$SubscriptionPlansTableTableOrderingComposer,
    $$SubscriptionPlansTableTableAnnotationComposer,
    $$SubscriptionPlansTableTableCreateCompanionBuilder,
    $$SubscriptionPlansTableTableUpdateCompanionBuilder,
    (
      SubscriptionPlansTableData,
      BaseReferences<_$AppDatabase, $SubscriptionPlansTableTable,
          SubscriptionPlansTableData>
    ),
    SubscriptionPlansTableData,
    PrefetchHooks Function()> {
  $$SubscriptionPlansTableTableTableManager(
      _$AppDatabase db, $SubscriptionPlansTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionPlansTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionPlansTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionPlansTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> maxUsers = const Value.absent(),
            Value<int?> maxProducts = const Value.absent(),
            Value<String> features = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionPlansTableCompanion(
            id: id,
            name: name,
            maxUsers: maxUsers,
            maxProducts: maxProducts,
            features: features,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<int?> maxUsers = const Value.absent(),
            Value<int?> maxProducts = const Value.absent(),
            required String features,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionPlansTableCompanion.insert(
            id: id,
            name: name,
            maxUsers: maxUsers,
            maxProducts: maxProducts,
            features: features,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubscriptionPlansTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SubscriptionPlansTableTable,
        SubscriptionPlansTableData,
        $$SubscriptionPlansTableTableFilterComposer,
        $$SubscriptionPlansTableTableOrderingComposer,
        $$SubscriptionPlansTableTableAnnotationComposer,
        $$SubscriptionPlansTableTableCreateCompanionBuilder,
        $$SubscriptionPlansTableTableUpdateCompanionBuilder,
        (
          SubscriptionPlansTableData,
          BaseReferences<_$AppDatabase, $SubscriptionPlansTableTable,
              SubscriptionPlansTableData>
        ),
        SubscriptionPlansTableData,
        PrefetchHooks Function()>;
typedef $$TenantsTableTableCreateCompanionBuilder = TenantsTableCompanion
    Function({
  Value<String> id,
  required String name,
  required String storeType,
  Value<String?> planId,
  Value<String> status,
  Value<String> defaultLang,
  Value<String> baseCurrency,
  Value<DateTime> createdAt,
  Value<DateTime?> expiresAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$TenantsTableTableUpdateCompanionBuilder = TenantsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> storeType,
  Value<String?> planId,
  Value<String> status,
  Value<String> defaultLang,
  Value<String> baseCurrency,
  Value<DateTime> createdAt,
  Value<DateTime?> expiresAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$TenantsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TenantsTableTable> {
  $$TenantsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storeType => $composableBuilder(
      column: $table.storeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultLang => $composableBuilder(
      column: $table.defaultLang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$TenantsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantsTableTable> {
  $$TenantsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storeType => $composableBuilder(
      column: $table.storeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultLang => $composableBuilder(
      column: $table.defaultLang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$TenantsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantsTableTable> {
  $$TenantsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get storeType =>
      $composableBuilder(column: $table.storeType, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get defaultLang => $composableBuilder(
      column: $table.defaultLang, builder: (column) => column);

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$TenantsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TenantsTableTable,
    TenantsTableData,
    $$TenantsTableTableFilterComposer,
    $$TenantsTableTableOrderingComposer,
    $$TenantsTableTableAnnotationComposer,
    $$TenantsTableTableCreateCompanionBuilder,
    $$TenantsTableTableUpdateCompanionBuilder,
    (
      TenantsTableData,
      BaseReferences<_$AppDatabase, $TenantsTableTable, TenantsTableData>
    ),
    TenantsTableData,
    PrefetchHooks Function()> {
  $$TenantsTableTableTableManager(_$AppDatabase db, $TenantsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> storeType = const Value.absent(),
            Value<String?> planId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> defaultLang = const Value.absent(),
            Value<String> baseCurrency = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TenantsTableCompanion(
            id: id,
            name: name,
            storeType: storeType,
            planId: planId,
            status: status,
            defaultLang: defaultLang,
            baseCurrency: baseCurrency,
            createdAt: createdAt,
            expiresAt: expiresAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            required String storeType,
            Value<String?> planId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> defaultLang = const Value.absent(),
            Value<String> baseCurrency = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TenantsTableCompanion.insert(
            id: id,
            name: name,
            storeType: storeType,
            planId: planId,
            status: status,
            defaultLang: defaultLang,
            baseCurrency: baseCurrency,
            createdAt: createdAt,
            expiresAt: expiresAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TenantsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TenantsTableTable,
    TenantsTableData,
    $$TenantsTableTableFilterComposer,
    $$TenantsTableTableOrderingComposer,
    $$TenantsTableTableAnnotationComposer,
    $$TenantsTableTableCreateCompanionBuilder,
    $$TenantsTableTableUpdateCompanionBuilder,
    (
      TenantsTableData,
      BaseReferences<_$AppDatabase, $TenantsTableTable, TenantsTableData>
    ),
    TenantsTableData,
    PrefetchHooks Function()>;
typedef $$UsersTableTableCreateCompanionBuilder = UsersTableCompanion Function({
  Value<String> id,
  required String tenantId,
  required String username,
  required String displayName,
  required String role,
  required String pinHash,
  Value<bool> isActive,
  Value<int> failedPinAttempts,
  Value<DateTime?> lockedUntil,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$UsersTableTableUpdateCompanionBuilder = UsersTableCompanion Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> username,
  Value<String> displayName,
  Value<String> role,
  Value<String> pinHash,
  Value<bool> isActive,
  Value<int> failedPinAttempts,
  Value<DateTime?> lockedUntil,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedPinAttempts => $composableBuilder(
      column: $table.failedPinAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedPinAttempts => $composableBuilder(
      column: $table.failedPinAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get failedPinAttempts => $composableBuilder(
      column: $table.failedPinAttempts, builder: (column) => column);

  GeneratedColumn<DateTime> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$UsersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (
      UsersTableData,
      BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>
    ),
    UsersTableData,
    PrefetchHooks Function()> {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> failedPinAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion(
            id: id,
            tenantId: tenantId,
            username: username,
            displayName: displayName,
            role: role,
            pinHash: pinHash,
            isActive: isActive,
            failedPinAttempts: failedPinAttempts,
            lockedUntil: lockedUntil,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String username,
            required String displayName,
            required String role,
            required String pinHash,
            Value<bool> isActive = const Value.absent(),
            Value<int> failedPinAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            username: username,
            displayName: displayName,
            role: role,
            pinHash: pinHash,
            isActive: isActive,
            failedPinAttempts: failedPinAttempts,
            lockedUntil: lockedUntil,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTableTable,
    UsersTableData,
    $$UsersTableTableFilterComposer,
    $$UsersTableTableOrderingComposer,
    $$UsersTableTableAnnotationComposer,
    $$UsersTableTableCreateCompanionBuilder,
    $$UsersTableTableUpdateCompanionBuilder,
    (
      UsersTableData,
      BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>
    ),
    UsersTableData,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  Value<String?> parentId,
  required String name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String?> parentId,
  Value<String> name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            id: id,
            tenantId: tenantId,
            parentId: parentId,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            Value<String?> parentId = const Value.absent(),
            required String name,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            parentId: parentId,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()>;
typedef $$ProductsTableTableCreateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  required String name,
  Value<String?> description,
  Value<String?> barcode,
  required double sellPrice,
  Value<double?> costPrice,
  Value<String?> unit,
  Value<int> minStock,
  Value<bool> isActive,
  Value<bool> hasVariants,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$ProductsTableTableUpdateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> name,
  Value<String?> description,
  Value<String?> barcode,
  Value<double> sellPrice,
  Value<double?> costPrice,
  Value<String?> unit,
  Value<int> minStock,
  Value<bool> isActive,
  Value<bool> hasVariants,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellPrice => $composableBuilder(
      column: $table.sellPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasVariants => $composableBuilder(
      column: $table.hasVariants, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellPrice => $composableBuilder(
      column: $table.sellPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasVariants => $composableBuilder(
      column: $table.hasVariants, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get sellPrice =>
      $composableBuilder(column: $table.sellPrice, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get hasVariants => $composableBuilder(
      column: $table.hasVariants, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$ProductsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()> {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> sellPrice = const Value.absent(),
            Value<double?> costPrice = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<int> minStock = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> hasVariants = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsTableCompanion(
            id: id,
            tenantId: tenantId,
            name: name,
            description: description,
            barcode: barcode,
            sellPrice: sellPrice,
            costPrice: costPrice,
            unit: unit,
            minStock: minStock,
            isActive: isActive,
            hasVariants: hasVariants,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            required double sellPrice,
            Value<double?> costPrice = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<int> minStock = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> hasVariants = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            name: name,
            description: description,
            barcode: barcode,
            sellPrice: sellPrice,
            costPrice: costPrice,
            unit: unit,
            minStock: minStock,
            isActive: isActive,
            hasVariants: hasVariants,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()>;
typedef $$ProductVariantsTableTableCreateCompanionBuilder
    = ProductVariantsTableCompanion Function({
  Value<String> id,
  required String productId,
  required String tenantId,
  required String name,
  Value<String?> barcode,
  Value<double?> sellPrice,
  Value<double?> costPrice,
  Value<int> stockQty,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$ProductVariantsTableTableUpdateCompanionBuilder
    = ProductVariantsTableCompanion Function({
  Value<String> id,
  Value<String> productId,
  Value<String> tenantId,
  Value<String> name,
  Value<String?> barcode,
  Value<double?> sellPrice,
  Value<double?> costPrice,
  Value<int> stockQty,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$ProductVariantsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductVariantsTableTable> {
  $$ProductVariantsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellPrice => $composableBuilder(
      column: $table.sellPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$ProductVariantsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductVariantsTableTable> {
  $$ProductVariantsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellPrice => $composableBuilder(
      column: $table.sellPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductVariantsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductVariantsTableTable> {
  $$ProductVariantsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get sellPrice =>
      $composableBuilder(column: $table.sellPrice, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$ProductVariantsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductVariantsTableTable,
    ProductVariantsTableData,
    $$ProductVariantsTableTableFilterComposer,
    $$ProductVariantsTableTableOrderingComposer,
    $$ProductVariantsTableTableAnnotationComposer,
    $$ProductVariantsTableTableCreateCompanionBuilder,
    $$ProductVariantsTableTableUpdateCompanionBuilder,
    (
      ProductVariantsTableData,
      BaseReferences<_$AppDatabase, $ProductVariantsTableTable,
          ProductVariantsTableData>
    ),
    ProductVariantsTableData,
    PrefetchHooks Function()> {
  $$ProductVariantsTableTableTableManager(
      _$AppDatabase db, $ProductVariantsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductVariantsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductVariantsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductVariantsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double?> sellPrice = const Value.absent(),
            Value<double?> costPrice = const Value.absent(),
            Value<int> stockQty = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductVariantsTableCompanion(
            id: id,
            productId: productId,
            tenantId: tenantId,
            name: name,
            barcode: barcode,
            sellPrice: sellPrice,
            costPrice: costPrice,
            stockQty: stockQty,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String productId,
            required String tenantId,
            required String name,
            Value<String?> barcode = const Value.absent(),
            Value<double?> sellPrice = const Value.absent(),
            Value<double?> costPrice = const Value.absent(),
            Value<int> stockQty = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductVariantsTableCompanion.insert(
            id: id,
            productId: productId,
            tenantId: tenantId,
            name: name,
            barcode: barcode,
            sellPrice: sellPrice,
            costPrice: costPrice,
            stockQty: stockQty,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductVariantsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ProductVariantsTableTable,
        ProductVariantsTableData,
        $$ProductVariantsTableTableFilterComposer,
        $$ProductVariantsTableTableOrderingComposer,
        $$ProductVariantsTableTableAnnotationComposer,
        $$ProductVariantsTableTableCreateCompanionBuilder,
        $$ProductVariantsTableTableUpdateCompanionBuilder,
        (
          ProductVariantsTableData,
          BaseReferences<_$AppDatabase, $ProductVariantsTableTable,
              ProductVariantsTableData>
        ),
        ProductVariantsTableData,
        PrefetchHooks Function()>;
typedef $$OrdersTableTableCreateCompanionBuilder = OrdersTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  required String orderNumber,
  Value<String?> tableId,
  required String cashierId,
  Value<String?> shiftId,
  Value<String> status,
  Value<double> subtotal,
  Value<double> discountAmount,
  Value<double> taxAmount,
  Value<double> total,
  Value<String?> notes,
  Value<String?> idempotencyKey,
  Value<DateTime> createdAt,
  Value<DateTime?> paidAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$OrdersTableTableUpdateCompanionBuilder = OrdersTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> orderNumber,
  Value<String?> tableId,
  Value<String> cashierId,
  Value<String?> shiftId,
  Value<String> status,
  Value<double> subtotal,
  Value<double> discountAmount,
  Value<double> taxAmount,
  Value<double> total,
  Value<String?> notes,
  Value<String?> idempotencyKey,
  Value<DateTime> createdAt,
  Value<DateTime?> paidAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$OrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cashierId => $composableBuilder(
      column: $table.cashierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cashierId => $composableBuilder(
      column: $table.cashierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => column);

  GeneratedColumn<String> get tableId =>
      $composableBuilder(column: $table.tableId, builder: (column) => column);

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$OrdersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrdersTableData,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (
      OrdersTableData,
      BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>
    ),
    OrdersTableData,
    PrefetchHooks Function()> {
  $$OrdersTableTableTableManager(_$AppDatabase db, $OrdersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> orderNumber = const Value.absent(),
            Value<String?> tableId = const Value.absent(),
            Value<String> cashierId = const Value.absent(),
            Value<String?> shiftId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> idempotencyKey = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersTableCompanion(
            id: id,
            tenantId: tenantId,
            orderNumber: orderNumber,
            tableId: tableId,
            cashierId: cashierId,
            shiftId: shiftId,
            status: status,
            subtotal: subtotal,
            discountAmount: discountAmount,
            taxAmount: taxAmount,
            total: total,
            notes: notes,
            idempotencyKey: idempotencyKey,
            createdAt: createdAt,
            paidAt: paidAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String orderNumber,
            Value<String?> tableId = const Value.absent(),
            required String cashierId,
            Value<String?> shiftId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> idempotencyKey = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            orderNumber: orderNumber,
            tableId: tableId,
            cashierId: cashierId,
            shiftId: shiftId,
            status: status,
            subtotal: subtotal,
            discountAmount: discountAmount,
            taxAmount: taxAmount,
            total: total,
            notes: notes,
            idempotencyKey: idempotencyKey,
            createdAt: createdAt,
            paidAt: paidAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OrdersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrdersTableData,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (
      OrdersTableData,
      BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>
    ),
    OrdersTableData,
    PrefetchHooks Function()>;
typedef $$OrderItemsTableTableCreateCompanionBuilder = OrderItemsTableCompanion
    Function({
  Value<String> id,
  required String orderId,
  required String tenantId,
  required String productId,
  Value<String?> variantId,
  required String productName,
  required double unitPrice,
  required int quantity,
  Value<double> discount,
  required double lineTotal,
  Value<String?> modifiers,
  Value<String?> notes,
  Value<String> kdsStatus,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$OrderItemsTableTableUpdateCompanionBuilder = OrderItemsTableCompanion
    Function({
  Value<String> id,
  Value<String> orderId,
  Value<String> tenantId,
  Value<String> productId,
  Value<String?> variantId,
  Value<String> productName,
  Value<double> unitPrice,
  Value<int> quantity,
  Value<double> discount,
  Value<double> lineTotal,
  Value<String?> modifiers,
  Value<String?> notes,
  Value<String> kdsStatus,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$OrderItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get variantId => $composableBuilder(
      column: $table.variantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modifiers => $composableBuilder(
      column: $table.modifiers, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kdsStatus => $composableBuilder(
      column: $table.kdsStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$OrderItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get variantId => $composableBuilder(
      column: $table.variantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modifiers => $composableBuilder(
      column: $table.modifiers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kdsStatus => $composableBuilder(
      column: $table.kdsStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$OrderItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get variantId =>
      $composableBuilder(column: $table.variantId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<String> get modifiers =>
      $composableBuilder(column: $table.modifiers, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get kdsStatus =>
      $composableBuilder(column: $table.kdsStatus, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$OrderItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTableTable,
    OrderItemsTableData,
    $$OrderItemsTableTableFilterComposer,
    $$OrderItemsTableTableOrderingComposer,
    $$OrderItemsTableTableAnnotationComposer,
    $$OrderItemsTableTableCreateCompanionBuilder,
    $$OrderItemsTableTableUpdateCompanionBuilder,
    (
      OrderItemsTableData,
      BaseReferences<_$AppDatabase, $OrderItemsTableTable, OrderItemsTableData>
    ),
    OrderItemsTableData,
    PrefetchHooks Function()> {
  $$OrderItemsTableTableTableManager(
      _$AppDatabase db, $OrderItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> orderId = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String?> variantId = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<String?> modifiers = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> kdsStatus = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrderItemsTableCompanion(
            id: id,
            orderId: orderId,
            tenantId: tenantId,
            productId: productId,
            variantId: variantId,
            productName: productName,
            unitPrice: unitPrice,
            quantity: quantity,
            discount: discount,
            lineTotal: lineTotal,
            modifiers: modifiers,
            notes: notes,
            kdsStatus: kdsStatus,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String orderId,
            required String tenantId,
            required String productId,
            Value<String?> variantId = const Value.absent(),
            required String productName,
            required double unitPrice,
            required int quantity,
            Value<double> discount = const Value.absent(),
            required double lineTotal,
            Value<String?> modifiers = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> kdsStatus = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrderItemsTableCompanion.insert(
            id: id,
            orderId: orderId,
            tenantId: tenantId,
            productId: productId,
            variantId: variantId,
            productName: productName,
            unitPrice: unitPrice,
            quantity: quantity,
            discount: discount,
            lineTotal: lineTotal,
            modifiers: modifiers,
            notes: notes,
            kdsStatus: kdsStatus,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OrderItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTableTable,
    OrderItemsTableData,
    $$OrderItemsTableTableFilterComposer,
    $$OrderItemsTableTableOrderingComposer,
    $$OrderItemsTableTableAnnotationComposer,
    $$OrderItemsTableTableCreateCompanionBuilder,
    $$OrderItemsTableTableUpdateCompanionBuilder,
    (
      OrderItemsTableData,
      BaseReferences<_$AppDatabase, $OrderItemsTableTable, OrderItemsTableData>
    ),
    OrderItemsTableData,
    PrefetchHooks Function()>;
typedef $$PaymentsTableTableCreateCompanionBuilder = PaymentsTableCompanion
    Function({
  Value<String> id,
  required String orderId,
  required String tenantId,
  required String method,
  required String currency,
  required double amount,
  required double amountLak,
  Value<double> exchangeRate,
  Value<double> changeAmount,
  Value<String?> confirmedBy,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$PaymentsTableTableUpdateCompanionBuilder = PaymentsTableCompanion
    Function({
  Value<String> id,
  Value<String> orderId,
  Value<String> tenantId,
  Value<String> method,
  Value<String> currency,
  Value<double> amount,
  Value<double> amountLak,
  Value<double> exchangeRate,
  Value<double> changeAmount,
  Value<String?> confirmedBy,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$PaymentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountLak => $composableBuilder(
      column: $table.amountLak, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confirmedBy => $composableBuilder(
      column: $table.confirmedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$PaymentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountLak => $composableBuilder(
      column: $table.amountLak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get changeAmount => $composableBuilder(
      column: $table.changeAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confirmedBy => $composableBuilder(
      column: $table.confirmedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$PaymentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTableTable> {
  $$PaymentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get amountLak =>
      $composableBuilder(column: $table.amountLak, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => column);

  GeneratedColumn<double> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => column);

  GeneratedColumn<String> get confirmedBy => $composableBuilder(
      column: $table.confirmedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$PaymentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTableTable,
    PaymentsTableData,
    $$PaymentsTableTableFilterComposer,
    $$PaymentsTableTableOrderingComposer,
    $$PaymentsTableTableAnnotationComposer,
    $$PaymentsTableTableCreateCompanionBuilder,
    $$PaymentsTableTableUpdateCompanionBuilder,
    (
      PaymentsTableData,
      BaseReferences<_$AppDatabase, $PaymentsTableTable, PaymentsTableData>
    ),
    PaymentsTableData,
    PrefetchHooks Function()> {
  $$PaymentsTableTableTableManager(_$AppDatabase db, $PaymentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> orderId = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> amountLak = const Value.absent(),
            Value<double> exchangeRate = const Value.absent(),
            Value<double> changeAmount = const Value.absent(),
            Value<String?> confirmedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsTableCompanion(
            id: id,
            orderId: orderId,
            tenantId: tenantId,
            method: method,
            currency: currency,
            amount: amount,
            amountLak: amountLak,
            exchangeRate: exchangeRate,
            changeAmount: changeAmount,
            confirmedBy: confirmedBy,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String orderId,
            required String tenantId,
            required String method,
            required String currency,
            required double amount,
            required double amountLak,
            Value<double> exchangeRate = const Value.absent(),
            Value<double> changeAmount = const Value.absent(),
            Value<String?> confirmedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsTableCompanion.insert(
            id: id,
            orderId: orderId,
            tenantId: tenantId,
            method: method,
            currency: currency,
            amount: amount,
            amountLak: amountLak,
            exchangeRate: exchangeRate,
            changeAmount: changeAmount,
            confirmedBy: confirmedBy,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTableTable,
    PaymentsTableData,
    $$PaymentsTableTableFilterComposer,
    $$PaymentsTableTableOrderingComposer,
    $$PaymentsTableTableAnnotationComposer,
    $$PaymentsTableTableCreateCompanionBuilder,
    $$PaymentsTableTableUpdateCompanionBuilder,
    (
      PaymentsTableData,
      BaseReferences<_$AppDatabase, $PaymentsTableTable, PaymentsTableData>
    ),
    PaymentsTableData,
    PrefetchHooks Function()>;
typedef $$RestaurantTablesTableTableCreateCompanionBuilder
    = RestaurantTablesTableCompanion Function({
  Value<String> id,
  required String tenantId,
  Value<String?> zone,
  required String tableNumber,
  Value<int?> capacity,
  Value<String> status,
  Value<DateTime?> openedAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$RestaurantTablesTableTableUpdateCompanionBuilder
    = RestaurantTablesTableCompanion Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String?> zone,
  Value<String> tableNumber,
  Value<int?> capacity,
  Value<String> status,
  Value<DateTime?> openedAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$RestaurantTablesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTableTable> {
  $$RestaurantTablesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zone => $composableBuilder(
      column: $table.zone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$RestaurantTablesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTableTable> {
  $$RestaurantTablesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zone => $composableBuilder(
      column: $table.zone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$RestaurantTablesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTableTable> {
  $$RestaurantTablesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$RestaurantTablesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RestaurantTablesTableTable,
    RestaurantTablesTableData,
    $$RestaurantTablesTableTableFilterComposer,
    $$RestaurantTablesTableTableOrderingComposer,
    $$RestaurantTablesTableTableAnnotationComposer,
    $$RestaurantTablesTableTableCreateCompanionBuilder,
    $$RestaurantTablesTableTableUpdateCompanionBuilder,
    (
      RestaurantTablesTableData,
      BaseReferences<_$AppDatabase, $RestaurantTablesTableTable,
          RestaurantTablesTableData>
    ),
    RestaurantTablesTableData,
    PrefetchHooks Function()> {
  $$RestaurantTablesTableTableTableManager(
      _$AppDatabase db, $RestaurantTablesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestaurantTablesTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$RestaurantTablesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestaurantTablesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String?> zone = const Value.absent(),
            Value<String> tableNumber = const Value.absent(),
            Value<int?> capacity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> openedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RestaurantTablesTableCompanion(
            id: id,
            tenantId: tenantId,
            zone: zone,
            tableNumber: tableNumber,
            capacity: capacity,
            status: status,
            openedAt: openedAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            Value<String?> zone = const Value.absent(),
            required String tableNumber,
            Value<int?> capacity = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> openedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RestaurantTablesTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            zone: zone,
            tableNumber: tableNumber,
            capacity: capacity,
            status: status,
            openedAt: openedAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RestaurantTablesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $RestaurantTablesTableTable,
        RestaurantTablesTableData,
        $$RestaurantTablesTableTableFilterComposer,
        $$RestaurantTablesTableTableOrderingComposer,
        $$RestaurantTablesTableTableAnnotationComposer,
        $$RestaurantTablesTableTableCreateCompanionBuilder,
        $$RestaurantTablesTableTableUpdateCompanionBuilder,
        (
          RestaurantTablesTableData,
          BaseReferences<_$AppDatabase, $RestaurantTablesTableTable,
              RestaurantTablesTableData>
        ),
        RestaurantTablesTableData,
        PrefetchHooks Function()>;
typedef $$ShiftsTableTableCreateCompanionBuilder = ShiftsTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  required String cashierId,
  Value<String?> deviceId,
  required double openingBalance,
  Value<double?> closingBalance,
  Value<String> status,
  Value<DateTime> openedAt,
  Value<DateTime?> closedAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$ShiftsTableTableUpdateCompanionBuilder = ShiftsTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> cashierId,
  Value<String?> deviceId,
  Value<double> openingBalance,
  Value<double?> closingBalance,
  Value<String> status,
  Value<DateTime> openedAt,
  Value<DateTime?> closedAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$ShiftsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTableTable> {
  $$ShiftsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cashierId => $composableBuilder(
      column: $table.cashierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$ShiftsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTableTable> {
  $$ShiftsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cashierId => $composableBuilder(
      column: $table.cashierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ShiftsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTableTable> {
  $$ShiftsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance, builder: (column) => column);

  GeneratedColumn<double> get closingBalance => $composableBuilder(
      column: $table.closingBalance, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$ShiftsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShiftsTableTable,
    ShiftsTableData,
    $$ShiftsTableTableFilterComposer,
    $$ShiftsTableTableOrderingComposer,
    $$ShiftsTableTableAnnotationComposer,
    $$ShiftsTableTableCreateCompanionBuilder,
    $$ShiftsTableTableUpdateCompanionBuilder,
    (
      ShiftsTableData,
      BaseReferences<_$AppDatabase, $ShiftsTableTable, ShiftsTableData>
    ),
    ShiftsTableData,
    PrefetchHooks Function()> {
  $$ShiftsTableTableTableManager(_$AppDatabase db, $ShiftsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> cashierId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<double?> closingBalance = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShiftsTableCompanion(
            id: id,
            tenantId: tenantId,
            cashierId: cashierId,
            deviceId: deviceId,
            openingBalance: openingBalance,
            closingBalance: closingBalance,
            status: status,
            openedAt: openedAt,
            closedAt: closedAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String cashierId,
            Value<String?> deviceId = const Value.absent(),
            required double openingBalance,
            Value<double?> closingBalance = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShiftsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            cashierId: cashierId,
            deviceId: deviceId,
            openingBalance: openingBalance,
            closingBalance: closingBalance,
            status: status,
            openedAt: openedAt,
            closedAt: closedAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShiftsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShiftsTableTable,
    ShiftsTableData,
    $$ShiftsTableTableFilterComposer,
    $$ShiftsTableTableOrderingComposer,
    $$ShiftsTableTableAnnotationComposer,
    $$ShiftsTableTableCreateCompanionBuilder,
    $$ShiftsTableTableUpdateCompanionBuilder,
    (
      ShiftsTableData,
      BaseReferences<_$AppDatabase, $ShiftsTableTable, ShiftsTableData>
    ),
    ShiftsTableData,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  Value<String?> deviceId,
  required String entityType,
  required String entityId,
  required String operation,
  required String payload,
  required String idempotencyKey,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String?> deviceId,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payload,
  Value<String> idempotencyKey,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
      _$AppDatabase db, $SyncQueueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion(
            id: id,
            tenantId: tenantId,
            deviceId: deviceId,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            idempotencyKey: idempotencyKey,
            status: status,
            createdAt: createdAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            Value<String?> deviceId = const Value.absent(),
            required String entityType,
            required String entityId,
            required String operation,
            required String payload,
            required String idempotencyKey,
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            deviceId: deviceId,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            idempotencyKey: idempotencyKey,
            status: status,
            createdAt: createdAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()>;
typedef $$ConflictLogsTableTableCreateCompanionBuilder
    = ConflictLogsTableCompanion Function({
  Value<String> id,
  required String tenantId,
  required String entityType,
  required String entityId,
  Value<String?> localValue,
  Value<String?> serverValue,
  Value<String?> resolution,
  Value<String?> resolvedBy,
  Value<DateTime> createdAt,
  Value<DateTime?> resolvedAt,
  Value<int> rowid,
});
typedef $$ConflictLogsTableTableUpdateCompanionBuilder
    = ConflictLogsTableCompanion Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> entityType,
  Value<String> entityId,
  Value<String?> localValue,
  Value<String?> serverValue,
  Value<String?> resolution,
  Value<String?> resolvedBy,
  Value<DateTime> createdAt,
  Value<DateTime?> resolvedAt,
  Value<int> rowid,
});

class $$ConflictLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConflictLogsTableTable> {
  $$ConflictLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localValue => $composableBuilder(
      column: $table.localValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverValue => $composableBuilder(
      column: $table.serverValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolvedBy => $composableBuilder(
      column: $table.resolvedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnFilters(column));
}

class $$ConflictLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConflictLogsTableTable> {
  $$ConflictLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localValue => $composableBuilder(
      column: $table.localValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverValue => $composableBuilder(
      column: $table.serverValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolvedBy => $composableBuilder(
      column: $table.resolvedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnOrderings(column));
}

class $$ConflictLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConflictLogsTableTable> {
  $$ConflictLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get localValue => $composableBuilder(
      column: $table.localValue, builder: (column) => column);

  GeneratedColumn<String> get serverValue => $composableBuilder(
      column: $table.serverValue, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);

  GeneratedColumn<String> get resolvedBy => $composableBuilder(
      column: $table.resolvedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => column);
}

class $$ConflictLogsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConflictLogsTableTable,
    ConflictLogsTableData,
    $$ConflictLogsTableTableFilterComposer,
    $$ConflictLogsTableTableOrderingComposer,
    $$ConflictLogsTableTableAnnotationComposer,
    $$ConflictLogsTableTableCreateCompanionBuilder,
    $$ConflictLogsTableTableUpdateCompanionBuilder,
    (
      ConflictLogsTableData,
      BaseReferences<_$AppDatabase, $ConflictLogsTableTable,
          ConflictLogsTableData>
    ),
    ConflictLogsTableData,
    PrefetchHooks Function()> {
  $$ConflictLogsTableTableTableManager(
      _$AppDatabase db, $ConflictLogsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConflictLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConflictLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConflictLogsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String?> localValue = const Value.absent(),
            Value<String?> serverValue = const Value.absent(),
            Value<String?> resolution = const Value.absent(),
            Value<String?> resolvedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> resolvedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConflictLogsTableCompanion(
            id: id,
            tenantId: tenantId,
            entityType: entityType,
            entityId: entityId,
            localValue: localValue,
            serverValue: serverValue,
            resolution: resolution,
            resolvedBy: resolvedBy,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String entityType,
            required String entityId,
            Value<String?> localValue = const Value.absent(),
            Value<String?> serverValue = const Value.absent(),
            Value<String?> resolution = const Value.absent(),
            Value<String?> resolvedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> resolvedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConflictLogsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            entityType: entityType,
            entityId: entityId,
            localValue: localValue,
            serverValue: serverValue,
            resolution: resolution,
            resolvedBy: resolvedBy,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConflictLogsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConflictLogsTableTable,
    ConflictLogsTableData,
    $$ConflictLogsTableTableFilterComposer,
    $$ConflictLogsTableTableOrderingComposer,
    $$ConflictLogsTableTableAnnotationComposer,
    $$ConflictLogsTableTableCreateCompanionBuilder,
    $$ConflictLogsTableTableUpdateCompanionBuilder,
    (
      ConflictLogsTableData,
      BaseReferences<_$AppDatabase, $ConflictLogsTableTable,
          ConflictLogsTableData>
    ),
    ConflictLogsTableData,
    PrefetchHooks Function()>;
typedef $$ExchangeRatesTableTableCreateCompanionBuilder
    = ExchangeRatesTableCompanion Function({
  Value<String> id,
  required String tenantId,
  required String currency,
  required double rate,
  Value<String?> setBy,
  Value<DateTime> effectiveAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$ExchangeRatesTableTableUpdateCompanionBuilder
    = ExchangeRatesTableCompanion Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> currency,
  Value<double> rate,
  Value<String?> setBy,
  Value<DateTime> effectiveAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$ExchangeRatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTableTable> {
  $$ExchangeRatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setBy => $composableBuilder(
      column: $table.setBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get effectiveAt => $composableBuilder(
      column: $table.effectiveAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$ExchangeRatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTableTable> {
  $$ExchangeRatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setBy => $composableBuilder(
      column: $table.setBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get effectiveAt => $composableBuilder(
      column: $table.effectiveAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ExchangeRatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTableTable> {
  $$ExchangeRatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<String> get setBy =>
      $composableBuilder(column: $table.setBy, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveAt => $composableBuilder(
      column: $table.effectiveAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$ExchangeRatesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExchangeRatesTableTable,
    ExchangeRatesTableData,
    $$ExchangeRatesTableTableFilterComposer,
    $$ExchangeRatesTableTableOrderingComposer,
    $$ExchangeRatesTableTableAnnotationComposer,
    $$ExchangeRatesTableTableCreateCompanionBuilder,
    $$ExchangeRatesTableTableUpdateCompanionBuilder,
    (
      ExchangeRatesTableData,
      BaseReferences<_$AppDatabase, $ExchangeRatesTableTable,
          ExchangeRatesTableData>
    ),
    ExchangeRatesTableData,
    PrefetchHooks Function()> {
  $$ExchangeRatesTableTableTableManager(
      _$AppDatabase db, $ExchangeRatesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> rate = const Value.absent(),
            Value<String?> setBy = const Value.absent(),
            Value<DateTime> effectiveAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesTableCompanion(
            id: id,
            tenantId: tenantId,
            currency: currency,
            rate: rate,
            setBy: setBy,
            effectiveAt: effectiveAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String currency,
            required double rate,
            Value<String?> setBy = const Value.absent(),
            Value<DateTime> effectiveAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            currency: currency,
            rate: rate,
            setBy: setBy,
            effectiveAt: effectiveAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExchangeRatesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExchangeRatesTableTable,
    ExchangeRatesTableData,
    $$ExchangeRatesTableTableFilterComposer,
    $$ExchangeRatesTableTableOrderingComposer,
    $$ExchangeRatesTableTableAnnotationComposer,
    $$ExchangeRatesTableTableCreateCompanionBuilder,
    $$ExchangeRatesTableTableUpdateCompanionBuilder,
    (
      ExchangeRatesTableData,
      BaseReferences<_$AppDatabase, $ExchangeRatesTableTable,
          ExchangeRatesTableData>
    ),
    ExchangeRatesTableData,
    PrefetchHooks Function()>;
typedef $$DiscountsTableTableCreateCompanionBuilder = DiscountsTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  required String name,
  required String type,
  required double value,
  required String scope,
  Value<String?> productId,
  Value<DateTime?> startsAt,
  Value<DateTime?> endsAt,
  Value<bool> isActive,
  Value<bool> requiresApproval,
  Value<String?> createdBy,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$DiscountsTableTableUpdateCompanionBuilder = DiscountsTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> name,
  Value<String> type,
  Value<double> value,
  Value<String> scope,
  Value<String?> productId,
  Value<DateTime?> startsAt,
  Value<DateTime?> endsAt,
  Value<bool> isActive,
  Value<bool> requiresApproval,
  Value<String?> createdBy,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$DiscountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scope => $composableBuilder(
      column: $table.scope, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
      column: $table.startsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
      column: $table.endsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get requiresApproval => $composableBuilder(
      column: $table.requiresApproval,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$DiscountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scope => $composableBuilder(
      column: $table.scope, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
      column: $table.startsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
      column: $table.endsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get requiresApproval => $composableBuilder(
      column: $table.requiresApproval,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$DiscountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get requiresApproval => $composableBuilder(
      column: $table.requiresApproval, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$DiscountsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiscountsTableTable,
    DiscountsTableData,
    $$DiscountsTableTableFilterComposer,
    $$DiscountsTableTableOrderingComposer,
    $$DiscountsTableTableAnnotationComposer,
    $$DiscountsTableTableCreateCompanionBuilder,
    $$DiscountsTableTableUpdateCompanionBuilder,
    (
      DiscountsTableData,
      BaseReferences<_$AppDatabase, $DiscountsTableTable, DiscountsTableData>
    ),
    DiscountsTableData,
    PrefetchHooks Function()> {
  $$DiscountsTableTableTableManager(
      _$AppDatabase db, $DiscountsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<String> scope = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<DateTime?> startsAt = const Value.absent(),
            Value<DateTime?> endsAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> requiresApproval = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DiscountsTableCompanion(
            id: id,
            tenantId: tenantId,
            name: name,
            type: type,
            value: value,
            scope: scope,
            productId: productId,
            startsAt: startsAt,
            endsAt: endsAt,
            isActive: isActive,
            requiresApproval: requiresApproval,
            createdBy: createdBy,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String name,
            required String type,
            required double value,
            required String scope,
            Value<String?> productId = const Value.absent(),
            Value<DateTime?> startsAt = const Value.absent(),
            Value<DateTime?> endsAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> requiresApproval = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DiscountsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            name: name,
            type: type,
            value: value,
            scope: scope,
            productId: productId,
            startsAt: startsAt,
            endsAt: endsAt,
            isActive: isActive,
            requiresApproval: requiresApproval,
            createdBy: createdBy,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DiscountsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiscountsTableTable,
    DiscountsTableData,
    $$DiscountsTableTableFilterComposer,
    $$DiscountsTableTableOrderingComposer,
    $$DiscountsTableTableAnnotationComposer,
    $$DiscountsTableTableCreateCompanionBuilder,
    $$DiscountsTableTableUpdateCompanionBuilder,
    (
      DiscountsTableData,
      BaseReferences<_$AppDatabase, $DiscountsTableTable, DiscountsTableData>
    ),
    DiscountsTableData,
    PrefetchHooks Function()>;
typedef $$RefundsTableTableCreateCompanionBuilder = RefundsTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  required String originalOrderId,
  required String reason,
  required String approvedBy,
  required double totalRefund,
  required String currency,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$RefundsTableTableUpdateCompanionBuilder = RefundsTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> originalOrderId,
  Value<String> reason,
  Value<String> approvedBy,
  Value<double> totalRefund,
  Value<String> currency,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$RefundsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RefundsTableTable> {
  $$RefundsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalOrderId => $composableBuilder(
      column: $table.originalOrderId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalRefund => $composableBuilder(
      column: $table.totalRefund, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$RefundsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RefundsTableTable> {
  $$RefundsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalOrderId => $composableBuilder(
      column: $table.originalOrderId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalRefund => $composableBuilder(
      column: $table.totalRefund, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$RefundsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefundsTableTable> {
  $$RefundsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get originalOrderId => $composableBuilder(
      column: $table.originalOrderId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => column);

  GeneratedColumn<double> get totalRefund => $composableBuilder(
      column: $table.totalRefund, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$RefundsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RefundsTableTable,
    RefundsTableData,
    $$RefundsTableTableFilterComposer,
    $$RefundsTableTableOrderingComposer,
    $$RefundsTableTableAnnotationComposer,
    $$RefundsTableTableCreateCompanionBuilder,
    $$RefundsTableTableUpdateCompanionBuilder,
    (
      RefundsTableData,
      BaseReferences<_$AppDatabase, $RefundsTableTable, RefundsTableData>
    ),
    RefundsTableData,
    PrefetchHooks Function()> {
  $$RefundsTableTableTableManager(_$AppDatabase db, $RefundsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RefundsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RefundsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RefundsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> originalOrderId = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> approvedBy = const Value.absent(),
            Value<double> totalRefund = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RefundsTableCompanion(
            id: id,
            tenantId: tenantId,
            originalOrderId: originalOrderId,
            reason: reason,
            approvedBy: approvedBy,
            totalRefund: totalRefund,
            currency: currency,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String originalOrderId,
            required String reason,
            required String approvedBy,
            required double totalRefund,
            required String currency,
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RefundsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            originalOrderId: originalOrderId,
            reason: reason,
            approvedBy: approvedBy,
            totalRefund: totalRefund,
            currency: currency,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RefundsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RefundsTableTable,
    RefundsTableData,
    $$RefundsTableTableFilterComposer,
    $$RefundsTableTableOrderingComposer,
    $$RefundsTableTableAnnotationComposer,
    $$RefundsTableTableCreateCompanionBuilder,
    $$RefundsTableTableUpdateCompanionBuilder,
    (
      RefundsTableData,
      BaseReferences<_$AppDatabase, $RefundsTableTable, RefundsTableData>
    ),
    RefundsTableData,
    PrefetchHooks Function()>;
typedef $$VoidLogsTableTableCreateCompanionBuilder = VoidLogsTableCompanion
    Function({
  Value<String> id,
  required String tenantId,
  required String orderId,
  required String reason,
  required String voidedBy,
  Value<String?> shiftId,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});
typedef $$VoidLogsTableTableUpdateCompanionBuilder = VoidLogsTableCompanion
    Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> orderId,
  Value<String> reason,
  Value<String> voidedBy,
  Value<String?> shiftId,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> localUpdatedAt,
  Value<int> rowid,
});

class $$VoidLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $VoidLogsTableTable> {
  $$VoidLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voidedBy => $composableBuilder(
      column: $table.voidedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$VoidLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VoidLogsTableTable> {
  $$VoidLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voidedBy => $composableBuilder(
      column: $table.voidedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$VoidLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoidLogsTableTable> {
  $$VoidLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get voidedBy =>
      $composableBuilder(column: $table.voidedBy, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);
}

class $$VoidLogsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VoidLogsTableTable,
    VoidLogsTableData,
    $$VoidLogsTableTableFilterComposer,
    $$VoidLogsTableTableOrderingComposer,
    $$VoidLogsTableTableAnnotationComposer,
    $$VoidLogsTableTableCreateCompanionBuilder,
    $$VoidLogsTableTableUpdateCompanionBuilder,
    (
      VoidLogsTableData,
      BaseReferences<_$AppDatabase, $VoidLogsTableTable, VoidLogsTableData>
    ),
    VoidLogsTableData,
    PrefetchHooks Function()> {
  $$VoidLogsTableTableTableManager(_$AppDatabase db, $VoidLogsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoidLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoidLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoidLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tenantId = const Value.absent(),
            Value<String> orderId = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> voidedBy = const Value.absent(),
            Value<String?> shiftId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VoidLogsTableCompanion(
            id: id,
            tenantId: tenantId,
            orderId: orderId,
            reason: reason,
            voidedBy: voidedBy,
            shiftId: shiftId,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String tenantId,
            required String orderId,
            required String reason,
            required String voidedBy,
            Value<String?> shiftId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> localUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VoidLogsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            orderId: orderId,
            reason: reason,
            voidedBy: voidedBy,
            shiftId: shiftId,
            createdAt: createdAt,
            isSynced: isSynced,
            localUpdatedAt: localUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VoidLogsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VoidLogsTableTable,
    VoidLogsTableData,
    $$VoidLogsTableTableFilterComposer,
    $$VoidLogsTableTableOrderingComposer,
    $$VoidLogsTableTableAnnotationComposer,
    $$VoidLogsTableTableCreateCompanionBuilder,
    $$VoidLogsTableTableUpdateCompanionBuilder,
    (
      VoidLogsTableData,
      BaseReferences<_$AppDatabase, $VoidLogsTableTable, VoidLogsTableData>
    ),
    VoidLogsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubscriptionPlansTableTableTableManager get subscriptionPlansTable =>
      $$SubscriptionPlansTableTableTableManager(
          _db, _db.subscriptionPlansTable);
  $$TenantsTableTableTableManager get tenantsTable =>
      $$TenantsTableTableTableManager(_db, _db.tenantsTable);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$ProductVariantsTableTableTableManager get productVariantsTable =>
      $$ProductVariantsTableTableTableManager(_db, _db.productVariantsTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(_db, _db.orderItemsTable);
  $$PaymentsTableTableTableManager get paymentsTable =>
      $$PaymentsTableTableTableManager(_db, _db.paymentsTable);
  $$RestaurantTablesTableTableTableManager get restaurantTablesTable =>
      $$RestaurantTablesTableTableTableManager(_db, _db.restaurantTablesTable);
  $$ShiftsTableTableTableManager get shiftsTable =>
      $$ShiftsTableTableTableManager(_db, _db.shiftsTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$ConflictLogsTableTableTableManager get conflictLogsTable =>
      $$ConflictLogsTableTableTableManager(_db, _db.conflictLogsTable);
  $$ExchangeRatesTableTableTableManager get exchangeRatesTable =>
      $$ExchangeRatesTableTableTableManager(_db, _db.exchangeRatesTable);
  $$DiscountsTableTableTableManager get discountsTable =>
      $$DiscountsTableTableTableManager(_db, _db.discountsTable);
  $$RefundsTableTableTableManager get refundsTable =>
      $$RefundsTableTableTableManager(_db, _db.refundsTable);
  $$VoidLogsTableTableTableManager get voidLogsTable =>
      $$VoidLogsTableTableTableManager(_db, _db.voidLogsTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'4db1c5efe1a73afafa926c6e91d12e49a68b1abc';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
