import 'package:cashify/data_models/exchange_model.dart';
import 'package:cashify/utils/constants.dart';
import 'package:get/get.dart';

class MoneyExchange extends GetConnect {
  Future<CurrenctExchangeModel> changeCurrency(
      {required String base,
      required String exchange,
      required double amount}) async {
    bool minus = amount < 0;
    double newAmount = minus ? amount * -1 : amount;
    CurrenctExchangeModel model = CurrenctExchangeModel(
      errorMessage: '',
      status: '',
      result: '',
    );

    try {
      await get(
              'https://v6.exchangerate-api.com/v6/$moneyApiKey/pair/$base/$exchange/$newAmount')
          .then(
        (value) {
          if (value.statusCode == 200) {
            model = CurrenctExchangeModel.fromMap(value.body);
            if (minus) {
              model.result = (double.parse(model.result) * -1).toString();
            }
          } else {
            model = CurrenctExchangeModel(
              errorMessage: 'code not 200',
              status: 'error',
              result: '',
            );
          }
        },
      );
    } catch (e) {
      model = CurrenctExchangeModel(
        errorMessage: e.toString(),
        status: 'error',
        result: '',
      );
    }
    return model;
  }
}
