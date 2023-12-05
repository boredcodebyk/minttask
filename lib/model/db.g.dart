// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskDataCollection on Isar {
  IsarCollection<TaskData> get taskDatas => this.collection();
}

const TaskDataSchema = CollectionSchema(
  name: r'TaskData',
  id: 6386124436821998370,
  properties: {
    r'archive': PropertySchema(
      id: 0,
      name: r'archive',
      type: IsarType.bool,
    ),
    r'dateCreated': PropertySchema(
      id: 1,
      name: r'dateCreated',
      type: IsarType.dateTime,
    ),
    r'dateModified': PropertySchema(
      id: 2,
      name: r'dateModified',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'doNotify': PropertySchema(
      id: 4,
      name: r'doNotify',
      type: IsarType.bool,
    ),
    r'doneStatus': PropertySchema(
      id: 5,
      name: r'doneStatus',
      type: IsarType.bool,
    ),
    r'labels': PropertySchema(
      id: 6,
      name: r'labels',
      type: IsarType.longList,
    ),
    r'notifyID': PropertySchema(
      id: 7,
      name: r'notifyID',
      type: IsarType.long,
    ),
    r'notifyTime': PropertySchema(
      id: 8,
      name: r'notifyTime',
      type: IsarType.dateTime,
    ),
    r'orderID': PropertySchema(
      id: 9,
      name: r'orderID',
      type: IsarType.long,
    ),
    r'pinned': PropertySchema(
      id: 10,
      name: r'pinned',
      type: IsarType.bool,
    ),
    r'priority': PropertySchema(
      id: 11,
      name: r'priority',
      type: IsarType.string,
      enumMap: _TaskDatapriorityEnumValueMap,
    ),
    r'title': PropertySchema(
      id: 12,
      name: r'title',
      type: IsarType.string,
    ),
    r'trash': PropertySchema(
      id: 13,
      name: r'trash',
      type: IsarType.bool,
    )
  },
  estimateSize: _taskDataEstimateSize,
  serialize: _taskDataSerialize,
  deserialize: _taskDataDeserialize,
  deserializeProp: _taskDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _taskDataGetId,
  getLinks: _taskDataGetLinks,
  attach: _taskDataAttach,
  version: '3.1.0+1',
);

int _taskDataEstimateSize(
  TaskData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.labels;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.priority;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _taskDataSerialize(
  TaskData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.archive);
  writer.writeDateTime(offsets[1], object.dateCreated);
  writer.writeDateTime(offsets[2], object.dateModified);
  writer.writeString(offsets[3], object.description);
  writer.writeBool(offsets[4], object.doNotify);
  writer.writeBool(offsets[5], object.doneStatus);
  writer.writeLongList(offsets[6], object.labels);
  writer.writeLong(offsets[7], object.notifyID);
  writer.writeDateTime(offsets[8], object.notifyTime);
  writer.writeLong(offsets[9], object.orderID);
  writer.writeBool(offsets[10], object.pinned);
  writer.writeString(offsets[11], object.priority?.name);
  writer.writeString(offsets[12], object.title);
  writer.writeBool(offsets[13], object.trash);
}

TaskData _taskDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskData(
    archive: reader.readBoolOrNull(offsets[0]),
    dateCreated: reader.readDateTimeOrNull(offsets[1]),
    dateModified: reader.readDateTimeOrNull(offsets[2]),
    description: reader.readStringOrNull(offsets[3]),
    doNotify: reader.readBoolOrNull(offsets[4]),
    doneStatus: reader.readBoolOrNull(offsets[5]),
    id: id,
    labels: reader.readLongList(offsets[6]),
    notifyID: reader.readLongOrNull(offsets[7]),
    notifyTime: reader.readDateTimeOrNull(offsets[8]),
    orderID: reader.readLongOrNull(offsets[9]),
    pinned: reader.readBoolOrNull(offsets[10]),
    priority:
        _TaskDatapriorityValueEnumMap[reader.readStringOrNull(offsets[11])],
    title: reader.readStringOrNull(offsets[12]),
    trash: reader.readBoolOrNull(offsets[13]),
  );
  return object;
}

