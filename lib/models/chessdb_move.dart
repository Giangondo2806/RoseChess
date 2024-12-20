class ChessdbMove {
  String score;
  String notation;
  String? san;
  String note;
  String winrate;

  ChessdbMove(this.notation, this.score, this.note, this.winrate);

  static ChessdbMove fromString(String inputString) {
    String? notation;
    String? score;
    String? note;
    String? winrate;

    List<String> parts = inputString.split(',');
    for (String part in parts) {
      List<String> keyValue = part.split(':');
      if (keyValue.length == 2) {
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();

        try {
          switch (key) {
            case 'move':
              notation = value;
              break;
            case 'score':
              score = value;
              break;
            case 'note':
              note = value;
              break;
            case 'winrate':
              winrate = value;
              break;
          }
        } catch (e) {
          print(inputString);
        }
      }
    }

    return ChessdbMove(notation!, score!, note!, winrate!);
  }
}
