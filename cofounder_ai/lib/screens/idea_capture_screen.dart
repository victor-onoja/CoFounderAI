import 'package:cofounder_ai/blocs/idea/idea_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../blocs/idea/idea_event.dart';
import '../blocs/idea/idea_state.dart';

class IdeaCaptureScreen extends StatefulWidget {
  const IdeaCaptureScreen({super.key});

  @override
  _IdeaCaptureScreenState createState() => _IdeaCaptureScreenState();
}

class _IdeaCaptureScreenState extends State<IdeaCaptureScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  final SpeechToText _speech = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  final FlutterTts flutterTts = FlutterTts();

  final List<String> _placeholders = [
    "A sustainable energy solution...",
    "An AI-powered education platform...",
    "A revolutionary healthcare app...",
    "A blockchain-based finance system...",
  ];

  int _currentPlaceholder = 0;
  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animatePlaceholder();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _animatePlaceholder() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentPlaceholder =
              (_currentPlaceholder + 1) % _placeholders.length;
        });
        _animatePlaceholder();
      }
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) {
        if (status == "done") {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
      },
    );
    setState(() {});
  }

  void _listen() async {
    if (_speechEnabled && !_isListening) {
      setState(() => _isListening = true);
      await _speech.listen(onResult: _onSpeechResult);
    }
  }

  void _stopListening() async {
    if (_isListening) {
      setState(() => _isListening = false);
      await _speech.stop();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _controller.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IdeaBloc, IdeaState>(
        listener: (context, state) {
          if (state is IdeaExpanded) {
            setState(() {
              _showSaveButton = true;
              _animationController.forward();
            });
            flutterTts.speak(state.expandedIdea);
          } else if (state is IdeaSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Idea saved successfully!')),
            );
            setState(() {
              _controller.clear();
              _showSaveButton = false;
              _animationController.reverse();
            });
          } else if (state is IdeaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
            setState(() {
              _showSaveButton = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Capture Your Idea')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: _placeholders[_currentPlaceholder],
                    suffixIcon: IconButton(
                      icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                      onPressed: _isListening ? _stopListening : _listen,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  maxLines: 3,
                  onChanged: (value) {},
                ),
                _isListening
                    ? const Text('Listening...')
                    : _speechEnabled
                        ? const Text(
                            'Tap the mic icon to start and stop listening.\nVoice works best when you say your idea in one sentence.',
                            textAlign: TextAlign.center,
                          )
                        : const Text('speech not available, type your idea :)'),
                const SizedBox(height: 20),
                BlocBuilder<IdeaBloc, IdeaState>(builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        (_controller.text.isNotEmpty && state is! IdeaExpanding)
                            ? () => context
                                .read<IdeaBloc>()
                                .add(ExpandIdea(_controller.text))
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: state is IdeaExpanding
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Expand with AI'),
                  );
                }),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                        height: _animation.value *
                            MediaQuery.sizeOf(context).height *
                            0.4,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: BlocBuilder<IdeaBloc, IdeaState>(
                            builder: (context, state) {
                          return SingleChildScrollView(
                            child: Text(state is IdeaExpanded
                                ? state.expandedIdea
                                : ''),
                          );
                        }));
                  },
                ),
                const SizedBox(height: 20),
                if (_showSaveButton)
                  AnimatedOpacity(
                      opacity: _showSaveButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: BlocBuilder<IdeaBloc, IdeaState>(
                          builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is IdeaExpanded
                              ? () => context.read<IdeaBloc>().add(SaveIdea(
                                  _controller.text, state.expandedIdea))
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: state is IdeaSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Save Idea'),
                        );
                      })),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.cancel();
    flutterTts.stop();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }
}
