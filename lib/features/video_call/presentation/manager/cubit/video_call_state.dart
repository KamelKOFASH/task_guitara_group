part of 'video_call_cubit.dart';

abstract class VideoCallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoCallInitial extends VideoCallState {}

class VideoCallLoading extends VideoCallState {}

class VideoCallJoined extends VideoCallState {
  final Call call;
  final String userId;

  VideoCallJoined({required this.call, required this.userId});

  @override
  List<Object?> get props => [call, userId];
}

class VideoCallError extends VideoCallState {
  final String message;

  VideoCallError({required this.message});

  @override
  List<Object?> get props => [message];
}

class VideoCallLeft extends VideoCallState {}