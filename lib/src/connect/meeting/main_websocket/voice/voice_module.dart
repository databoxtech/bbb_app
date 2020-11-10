import 'package:bbb_app/src/connect/meeting/main_websocket/module.dart';
import 'package:bbb_app/src/connect/meeting/meeting_info.dart';
import 'package:bbb_app/src/connect/meeting/voice/voice_connection.dart';

/// This Module handles Voice Stream Initialisation and sends the EchoTest end message
class VoiceModule extends Module {
  MeetingInfo _info;
  VoiceConnection _connection;

  VoiceModule(messageSender, this._info) : super(messageSender) {
    _connection = new VoiceConnection(_info, this);
  }

  /// As far as I can tell, this message signals that we are satisfied with the echo test
  /// {
  /// "msg":"method","method":"logClient","params":["info","Audio Joined","audio_joined",
  /// {"clientURL":"https://bbb9.cs.hm.edu/html5client/join?sessionToken=f8dvpv0dyx7yn8mc"},
  /// {"sessionToken":"f8dvpv0dyx7yn8mc","meetingId":"027c9467b50f9b06ee4ea492a08fa14becaceb18-1605033005419",
  ///  "requesterUserId":"w_bg8ww0dpizn1",
  ///  "fullname":"Schlosser, Konstantin",
  ///  "confname":"Startraum",
  ///  "externUserID":"gl-kzsuivppxpyf",
  ///  "uniqueClientSession":"f8dvpv0dyx7yn8mc-872sc"}],
  ///  "id":"65"
  ///  }"
  void endEchoTest() {
    sendMessage({
      "msg": "method",
      "method": "logClient",
      "params": [
        "info",
        "Audio Joined",
        "audio_joined",
        {"clientURL": _info.joinUrl},
        {
          "sessionToken": _info.sessionToken,
          "meetingId": _info.meetingID,
          "requesterUserId": _info.internalUserID,
          "fullname": _info.fullUserName,
          "confname": _info.conferenceName,
          "externUserID": _info.externUserID,
          // I have no idea on how they generate this, but... I guess that will have to do for now
          "uniqueClientSession":
              "${_info.sessionToken}-${_connection.audioSessionNumber}"
        }
      ]
    });
  }

  @override
  void onConnected() {
    _connection.connect();
  }

  @override
  Future<void> onDisconnect() {
    _connection.disconnect();
  }

  @override
  void processMessage(Map<String, dynamic> msg) {}
}
