import 'package:flutter_yugioh_2021/bloc/bloc_index.dart';
import 'package:flutter_yugioh_2021/services/service_index.dart';
import 'package:flutter_yugioh_2021/services/yugioh_db_service/response_model/all_card_response_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../presentional_index.dart';

class MainScreenBloc {
  final databaseService = ServiceFacade.getService<YugiohService>();
  BehaviorSubject<String> nameFilterString = BehaviorSubject<String>.seeded('');

  acceptFilterName(String nameToFilter) {
    nameFilterString.add(nameToFilter);
  }

  Stream<List<CardInfoOnVerticalListModel>> observeAllcardsChange() {
    return Rx.combineLatest2(
        databaseService.observerAllCardInformation(), nameFilterString.stream,
        (AllCardResponseModel a, String b) {
      if (b.isEmpty) {
        return a.data
                ?.map(
                  (cardFromServer) => CardInfoOnVerticalListModel(
                      cardImage:
                          cardFromServer.cardImages?.first.imageUrl ?? '',
                      cardIndentifier: cardFromServer.id.toString(),
                      cardName: cardFromServer.name ?? '',
                      cardText: ' '),
                )
                .toList() ??
            [];
      }
      return a.data
              ?.where(
                  (element) => element.name?.toLowerCase().contains(b) ?? false)
              .map(
                (cardFromServer) => CardInfoOnVerticalListModel(
                    cardImage: cardFromServer.cardImages?.first.imageUrl ?? '',
                    cardIndentifier: cardFromServer.id.toString(),
                    cardName: cardFromServer.name ?? '',
                    cardText: ' '),
              )
              .toList() ??
          [];
    });
  }

  onFocusCardData(String originalID) {
    databaseService
        .observerAllCardInformation()
        .switchMap(
          (value) => Stream.value(
            value.data?.firstWhere(
              (element) => element.id.toString() == originalID,
            ),
          ),
        )
        .listen((cardToObserve) {
      if (cardToObserve != null) {
        GlobalBloc.appStateBloc.acceptCard(cardToObserve);
      }
    });
  }
}
