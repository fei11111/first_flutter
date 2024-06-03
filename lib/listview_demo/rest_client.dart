import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

Dio dio = Dio();
Logger logger = Logger();

@RestApi(baseUrl: 'https://api.github.com/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/events')
  Future<List<Event>> getEvents();
}

@JsonSerializable()
class Event {
  const Event({this.id, this.type, this.actor, this.repo});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  final String? id;
  final String? type;
  final Actor? actor;
  final Repo? repo;

  Map<String, dynamic> toJson() => _$EventToJson(this);

  @override
  String toString() {
    return 'Event{id: $id, type: $type, actor: $actor, repo: $repo}';
  }
}

@JsonSerializable()
class Actor {
  const Actor({required this.id, this.login, this.displayLogin, this.gravatarId,this.url,this.avatarUrl});

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);

  final int id;
  final String? login;
  @JsonKey(name: "display_login")
  final String? displayLogin;
  @JsonKey(name: "gravatar_id")
  final String? gravatarId;
  final String? url;
  @JsonKey(name: "avatar_url")
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$ActorToJson(this);

  @override
  String toString() {
    return 'Actor{id: $id, login: $login, display_login: $displayLogin, gravatar_id: $gravatarId, url: $url, avatar_url: $avatarUrl}';
  }
}

@JsonSerializable()
class Repo {
  const Repo({required this.id, this.name, this.url});

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);

  final int id;
  final String? name;
  final String? url;

  Map<String, dynamic> toJson() => _$RepoToJson(this);

  @override
  String toString() {
    return 'Repo{id: $id, name: $name, url: $url}';
  }
}