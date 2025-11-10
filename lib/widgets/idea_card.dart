import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/idea_model.dart';

class IdeaCard extends StatefulWidget {
  final StartupIdea idea;
  final VoidCallback? onUpvote;
  final int? rank;
  final VoidCallback? onCopied;

  const IdeaCard({super.key, required this.idea, this.onUpvote, this.rank, this.onCopied});

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    Gradient? cardGradient;
    if (widget.rank != null && widget.rank! <= 3) {
      cardGradient = widget.rank == 1
          ? const LinearGradient(colors: [Colors.yellow, Colors.orange])
          : widget.rank == 2
              ? const LinearGradient(colors: [Colors.grey, Colors.blueGrey])
              : const LinearGradient(colors: [Colors.orange, Colors.deepOrange]);
    }
    Widget card = Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          title: Text(
            widget.rank != null && widget.rank! <= 3 
                ? '${widget.rank == 1 ? '🥇' : widget.rank == 2 ? '🥈' : '🥉'} ${widget.idea.name}' 
                : widget.idea.name,
            style: widget.rank != null && widget.rank! <= 3
                ? const TextStyle(color: Colors.black)
                : null,
          ),
          subtitle: Text(
            widget.idea.tagline,
            style: widget.rank != null && widget.rank! <= 3
                ? const TextStyle(color: Colors.black)
                : null,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ${_showFullDescription ? widget.idea.description : (widget.idea.description.length > 100 ? '${widget.idea.description.substring(0, 100)}...' : widget.idea.description)}',
                    style: widget.rank != null && widget.rank! <= 3
                        ? const TextStyle(color: Colors.black)
                        : null,
                  ),
                  if (widget.idea.description.length > 100)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showFullDescription = !_showFullDescription;
                        });
                      },
                      child: Text(
                        _showFullDescription ? 'Read less' : 'Read more',
                        style: TextStyle(
                          color: widget.rank != null && widget.rank! <= 3 ? Colors.black : Colors.blue,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '⭐ ${widget.idea.rating}',
                        style: widget.rank != null && widget.rank! <= 3
                            ? const TextStyle(color: Colors.black)
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.idea.votes}',
                            style: widget.rank != null && widget.rank! <= 3
                                ? const TextStyle(color: Colors.black)
                                : null,
                          ),
                        ],
                      ),
                      if (widget.onUpvote != null) const Spacer(),
                      ElevatedButton(
                        onPressed: widget.onUpvote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Upvote'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          final text =
                              'Check out this idea: ${widget.idea.name}\n${widget.idea.tagline}\n${widget.idea.description}\nRating: ${widget.idea.rating}, Votes: ${widget.idea.votes}';
                          await Clipboard.setData(ClipboardData(text: text));
                          
                          widget.onCopied?.call();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (widget.onUpvote != null) {
      return Dismissible(
        key: Key('${widget.idea.name}_${widget.idea.votes}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green, Colors.lightGreen]),
          ),
          child: const Icon(Icons.thumb_up, color: Colors.white),
        ),
        onDismissed: (direction) {
          widget.onUpvote!();
        },
        child: card,
      );
    }
    return card;
  }
}
