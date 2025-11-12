import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const WordScrambleApp());
}

// --- COLOR EXTENSION FOR DYNAMIC THEMEING ---
// Extension to help calculate darker colors for contrast
extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final double newLightness = max(0.0, hsl.lightness - amount);
    return hsl.withLightness(newLightness).toColor();
  }
}

// --- GLOBAL THEME SETUP ---
// Define a strong light theme with a light blue background and white cards
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // Primary color: Blue
    brightness: Brightness.light,
    background: Colors.blue.shade50, // Lightest blue for main background
    surface: Colors.white, // White surface for cards/containers
    error: Colors.red.shade700,
  ),
  useMaterial3: true,
  cardColor: Colors.white, // Explicit card color for light mode
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue.shade600, // Deep blue for AppBar
    foregroundColor: Colors.white, // White text/icons
  ),
);

// Define a dark theme with a deep grey background and surface
final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
    background: Colors.grey.shade900, // Dark background
    surface: Colors.grey.shade800, // Slightly lighter surface for cards/containers
    error: Colors.red.shade400,
  ),
  useMaterial3: true,
  cardColor: Colors.grey.shade800, // Explicit card color for dark mode
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue.shade900, // Dark blue for AppBar
    foregroundColor: Colors.white,
  ),
);

// --- APP WIDGET ---
class WordScrambleApp extends StatefulWidget {
  const WordScrambleApp({super.key});

  @override
  State<WordScrambleApp> createState() => _WordScrambleAppState();
}

class _WordScrambleAppState extends State<WordScrambleApp> {
  // Static key to allow descendant widgets to change the theme
  static _WordScrambleAppState? of(BuildContext context) => context.findAncestorStateOfType<_WordScrambleAppState>();

  bool _isDark = false;