P _taskDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readLongList(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (_TaskDatapriorityValueEnumMap[reader.readStringOrNull(offset)])
          as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TaskDatapriorityEnumValueMap = {
  r'low': r'low',
  r'moderate': r'moderate',
  r'high': r'high',
};
const _TaskDatapriorityValueEnumMap = {
  r'low': Priority.low,
  r'moderate': Priority.moderate,
  r'high': Priority.high,
};

Id _taskDataGetId(TaskData object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _taskDataGetLinks(TaskData object) {
  return [];
}

void _taskDataAttach(IsarCollection<dynamic> col, Id id, TaskData object) {
  object.id = id;
}

extension TaskDataQueryWhereSort on QueryBuilder<TaskData, TaskData, QWhere> {
  QueryBuilder<TaskData, TaskData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TaskDataQueryWhere on QueryBuilder<TaskData, TaskData, QWhereClause> {
  QueryBuilder<TaskData, TaskData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskDataQueryFilter
    on QueryBuilder<TaskData, TaskData, QFilterCondition> {
  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> archiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'archive',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> archiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'archive',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> archiveEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archive',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      dateCreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateCreatedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      dateCreatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateCreatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateCreatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateModifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateModified',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      dateModifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateModified',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateModifiedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateModified',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      dateModifiedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateModified',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateModifiedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateModified',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> dateModifiedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateModified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> doNotifyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'doNotify',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> doNotifyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'doNotify',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> doNotifyEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doNotify',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> doneStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'doneStatus',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      doneStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'doneStatus',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> doneStatusEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doneStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'labels',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'labels',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'labels',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      labelsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'labels',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'labels',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'labels',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'labels',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'labels',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'labels',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'labels',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      labelsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'labels',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> labelsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'labels',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notifyID',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notifyID',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyIDEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notifyID',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyIDGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notifyID',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyIDLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notifyID',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyIDBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notifyID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notifyTime',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition>
      notifyTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notifyTime',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notifyTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notifyTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notifyTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> notifyTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notifyTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> orderIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderID',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> orderIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderID',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> orderIDEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderID',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> orderIDGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderID',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> orderIDLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderID',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> orderIDBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> pinnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> pinnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> pinnedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priority',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priority',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityEqualTo(
    Priority? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityGreaterThan(
    Priority? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityLessThan(
    Priority? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityBetween(
    Priority? lower,
    Priority? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'priority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> trashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trash',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> trashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trash',
      ));
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterFilterCondition> trashEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trash',
        value: value,
      ));
    });
  }
}

extension TaskDataQueryObject
    on QueryBuilder<TaskData, TaskData, QFilterCondition> {}

extension TaskDataQueryLinks
    on QueryBuilder<TaskData, TaskData, QFilterCondition> {}

extension TaskDataQuerySortBy on QueryBuilder<TaskData, TaskData, QSortBy> {
  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archive', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByArchiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archive', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDoNotify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doNotify', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDoNotifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doNotify', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDoneStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneStatus', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByDoneStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneStatus', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByNotifyID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyID', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByNotifyIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyID', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByNotifyTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyTime', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByNotifyTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyTime', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByOrderID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByOrderIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByTrash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trash', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> sortByTrashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trash', Sort.desc);
    });
  }
}

extension TaskDataQuerySortThenBy
    on QueryBuilder<TaskData, TaskData, QSortThenBy> {
  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archive', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByArchiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archive', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDoNotify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doNotify', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDoNotifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doNotify', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDoneStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneStatus', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByDoneStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneStatus', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByNotifyID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyID', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByNotifyIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyID', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByNotifyTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyTime', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByNotifyTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyTime', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByOrderID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByOrderIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByTrash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trash', Sort.asc);
    });
  }

  QueryBuilder<TaskData, TaskData, QAfterSortBy> thenByTrashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trash', Sort.desc);
    });
  }
}

extension TaskDataQueryWhereDistinct
    on QueryBuilder<TaskData, TaskData, QDistinct> {
  QueryBuilder<TaskData, TaskData, QDistinct> distinctByArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archive');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreated');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateModified');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByDoNotify() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doNotify');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByDoneStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doneStatus');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'labels');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByNotifyID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifyID');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByNotifyTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifyTime');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByOrderID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderID');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinned');
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByPriority(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskData, TaskData, QDistinct> distinctByTrash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trash');
    });
  }
}

