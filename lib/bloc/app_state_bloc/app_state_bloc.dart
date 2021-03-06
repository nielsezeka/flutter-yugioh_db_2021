import 'package:flutter_yugioh_2021/presentationals/presentional_index.dart';
import 'package:flutter_yugioh_2021/services/yugioh_db_service/response_model/all_card_response_model.dart';
import 'package:rxdart/subjects.dart';

class AppStateBloc {
  final BehaviorSubject<CardData> _currentCard = BehaviorSubject<CardData>();
  final BehaviorSubject<ListVerticalCardSetModel> _currentCardSet =
      BehaviorSubject<ListVerticalCardSetModel>();
  acceptCard(CardData newData) {
    _currentCard.add(newData);
  }

  acceptCardSet(ListVerticalCardSetModel newData) {
    _currentCardSet.add(newData);
  }

  Stream<CardData> cardToShow() {
    return _currentCard.stream;
  }

  CardData focusedCard() {
    return _currentCard.value;
  }

  ListVerticalCardSetModel focusedCardSet() {
    return _currentCardSet.value;
  }
}
