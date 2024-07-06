///Imports:
// dotenv: Pour gérer les variables d'environnement.
// flutter/material.dart: Pour utiliser les widgets Material Design.
// geminina/const/app_constante.dart: Pour les constantes de l'application.
// geminina/service/chat_service.dart: Pour les services de chat.
// geminina/widgets/messae_widget.dart: Pour les widgets de message.
// google_generative_ai/google_generative_ai.dart: Pour le modèle génératif de Google.
// Classes:
import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:geminina/service/chat_service.dart';
import 'package:geminina/widgets/messae_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';



// _scrollDown(): Scroll automatiquement vers le bas pour afficher le dernier message.
// build(): Construit l'interface utilisateur.
// _sendChatMessage(): Envoie un message au modèle génératif et gère la réponse.
// _showError(): Affiche un message d'erreur dans une boîte de dialogue.
///


// ChatScreen est un StatefulWidget qui gère l'interface utilisateur du chatbot.
// _ChatScreenState contient l'état et la logique de ChatScreen.
// Initialisation:
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // _formKey, _promptController, _messages: Contrôleurs et listes pour gérer le formulaire et les messages.
  final _formKey = GlobalKey<FormState>();
  /// Controller pour le prompt de l'utilisateur
  final _promptController = TextEditingController();

  /// Message géneré
  final _messages = <MessageWidget>[];
    late final GenerativeModel _model;
  final ScrollController _scrollController = ScrollController();

// env: Charge les variables d'environnement.
  var env = DotEnv(includePlatformEnvironment: true)..load();
  
  // _generatedContent: Liste des contenus générés (texte et images).
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];

  /// _loading: Indique si une requête est en cours.
  /// variable pour suivre l'etat de la progression de la generation 
  bool _loading = false;

  /// Session du Chat
  late final ChatSession _chat;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();

  ChatService _chatService = ChatService();  

  @override
  void initState() {
    super.initState();
    
    _model = _chatService.initModel();
    
    // _chat: Session de chat initialisée dans initState.
    _chat = _model.startChat();
  }

 void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    final API_KEY = env['GEMINI_API_KEY']!;

      final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Entrer votre prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('geminiNa Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: API_KEY.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      final content = _generatedContent[idx];
                      return MessageWidget(
                        text: content.text,
                        image: content.image,
                        isFromUser: content.fromUser,
                      );
                    },
                    itemCount: _generatedContent.length,
                  )
                : ListView(
                    children: const [
                      Text(
                        'No API key found. Please provide an API Key using '
                        "'--dart-define' to set the 'API_KEY' declaration.",
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: textFieldDecoration,
                    controller: _textController,
                    onSubmitted: _sendChatMessage,
                  ),
                ),
                const SizedBox.square(dimension: 15),
                /// generate image
                // IconButton(
                //   onPressed: !_loading
                //       ? () async {
                //           _sendImagePrompt(_textController.text);
                //         }
                //       : null,
                //   icon: Icon(
                //     Icons.image,
                //     color: _loading
                //         ? Theme.of(context).colorScheme.secondary
                //         : Theme.of(context).colorScheme.primary,
                //   ),
                // ),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(_textController.text);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    )
  
          ),
        
        ],
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('Pas de réponse de l\Api verifier votre internet iu relancer .');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Une erreur est survenue'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  // void _sendMessage(String prompt) async {
  //   if (prompt.isEmpty) return;

  //   final response = await _chatService.sendMessage(prompt);

  //   setState(() {
  //     _messages.add(MessageWidget(text: prompt, isFromUser: true));
  //     _messages.add(MessageWidget(text: response, isFromUser: false));
  //     _promptController.text = '';
  //   });
  // }
}
