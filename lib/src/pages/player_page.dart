import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final Color bgColor = Color.fromRGBO(17, 17, 17, 1);
  final Color iconColor = Colors.teal;
  final Color iconColorFocus = Colors.teal[800];
  final Color iconColorDisabled = Colors.grey[800];
  final Color textColor = Colors.grey;

  bool _isPlaying = false;
  bool _isShuffle = false;
  int _isRepeat = 0;

  final Map song = {
    'title': 'SONG TITLE',
    'artist': 'ARTIST',
    'album': 'SONG ALBUM',
    'duration': '00:03.11',
    'img-cover': 'assets/album.png',
  };

  Duration _songDurationTime;
  Duration _songCurrentTime = new Duration(seconds: 0); // seconds for tests
  String _songDurationText = '';
  String _songCurrentText = '';

  void _song(Map s) {
    final songTemp = s['duration'].toString().split(':');

    if (songTemp.length >= 5 || songTemp.length < 1) {
      _songDurationTime = new Duration(
        seconds: 1,
      );
      print('Error: time exceeded');
    } else if (songTemp.length == 4) {
      // ------  Days - Hours - Minutes - Seconds -----
      _songDurationTime = new Duration(
        days: (int.tryParse(songTemp[0]) is int) ? int.parse(songTemp[0]) : 0,
        hours: (int.tryParse(songTemp[1]) is int) ? int.parse(songTemp[1]) : 0,
        minutes:
            (int.tryParse(songTemp[2]) is int) ? int.parse(songTemp[2]) : 0,
        seconds:
            (int.tryParse(songTemp[3]) is int) ? int.parse(songTemp[3]) : 0,
      );
    } else if (songTemp.length == 3) {
      // ------  Hours - Minutes - Seconds -----
      _songDurationTime = new Duration(
        hours: (int.tryParse(songTemp[0]) is int) ? int.parse(songTemp[0]) : 0,
        minutes:
            (int.tryParse(songTemp[1]) is int) ? int.parse(songTemp[1]) : 0,
        seconds:
            (int.tryParse(songTemp[2]) is int) ? int.parse(songTemp[2]) : 0,
      );
    } else if (songTemp.length == 2) {
      // ------  Minutes - Seconds -----
      _songDurationTime = new Duration(
        minutes:
            (int.tryParse(songTemp[0]) is int) ? int.parse(songTemp[0]) : 0,
        seconds:
            (int.tryParse(songTemp[1]) is int) ? int.parse(songTemp[1]) : 0,
      );
    } else if (songTemp.length == 1) {
      // ------  Seconds -----
      _songDurationTime = new Duration(
        seconds:
            (int.tryParse(songTemp[0]) is int) ? int.parse(songTemp[0]) : 0,
      );
    }

    _songDurationText =
        '${_songDurationTime.inHours >= 1 ? (_songDurationTime.inHours.toString() + ':') : ''}' + // if more 1 hour
            '${_songDurationTime.inMinutes.remainder(60) < 10 ? ('0') : ''}' +
            '${_songDurationTime.inMinutes.remainder(60)}' +
            ':' +
            '${_songDurationTime.inSeconds.remainder(60) < 10 ? '0' : ''}' +
            '${_songDurationTime.inSeconds.remainder(60)}';

    _songCurrentText =
        '${_songCurrentTime.inHours >= 1 ? (_songCurrentTime.inHours.toString() + ':') : ''}' + // if more 1 hour
            '${_songCurrentTime.inMinutes.remainder(60) < 10 ? ('0') : ''}' +
            '${_songCurrentTime.inMinutes.remainder(60)}' +
            ':' +
            '${_songCurrentTime.inSeconds.remainder(60) < 10 ? '0' : ''}' +
            '${_songCurrentTime.inSeconds.remainder(60)}';
  }

  @override
  Widget build(BuildContext context) {
    _song(song);
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomBar(),
      backgroundColor: bgColor,
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Column(
          children: <Widget>[
            Text(
              song['artist'],
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Text(
              song['title'],
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(200)),
                child: FadeInImage(
                  fit: BoxFit.fill,
                  width: 350,
                  height: 350,
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: AssetImage(song['img-cover']),
                ),
              ),
            ),
            SleekCircularSlider(
              min: 0,
              max: _songDurationTime.inSeconds >= 1
                  ? _songDurationTime.inSeconds.roundToDouble()
                  : 60.0,
              initialValue:
                  _songCurrentTime.inSeconds <= _songDurationTime.inSeconds
                      ? _songCurrentTime.inSeconds.roundToDouble()
                      : 0,
              appearance: CircularSliderAppearance(
                size: 400,
                counterClockwise: true,
                startAngle: 150,
                angleRange: 120,
                customWidths: CustomSliderWidths(
                  trackWidth: 8,
                  progressBarWidth: 15,
                  shadowWidth: 0,
                ),
                customColors: CustomSliderColors(
                  trackColor: textColor,
                  progressBarColor: iconColor,
                ),
                infoProperties: InfoProperties(
                  mainLabelStyle: TextStyle(
                    color: Colors.transparent,
                  ),
                ),
              ),
              onChange: (double value) {
                // callback providing a value while its being changed (with a pan gesture)
                setState(() {
                  _songCurrentTime = Duration(seconds: value.toInt());
                });
              },
              onChangeStart: (double startValue) {
                // callback providing a starting value (when a pan gesture starts)
                setState(() {
                  _songCurrentTime = Duration(seconds: startValue.toInt());
                });
              },
              onChangeEnd: (double endValue) {
                // callback providing an ending value (when a pan gesture ends)
                setState(() {
                  _songCurrentTime = Duration(seconds: endValue.toInt());
                });
              },
              // innerWidget: (double value) {
              //   // use your custom widget inside the slider (gets a slider value from the callback)
              // },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                // Current Time
                _songCurrentText,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                // Duration Time
                _songDurationText,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(
        'Music Player',
        style: GoogleFonts.poppins(
          color: iconColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Icon(
        Icons.chevron_left,
        color: iconColor,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.toc,
            color: iconColor,
          ),
          onPressed: null,
        ),
      ],
    );
  }

  Widget _bottomBar() {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Icon(
                Icons.shuffle,
                color: _isShuffle ? iconColor : iconColorDisabled,
                size: 25,
              ),
              onTap: () {
                setState(() {
                  _isShuffle = !_isShuffle;
                });
              },
              splashColor: bgColor,
              highlightColor: bgColor,
            ),
            InkWell(
              child: Icon(
                Icons.fast_rewind,
                color: iconColor,
                size: 35,
              ),
              onTap: () {},
              splashColor: bgColor,
              highlightColor: bgColor,
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgColor,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor,
                      offset: Offset(0, 0),
                      blurRadius: 10,
                    ),
                  ]),
              child: InkWell(
                child: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: iconColor,
                  size: 80,
                ),
                onTap: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                splashColor: bgColor,
                highlightColor: bgColor,
              ),
            ),
            InkWell(
              child: Icon(
                Icons.fast_forward,
                color: iconColor,
                size: 35,
              ),
              onTap: () {},
              splashColor: bgColor,
              highlightColor: bgColor,
            ),
            InkWell(
              child: Icon(
                _isRepeat > 1 ? Icons.repeat_one : Icons.repeat,
                color: _isRepeat != 0 ? iconColor : iconColorDisabled,
                size: 25,
              ),
              onTap: () {
                setState(() {
                  if (_isRepeat == 0) {
                    _isRepeat = 1;
                  } else if (_isRepeat == 1) {
                    _isRepeat = 2;
                  } else if (_isRepeat == 2) {
                    _isRepeat = 0;
                  }
                });
              },
              splashColor: bgColor,
              highlightColor: bgColor,
            ),
          ],
        ),
      ),
    );
  }
}
