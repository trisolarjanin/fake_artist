import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'strings.dart';
import 'words.dart';

void main() => runApp(const FakeArtistApp());

const ink = Color(0xFF1B2340);
const paper = Color(0xFFEEF1F5);
const muted = Color(0xFF5E6684);
const minPlayers = 3;
const maxPlayers = 10;

/// One marker colour per seat, like the coloured markers in the box.
/// All dark enough to carry white text.
const markerColors = <Color>[
  Color(0xFFD7263D), // red
  Color(0xFF1B6FD8), // blue
  Color(0xFF2B8C47), // green
  Color(0xFFD06A0A), // orange
  Color(0xFF7B3FC4), // purple
  Color(0xFF00807F), // teal
  Color(0xFFC2386F), // pink
  Color(0xFF8A5A2B), // brown
  Color(0xFF3D4A5C), // slate
  Color(0xFF7F6C00), // mustard
];

/// Hand-drawn face for the words themselves. Caveat covers Polish diacritics.
TextStyle hand(double size, {Color color = ink}) => GoogleFonts.caveat(
    fontSize: size, fontWeight: FontWeight.w700, color: color, height: 1.05);

class FakeArtistApp extends StatelessWidget {
  const FakeArtistApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(seedColor: ink, primary: ink, surface: paper),
      scaffoldBackgroundColor: paper,
    );
    return MaterialApp(
      title: 'Fake Artist',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.nunitoTextTheme(base.textTheme)
            .apply(bodyColor: ink, displayColor: ink),
      ),
      home: const GameScreen(),
    );
  }
}

class Round {
  const Round(this.category, this.word, this.fakeIndex);
  final String category;
  final String word;
  final int fakeIndex;
}

