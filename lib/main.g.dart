// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewModel _$ViewModelFromJson(Map<String, dynamic> json) => ViewModel(
      ipAddress: json['ipAddress'] as String,
      pumpStatus: $enumDecode(_$PumpStatusEnumMap, json['pumpStatus']),
      currentIrrigationArea:
          $enumDecode(_$IrrigationAreaEnumMap, json['currentIrrigationArea']),
      pumpingEndTime:
          Timestamp.fromJson(json['pumpingEndTime'] as Map<String, dynamic>),
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => EnrichedSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextSchedule: json['nextSchedule'] as String,
    );

Map<String, dynamic> _$ViewModelToJson(ViewModel instance) => <String, dynamic>{
      'ipAddress': instance.ipAddress,
      'pumpStatus': _$PumpStatusEnumMap[instance.pumpStatus]!,
      'currentIrrigationArea':
          _$IrrigationAreaEnumMap[instance.currentIrrigationArea]!,
      'pumpingEndTime': instance.pumpingEndTime.toJson(),
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'nextSchedule': instance.nextSchedule,
    };

const _$PumpStatusEnumMap = {
  PumpStatus.OPEN: 'OPEN',
  PumpStatus.CLOSE: 'CLOSE',
};

const _$IrrigationAreaEnumMap = {
  IrrigationArea.MOESTUIN: 'MOESTUIN',
  IrrigationArea.GAZON: 'GAZON',
};

Timestamp _$TimestampFromJson(Map<String, dynamic> json) => Timestamp(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
      second: (json['second'] as num).toInt(),
    );

Map<String, dynamic> _$TimestampToJson(Timestamp instance) => <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
    };

EnrichedSchedule _$EnrichedScheduleFromJson(Map<String, dynamic> json) =>
    EnrichedSchedule(
      schedule: Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      nextRun: json['nextRun'] == null
          ? null
          : Timestamp.fromJson(json['nextRun'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EnrichedScheduleToJson(EnrichedSchedule instance) =>
    <String, dynamic>{
      'schedule': instance.schedule.toJson(),
      'nextRun': instance.nextRun?.toJson(),
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: json['id'] as String,
      startSchedule:
          Timestamp.fromJson(json['startSchedule'] as Map<String, dynamic>),
      endSchedule: json['endSchedule'] == null
          ? null
          : Timestamp.fromJson(json['endSchedule'] as Map<String, dynamic>),
      duration: (json['duration'] as num).toInt(),
      daysInterval: (json['daysInterval'] as num).toInt(),
      erea: $enumDecode(_$IrrigationAreaEnumMap, json['erea']),
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'startSchedule': instance.startSchedule.toJson(),
      'endSchedule': instance.endSchedule?.toJson(),
      'duration': instance.duration,
      'daysInterval': instance.daysInterval,
      'erea': _$IrrigationAreaEnumMap[instance.erea]!,
      'enabled': instance.enabled,
    };
