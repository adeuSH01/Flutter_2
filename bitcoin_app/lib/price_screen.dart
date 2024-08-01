import 'package:bitcoin_app/coin_data.dart';
import 'package:flutter/material.dart';

//import 'dart:io' show Platform; // show = only whatever I choose. hide = only whatever I do not want to use. as = rename the package.
import 'package:flutter/cupertino.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems =
        []; // bu listeye yeni dropdownitems diye boş bir liste ekledik, ekran açıldığında bu görükecek.

    for (String currency in currenciesList) {
      // bu listenin içine coin sayfamızdaki liste ile bir loop oluşturduk.
      var newItem = DropdownMenuItem(
        // loop içine bir property koyduk. yeni item olarak ekleme yapacak her tıklandığında.
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
        // alt alta liste gibi çıkıyor ve istediğini seçiyorsun. bu o buton.
        value: selectedCurrency, // ekranda ilk gözükecek şeyi verir bize.
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            getData();
          });
        }); // onchange = selects a new item into that dropdownbutton. trigger a callback. items = go into that drop down menu
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems =
        []; // not to turn a null, need to put an empty array.
    for (String currency in currenciesList) {
      Text(currency);
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0, // the height of each of the items inside the picker.
      onSelectedItemChanged: (selectedIndex) {
        // what should happen when the user scrools throug that wheel and changes the selection.
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto]!, 
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget getPicker() {
  //  if (Platform.isIOS) {
    //  return iOSPicker();
  //  } else if (Platform.isAndroid) {
    //  return androidDropdown();
  //  }
    //return getPicker();
  //}

  // child: Platform.isIOS ? iOSPicker() : androidDropdown(), = if the platform is ios then use iospicker, if it is not then use androiddropdown.