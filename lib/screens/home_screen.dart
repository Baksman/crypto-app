import 'package:crypto_app/blocs/crypto/crypto_bloc.dart';
import 'package:crypto_app/model/coin_model.dart';
//import 'package:crypto_app/repository/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top coins"),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (ctx, state) {
          return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Theme.of(context).primaryColor,
                    Colors.grey[900]
                  ])),
              child: _buildBody(state));
        },
      ),
    );
  }

  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CryptoLoaded) {
      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          context.bloc<CryptoBloc>().add(RefreshCoins());
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, state),
          child: ListView.builder(
            controller: _scrollController,
              itemCount: state.coins.length,
              itemBuilder: (context, index) {
                Coin coin = state.coins[index];
                return ListTile(
                  title: Text(
                    coin.fullName,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    "\$${coin.price.toStringAsFixed(4)}",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    coin.name,
                    style: TextStyle(color: Colors.white70),
                  ),
                  leading: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${++index}",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
        ),
      );
    } else if (state is CryptoError) {
      return Center(
        child: Text(
          "Error loading coind!\n please check your connection",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
        ),
      );
    }
  }

  bool _onScrollNotification(ScrollNotification notif, CryptoLoaded state) {
    if (notif is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      context.bloc<CryptoBloc>().add(LoadMoreCoins(coins: state.coins));
      //return true;
    }
    return false;
  }

  // FutureBuilder(
  //     future: cryptoRespository.getTopCoins(_page),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
  //           ),
  //         );///
  //       }
  //       final List<Coin> coins = snapshot.data;
  //       return
  //     },
  //   );
}