extension TaskDataQueryProperty
    on QueryBuilder<TaskData, TaskData, QQueryProperty> {
  QueryBuilder<TaskData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaskData, bool?, QQueryOperations> archiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archive');
    });
  }

  QueryBuilder<TaskData, DateTime?, QQueryOperations> dateCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreated');
    });
  }

  QueryBuilder<TaskData, DateTime?, QQueryOperations> dateModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateModified');
    });
  }

  QueryBuilder<TaskData, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TaskData, bool?, QQueryOperations> doNotifyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doNotify');
    });
  }

  QueryBuilder<TaskData, bool?, QQueryOperations> doneStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doneStatus');
    });
  }

  QueryBuilder<TaskData, List<int>?, QQueryOperations> labelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'labels');
    });
  }

  QueryBuilder<TaskData, int?, QQueryOperations> notifyIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifyID');
    });
  }

  QueryBuilder<TaskData, DateTime?, QQueryOperations> notifyTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifyTime');
    });
  }

  QueryBuilder<TaskData, int?, QQueryOperations> orderIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderID');
    });
  }

  QueryBuilder<TaskData, bool?, QQueryOperations> pinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinned');
    });
  }

  QueryBuilder<TaskData, Priority?, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<TaskData, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TaskData, bool?, QQueryOperations> trashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trash');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoryListCollection on Isar {
  IsarCollection<CategoryList> get categoryLists => this.collection();
}

const CategoryListSchema = CollectionSchema(
  name: r'CategoryList',
  id: -2911301427787224850,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'orderID': PropertySchema(
      id: 1,
      name: r'orderID',
      type: IsarType.long,
    )
  },
  estimateSize: _categoryListEstimateSize,
  serialize: _categoryListSerialize,
  deserialize: _categoryListDeserialize,
  deserializeProp: _categoryListDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _categoryListGetId,
  getLinks: _categoryListGetLinks,
  attach: _categoryListAttach,
  version: '3.1.0+1',
);

int _categoryListEstimateSize(
  CategoryList object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _categoryListSerialize(
  CategoryList object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeLong(offsets[1], object.orderID);
}

CategoryList _categoryListDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CategoryList();
  object.id = id;
  object.name = reader.readStringOrNull(offsets[0]);
  object.orderID = reader.readLongOrNull(offsets[1]);
  return object;
}

P _categoryListDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categoryListGetId(CategoryList object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categoryListGetLinks(CategoryList object) {
  return [];
}

void _categoryListAttach(
    IsarCollection<dynamic> col, Id id, CategoryList object) {
  object.id = id;
}

extension CategoryListQueryWhereSort
    on QueryBuilder<CategoryList, CategoryList, QWhere> {
  QueryBuilder<CategoryList, CategoryList, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoryListQueryWhere
    on QueryBuilder<CategoryList, CategoryList, QWhereClause> {
  QueryBuilder<CategoryList, CategoryList, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CategoryListQueryFilter
    on QueryBuilder<CategoryList, CategoryList, QFilterCondition> {
  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      orderIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderID',
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      orderIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderID',
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      orderIDEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderID',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      orderIDGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderID',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      orderIDLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderID',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterFilterCondition>
      orderIDBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CategoryListQueryObject
    on QueryBuilder<CategoryList, CategoryList, QFilterCondition> {}

extension CategoryListQueryLinks
    on QueryBuilder<CategoryList, CategoryList, QFilterCondition> {}

extension CategoryListQuerySortBy
    on QueryBuilder<CategoryList, CategoryList, QSortBy> {
  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> sortByOrderID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.asc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> sortByOrderIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.desc);
    });
  }
}

extension CategoryListQuerySortThenBy
    on QueryBuilder<CategoryList, CategoryList, QSortThenBy> {
  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> thenByOrderID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.asc);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QAfterSortBy> thenByOrderIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderID', Sort.desc);
    });
  }
}

extension CategoryListQueryWhereDistinct
    on QueryBuilder<CategoryList, CategoryList, QDistinct> {
  QueryBuilder<CategoryList, CategoryList, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CategoryList, CategoryList, QDistinct> distinctByOrderID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderID');
    });
  }
}

extension CategoryListQueryProperty
    on QueryBuilder<CategoryList, CategoryList, QQueryProperty> {
  QueryBuilder<CategoryList, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CategoryList, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CategoryList, int?, QQueryOperations> orderIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderID');
    });
  }
}