  void toggleTheme(bool value) {
    setState(() {
      _isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Word Scramble',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: const WordScrambleHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum Difficulty { easy, medium, hard }

// --- HOME WIDGET ---
class WordScrambleHome extends StatefulWidget {
  const WordScrambleHome({super.key});

  @override
  State<WordScrambleHome> createState() => _WordScrambleHomeState();
}

// --- STATE WIDGET (Main Logic and UI) ---
class _WordScrambleHomeState extends State<WordScrambleHome>
    with SingleTickerProviderStateMixin {
  // --- Static word pool and dictionary ---
  final List<String> _defaultWords = [
    // --- Easy Words (5 Characters or Less) ---
    'dart', 'view', 'tree', 'path', 'root', 'key', 'app', 'box', 'run', 'type',
  'void', 'init', 'pool', 'test', 'size', 'data', 'prop', 'bloc', 'getx', 'row',
  'font', 'icon', 'code', 'flex', 'main', 'tool', 'edit', 'form', 'tabs', 'list',
  'drag', 'drop', 'show', 'hide', 'save', 'load', 'open', 'move', 'push', 'pop',
  'clip', 'menu', 'grid', 'edge', 'axis', 'info', 'args', 'snap', 'drag', 'path',
  'mock', 'test', 'find', 'clip', 'node', 'area', 'rate', 'note', 'text', 'wrap',
  'pane', 'clip', 'hint', 'copy', 'sort', 'file', 'sync', 'bool', 'icon', 'axis',
  'clip', 'anim', 'task', 'node', 'axis', 'type', 'null', 'snap', 'push', 'time',
  'loop', 'item', 'fill', 'tile', 'send', 'call', 'back', 'page', 'view', 'save',
  'mock', 'grow', 'fade', 'exit', 'json', 'help', 'mode', 'unit', 'tree', 'next',

    // --- Medium Words (6 to 8 Characters) ---
    'widget', 'column', 'future', 'screen', 'layout', 'state', 'theme', 'class', 'async', 'import',
  'image', 'value', 'debug', 'scroll', 'group', 'aspect', 'center', 'driver', 'button', 'border',
  'index', 'handle', 'string', 'render', 'double', 'return', 'extend', 'assert', 'setter', 'getter',
  'mixin', 'parent', 'buffer', 'method', 'bundle', 'action', 'define', 'repeat', 'provider', 'builder',
  'scoped', 'drawer', 'margin', 'canvas', 'global', 'device', 'anchor', 'spacer', 'toggle', 'repeat',
  'context', 'visible', 'gesture', 'outline', 'overlay', 'toolbar', 'padding', 'binding', 'runtime', 'channel',
  'pointer', 'tooltip', 'desktop', 'router', 'overlay', 'animate', 'opacity', 'capture', 'restart', 'dispose',
  'inherit', 'dynamic', 'session', 'project', 'network', 'upgrade', 'publish', 'element', 'console', 'package',
  'message', 'cleanup', 'trigger', 'storage', 'offline', 'binding', 'gesture', 'pattern', 'license', 'profile',
  'version', 'runtime', 'decoder', 'encoder', 'mutable', 'builder', 'testing', 'toolbar', 'overlay', 'padding'


    // --- Hard Words (9 Characters or More) ---
     'scaffold', 'navigator', 'container', 'animation', 'cupertino', 'hotreload', 'material', 'repository',
  'inherited', 'lifecycle', 'multiline', 'background', 'alignment', 'constructor', 'orientation', 'observable',
  'expression', 'annotation', 'resolution', 'stateless', 'execution', 'framework', 'interface', 'directional',
  'separated', 'dependency', 'asynchronous', 'configuration', 'scrollcontroller', 'streambuilder', 'statefulwidget',
  'statelesswidget', 'listviewbuilder', 'customscrollview', 'repaintboundary', 'gestureDetector', 'multiprovider',
  'textformfield', 'appbarwidget', 'crossaxisalignment', 'mainaxisalignment', 'notificationlistener', 'singlechildscrollview','stackalignment','lifecycleobserver','animationcontroller','materialbanner','scrollnotification', 'floatingactionbutton','cliprect', 'scrollphysics', 'defaulttabcontroller', 'navigatorobserver', 'flexiblewidget', 'richtextwidget', 'autofocusnode','scrollbehavior', 'pageviewcontroller', 'inputdecoration', 'shadercallback', 'transitionbuilder', 'animatedcontainer','keyeventdispatcher', 'primaryscrollcontroller', 'autofillgroup', 'colorfiltermatrix', 'renderingpipeline','scrollposition', 'interactiveviewer', 'frameworkbinding', 'listviewseparated', 'notificationlistener', 'alignmentgeometry','animationstatuslistener', 'scrollbehavioroverride', 'themeextension', 'debugprintcallback', 'inputformatter','focusmanager', 'colortransition', 'overlayentry', 'clipoval', 'materiallocalizations', 'scrollcontrollerlistener','textselectioncontrols', 'cupertinopicker', 'gesturearena', 'focusnodeobserver', 'texteditingcontroller','navigatorstate', 'constraints', 'formvalidation', 'safeareawidget', 'transitionanimation', 'overlayanimation'
    
  ];

  final Map<String, String> _dictionary = {
    // Add some definitions for the new words if desired
    'scaffold': 'Implements the basic visual layout structure for material design.',
    'navigator': 'Used for managing routes and navigation stack.',
    'widget': 'A basic building block of Flutter UI.',
    'state': 'Information that can change over time in an app.',
    'async': 'Asynchronous programming that allows non-blocking operations.',
  };

  // --- Game config/state ---
  List<String> _wordPool = [];
  Difficulty _difficulty = Difficulty.easy;
  final TextEditingController _guessController = TextEditingController();
  final TextEditingController _addWordController = TextEditingController();
  final TextEditingController _addDefinitionController = TextEditingController();

  String _originalWord = '';
  String _scrambledWord = '';
  int _score = 0;
  int _bestScoreSession = 0;
  int _rounds = 10; // words per game
  int _currentRound = 0;
  bool _showCorrect = false;
  bool _showIncorrect = false;

  // Timer
  Timer? _timer;
  int _timePerRound = 30;
  int _timeLeft = 30;

  // Hint usage
  bool _hintUsedThisRound = false;
  int _hintPenalty = 1;

  // Animations
  late AnimationController _shakeController;

  // Randomness
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _wordPool = List.from(_defaultWords);
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shuffleAndPickNew(resetRound: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _guessController.dispose();
    _addWordController.dispose();
    _addDefinitionController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  // --- Utility: pick a new word and scramble ---
  void _shuffleAndPickNew({bool resetRound = false}) {
    // Filter by difficulty (logic remains based on word length)
    List<String> filtered = _wordPool.where((w) {
      final l = w.length;
      if (_difficulty == Difficulty.easy) return l <= 5;
      if (_difficulty == Difficulty.medium) return l >= 6 && l <= 8;
      return l >= 9;
    }).toList();

    // If filtered empty, fallback to full pool
    if (filtered.isEmpty) filtered = List.from(_wordPool);

    // pick random
    _originalWord = filtered[_rand.nextInt(filtered.length)];
    _scrambledWord = _scrambleWord(_originalWord);
    
    // ensure it's different from original (in worst case, try a few times)
    int attempts = 0;
    while (_scrambledWord == _originalWord && attempts < 10) {
      _scrambledWord = _scrambleWord(_originalWord);
      attempts++;
    }

    _guessController.clear();
    _hintUsedThisRound = false;
    _showCorrect = false;
    _showIncorrect = false;

    if (resetRound) {
      _currentRound = 0;
      _score = 0;
      _bestScoreSession = max(_bestScoreSession, _score); 
    }

    _startTimer();
    setState(() {});
  }

  String _scrambleWord(String w) {
    final chars = w.split('');
    chars.shuffle(_rand);
    return chars.join();
  }

  // --- Timer management ---
  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _timePerRound;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 0) {
        t.cancel();
        _onTimeUp();
      } else {
        setState(() => _timeLeft -= 1);
      }
    });
  }

  void _onTimeUp() {
    _timer?.cancel();
    setState(() {
      _showIncorrect = true;
      _currentRound += 1;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      _proceedToNext(automatic: true);
    });
  }

  // --- Guess checking & Game flow ---
  void _checkGuess() {
    final guess = _guessController.text.trim().toLowerCase();
    if (guess.isEmpty) return;

    if (guess == _originalWord.toLowerCase()) {
      _timer?.cancel();
      setState(() {
        // SCORING: Award exactly 1 point
        _score += 1; 
        
        _showCorrect = true;
        _showIncorrect = false;
        _currentRound += 1;
        _bestScoreSession = max(_bestScoreSession, _score);
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        _proceedToNext();
      });
    } else {
      setState(() {
        _showIncorrect = true;
        _showCorrect = false;
      });
      _shakeController.forward(from: 0.0).then((_) {
        setState(() => _showIncorrect = false);
      });
    }
  }

  void _proceedToNext({bool automatic = false}) {
    _timer?.cancel();
    if (_currentRound >= _rounds) {
      _endGame();
      return;
    }
    _shuffleAndPickNew();
  }

  void _skipWord() {
    _timer?.cancel();
    setState(() {
      _currentRound += 1;
    });
    _proceedToNext();
  }

  void _useHint() {
    if (_hintUsedThisRound) return;
    setState(() {
      _hintUsedThisRound = true;
      _score = max(0, _score - _hintPenalty);
      _bestScoreSession = max(_bestScoreSession, _score);
    });
  }

  void _endGame() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Game Over! 🥳'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Final Score: $_score / $_rounds', style: Theme.of(ctx).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Best Score this session: $_bestScoreSession'),
              const SizedBox(height: 15),
              if (_dictionary.containsKey(_originalWord))
                Text.rich(
                  TextSpan(
                    text: 'Last word: ${_originalWord.toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\nDefinition: ${_dictionary[_originalWord]}', style: const TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _shuffleAndPickNew(resetRound: true);
              },
              child: const Text('Play again'),
            ),
          ],
        );
      },
    );
  }

  // Add user word
  void _showAddWordDialog() {
    _addWordController.clear();
    _addDefinitionController.clear();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Custom Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _addWordController,
                decoration: const InputDecoration(hintText: 'Enter a word (letters only)'),
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addDefinitionController,
                decoration: const InputDecoration(hintText: 'Definition (optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final word = _addWordController.text.trim();
                final definition = _addDefinitionController.text.trim();
                if (word.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(word)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a single word with letters only.')),
                  );
                  return;
                }
                setState(() {
                  final lowerWord = word.toLowerCase();
                  _wordPool.add(lowerWord);
                  if (definition.isNotEmpty) {
                    _dictionary[lowerWord] = definition;
                  }
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "$word" to the pool!'))
                );
              },
              child: const Text('Add'),
            ),
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ],
        );
      },
    );
  }

  // UI: small animated widget to indicate correct/incorrect
  Widget _feedbackBanner() {
    if (_showCorrect) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: Colors.green.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
        child: const Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            // Fixed +1 score display
            Text('Correct! (+1)', style: TextStyle(color: Colors.white)),
          ]
        ),
      );
    } else if (_showIncorrect) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
        child: const Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(Icons.close, color: Colors.white),
            SizedBox(width: 8),
            Text('Wrong/Time Up!', style: TextStyle(color: Colors.white)),
          ]
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // --- Build UI ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Set the main background color
      appBar: AppBar(
        title: const Text('Dynamic Word Scramble'),
        actions: [
          IconButton(
            tooltip: 'Add custom word',
            onPressed: _showAddWordDialog,
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () {
              _WordScrambleAppState.of(context)?.toggleTheme(!isDark);
            },
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: 1.0 - (_timeLeft / _timePerRound),
            backgroundColor: theme.colorScheme.surfaceVariant,
            color: _timeLeft < 10 ? theme.colorScheme.error : theme.colorScheme.primary, // Red for low time
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Score & Round Progress (Card/Box) ---
                  Card(
                    elevation: 4,
                    color: theme.colorScheme.surface, // Use surface color for card background
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _animatedInfoChip('Score', '$_score', theme, Colors.green),
                          _animatedInfoChip('Best', '$_bestScoreSession', theme, Colors.orange),
                          _animatedInfoChip('Round', '${min(_currentRound + 1, _rounds)}/$_rounds', theme, theme.colorScheme.primary),
                          _animatedInfoChip('Time', '$_timeLeft s', theme, Colors.red, isTimer: true),
                        ],
                      ),
                    ),
                  ),

                  // --- Difficulty selection (Chips) ---
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _difficultyButton(Difficulty.easy, 'Easy (<= 5)', theme),
                      _difficultyButton(Difficulty.medium, 'Medium (6-8)', theme),
                      _difficultyButton(Difficulty.hard, 'Hard (9+)', theme),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // --- Scrambled word area (Card/Box) ---
                  Card(
                    elevation: 8,
                    // Different color for the main puzzle area
                    color: theme.colorScheme.surfaceVariant.withOpacity(isDark ? 0.4 : 0.7), 
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            'Scrambled Word',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Shake animation on wrong
                          AnimatedBuilder(
                            animation: _shakeController,
                            builder: (context, child) {
                              double shake = sin(_shakeController.value * pi * 8) * (_showIncorrect ? 10.0 : 0.0);
                              return Transform.translate(
                                offset: Offset(shake, 0),
                                child: child,
                              );
                            },
                            child: SelectableText(
                              _scrambledWord.isEmpty ? '—' : _scrambledWord.toUpperCase(),
                              style: theme.textTheme.headlineLarge?.copyWith(
                                letterSpacing: 4.0, 
                                fontWeight: FontWeight.w900,
                                // Color changes dynamically
                                color: _showCorrect ? Colors.green.shade600 : (_showIncorrect ? theme.colorScheme.error : theme.colorScheme.onSurface),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // --- Hint/Skip Controls ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_hintUsedThisRound)
                                ElevatedButton.icon(
                                  onPressed: _useHint,
                                  icon: const Icon(Icons.lightbulb_outline),
                                  label: Text('Hint (-$_hintPenalty Score)'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.secondaryContainer,
                                    foregroundColor: theme.colorScheme.onSecondaryContainer,
                                    elevation: 0,
                                  ),
                                ),
                              if (_hintUsedThisRound)
                                Chip(label: const Text('Hint used'), avatar: Icon(Icons.check, color: theme.colorScheme.onSecondary)),
                              
                              const SizedBox(width: 12),
                              
                              ElevatedButton.icon(
                                onPressed: _skipWord,
                                icon: const Icon(Icons.skip_next),
                                label: const Text('Skip Word'),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // --- Hint Display ---
                          if (_hintUsedThisRound)
                            Text(
                              'Hint: ${_originalWord[0].toUpperCase()}${_originalWord.length > 1 ? '...${_originalWord[_originalWord.length - 1].toUpperCase()}' : ''}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --- Input + submit (TextField with colors) ---
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _guessController,
                          onSubmitted: (_) => _checkGuess(),
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            hintText: 'Type your guess here (e.g., widget)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2), // Colored border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: theme.colorScheme.primaryContainer, width: 3),
                            ),
                            prefixIcon: Icon(Icons.keyboard, color: theme.colorScheme.primary),
                            fillColor: theme.colorScheme.primary.withOpacity(isDark ? 0.05 : 0.1), // Lightly colored background
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _checkGuess,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 56), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: theme.colorScheme.primary, // Primary color for button
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  
                  // --- Feedback Banner and Definition Box ---
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return SizeTransition(sizeFactor: animation, child: child);
                    },
                    child: Column(
                      key: ValueKey(_showCorrect || _showIncorrect),
                      children: [
                        if (_showCorrect || _showIncorrect) _feedbackBanner(),
                        const SizedBox(height: 12),
                        // Word definition (reveal only after correct guess)
                        if (_dictionary.containsKey(_originalWord) && _showCorrect)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green.withOpacity(0.1), // Green highlight for definition
                              border: Border.all(color: Colors.green.withOpacity(0.5)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lightbulb_sharp, color: Colors.green),
                                const SizedBox(width: 10),
                                Expanded(child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: '${_originalWord.toUpperCase()}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: '${_dictionary[_originalWord]}'),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- Footer Controls ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _timer?.cancel();
                          _shuffleAndPickNew(resetRound: true);
                        },
                        icon: const Icon(Icons.replay),
                        label: const Text('Restart Game (Full Reset)'),
                      ),
                      
                      // Round and Time Dropdowns
                      Row(
                        children: [
                          _buildDropdown('Rounds', _rounds, [5, 10, 15, 20], (v) {
                            if (v != null) setState(() => _rounds = v);
                          }, (v) => '$v'),
                          const SizedBox(width: 12),
                          _buildDropdown('Time', _timePerRound, [15, 20, 30, 45], (v) {
                            if (v != null) setState(() {
                              _timePerRound = v;
                              _startTimer();
                            });
                          }, (v) => '$v s'),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  
                  // Footer: custom words count
                  Text('Current Word Pool Size: ${_wordPool.length}', style: theme.textTheme.labelSmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Custom UI Widgets ---

  // NOTE: Uses chipColor for customized look and added ScaleTransition
  Widget _animatedInfoChip(String label, String value, ThemeData theme, Color chipColor, {bool isTimer = false}) {
    // Determine the color for the text and background
    final Color effectiveColor = isTimer && _timeLeft <= 5 ? theme.colorScheme.error : chipColor;
    final Color bgColor = effectiveColor.withOpacity(0.15);
    // Use the Color extension to ensure text is visible on the light background
    final Color textColor = isTimer && _timeLeft <= 5 ? effectiveColor : effectiveColor.darken(theme.brightness == Brightness.dark ? 0.0 : 0.3); 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          // Subtle pop animation for value changes
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Container(
            key: ValueKey(value),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), 
              color: bgColor,
              border: Border.all(color: effectiveColor.withOpacity(0.5), width: 1.5)
            ),
            child: Text(
              value, 
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _difficultyButton(Difficulty d, String label, ThemeData theme) {
    final selected = _difficulty == d;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        if (!selected) {
          setState(() {
            _difficulty = d;
            _shuffleAndPickNew(resetRound: true);
          });
        }
      },
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surfaceVariant,
      labelStyle: TextStyle(color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
    );
  }
  
  Widget _buildDropdown<T>(String label, T value, List<T> items, ValueChanged<T?> onChanged, String Function(T) itemText) {
    return Row(
      children: [
        Text('$label: ', style: Theme.of(context).textTheme.labelLarge),
        DropdownButton<T>(
          value: value,
          items: items.map((n) => DropdownMenuItem(value: n, child: Text(itemText(n)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