enum Phase { setup, handoff, reveal, done }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lang =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'pl'
          ? 'pl'
          : 'en';
  int players = 5;
  bool showCategory = true;
  Phase phase = Phase.setup;
  int current = 0;
  Round? round;
  bool answerShown = false;

  final _used = <String>{}; // words already played this session
  final _rng = Random();

  String t(String key) => strings[lang]![key]!;
  Color seat(int i) => markerColors[i % markerColors.length];

  static const _bigButton = TextStyle(fontSize: 18, fontWeight: FontWeight.w800);

  void _deal() {
    final bank = wordBank[lang]!;
    final all = [
      for (final e in bank.entries)
        for (final w in e.value) (category: e.key, word: w),
    ];
    var pool = all.where((x) => !_used.contains('$lang|${x.word}')).toList();
    if (pool.isEmpty) {
      // Played every word: start the deck over.
      _used.removeWhere((k) => k.startsWith('$lang|'));
      pool = all;
    }
    final pick = pool[_rng.nextInt(pool.length)];
    _used.add('$lang|${pick.word}');
    setState(() {
      round = Round(pick.category, pick.word, _rng.nextInt(players));
      current = 0;
      answerShown = false;
      phase = Phase.handoff;
    });
  }

  void _next() => setState(() {
        if (current < players - 1) {
          current++;
          phase = Phase.handoff;
        } else {
          phase = Phase.done;
        }
      });

  void _toSetup() => setState(() => phase = Phase.setup);

  @override
  Widget build(BuildContext context) {
    final screen = switch (phase) {
      Phase.setup => _setup(),
      Phase.handoff => _handoff(),
      Phase.reveal => _reveal(),
      Phase.done => _done(),
    };
    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 220),
      child: KeyedSubtree(key: ValueKey('$phase-$current'), child: screen),
    );
  }

  // ---------------------------------------------------------------- setup

  Widget _setup() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Fake Artist', style: hand(52))),
                    SegmentedButton<String>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: 'en', label: Text('EN')),
                        ButtonSegment(value: 'pl', label: Text('PL')),
                      ],
                      selected: {lang},
                      onSelectionChanged: (s) => setState(() => lang = s.first),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(t('tagline'),
                    style: const TextStyle(color: muted, fontSize: 16)),
                const SizedBox(height: 40),
                Text(t('players'),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      iconSize: 30,
                      tooltip: t('fewer'),
                      icon: const Icon(Icons.remove),
                      onPressed: players > minPlayers
                          ? () => setState(() => players--)
                          : null,
                    ),
                    SizedBox(
                      width: 120,
                      child: Text('$players',
                          textAlign: TextAlign.center, style: hand(104)),
                    ),
                    IconButton.filledTonal(
                      iconSize: 30,
                      tooltip: t('more'),
                      icon: const Icon(Icons.add),
                      onPressed: players < maxPlayers
                          ? () => setState(() => players++)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // One dot per seat, in that player's marker colour.
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    for (var i = 0; i < players; i++)
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            color: seat(i), shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 36),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: showCategory,
                  onChanged: (v) => setState(() => showCategory = v),
                  title: Text(t('showCategory')),
                  subtitle: Text(t('showCategoryHint')),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _deal,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    textStyle: _bigButton,
                  ),
                  child: Text(t('deal')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------- handoff

  Widget _handoff() {
    final c = seat(current);
    return Scaffold(
      backgroundColor: c,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: t('changeSetup'),
                  onPressed: _toSetup,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              const Spacer(),
              Text(t('passTo'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              Text('${t('player')} ${current + 1}',
                  textAlign: TextAlign.center,
                  style: hand(92, color: Colors.white)),
              const SizedBox(height: 8),
              Text(t('noPeeking'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const Spacer(),
              FilledButton(
                onPressed: () => setState(() => phase = Phase.reveal),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: c,
                  minimumSize: const Size.fromHeight(60),
                  textStyle: _bigButton,
                ),
                child: Text(t('showWord')),
              ),
              const SizedBox(height: 12),
              Text('${current + 1} / $players',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------- reveal

  Widget _reveal() {
    final r = round!;
    final isFake = current == r.fakeIndex;
    final c = seat(current);
    final last = current == players - 1;
    const label = TextStyle(color: muted, fontSize: 16);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 10, color: c),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${t('player')} ${current + 1}',
                        style: TextStyle(
                            color: c, fontWeight: FontWeight.w800, fontSize: 16)),
                    const Spacer(),
                    if (!isFake || showCategory) ...[
                      Text(t('category'), textAlign: TextAlign.center, style: label),
                      Text(r.category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 32),
                    ],
                    if (isFake) ...[
                      Text('X', textAlign: TextAlign.center, style: hand(150, color: c)),
                      Text(t('fakeTitle'), textAlign: TextAlign.center, style: hand(48)),
                      const SizedBox(height: 12),
                      Text(showCategory ? t('fakeWithCategory') : t('fakeNoCategory'),
                          textAlign: TextAlign.center, style: label),
                    ] else ...[
                      Text(t('yourWord'), textAlign: TextAlign.center, style: label),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(r.word, style: hand(100)),
                      ),
                    ],
                    const Spacer(),
                    FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        textStyle: _bigButton,
                      ),
                      child: Text(last ? t('hideLast') : t('hidePass')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- done

  Widget _done() {
    final r = round!;
    const label = TextStyle(color: muted, fontSize: 15);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              children: [
                Text(t('doneTitle'), style: hand(52)),
                const SizedBox(height: 12),
                Text(t('doneBody'),
                    style: const TextStyle(fontSize: 17, height: 1.45, color: muted)),
                const SizedBox(height: 32),
                if (answerShown)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ink, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('answerWord'), style: label),
                        Text(r.word, style: hand(46)),
                        Text(r.category, style: label),
                        const SizedBox(height: 20),
                        Text(t('answerFake'), style: label),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                  color: seat(r.fakeIndex), shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 10),
                            Text('${t('player')} ${r.fakeIndex + 1}',
                                style: hand(40)),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: () => setState(() => answerShown = true),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      side: const BorderSide(color: ink, width: 2),
                      textStyle: _bigButton,
                    ),
                    child: Text(t('revealAnswer')),
                  ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: _deal,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    textStyle: _bigButton,
                  ),
                  child: Text(t('newRound')),
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: _toSetup, child: Text(t('changeSetup'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
