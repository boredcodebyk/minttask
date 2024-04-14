// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:minttask/model/todo_provider.dart';
// import 'package:minttask/model/todotxt_parser.dart';

// class EditPage extends ConsumerStatefulWidget {
//   const EditPage({super.key, required this.index});

//   final int index;
//   @override
//   ConsumerState<EditPage> createState() => _EditPageState();
// }

// class _EditPageState extends ConsumerState<EditPage> {
//   final TextEditingController _titleController = TextEditingController();
//   final TaskParser _parser = TaskParser();
//   String activeTodo = "";
//   List<String>? projectTags = [];
//   List<String>? contextTags = [];
//   bool completion = false;
//   Map<String, String>? metadata = {};
//   int? priority;
//   DateTime? completionDate;
//   late DateTime creationDate;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     loadTodo();
//   }

//   void loadFile() async {
//     try {
//       final todotxt = File(ref.read(filePathProvider.notifier).state);
//       ref.read(todoContentProvider.notifier).state =
//           await todotxt.readAsString();
//     } catch (e) {
//       print(e);
//     }
//   }

//   void loadTodo() {
//     setState(() {
//       TaskText activeTodo = _parser
//           .parser(ref.read(todoListProvider.notifier).state[widget.index]);
//       _titleController.text = activeTodo.text;
//       projectTags = activeTodo.projectTag;
//       contextTags = activeTodo.contextTag;
//       completion = activeTodo.completion;
//       metadata = activeTodo.metadata;
//       priority = activeTodo.priority;
//       completionDate = activeTodo.completionDate;
//       creationDate = activeTodo.creationDate;
//     });
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           const SliverAppBar.medium(),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ChoiceChip(
//                       label: const Text("Mark Done"), selected: completion),
//                   TextField(
//                     controller: _titleController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     style: Theme.of(context).textTheme.headlineMedium,
//                     decoration: const InputDecoration(
//                       labelText: "Title",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                   Text(
//                     "Contexts",
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                   Wrap(
//                     crossAxisAlignment: WrapCrossAlignment.start,
//                     spacing: 8,
//                     runSpacing: 4,
//                     children: [
//                     if (contextTags!.isNotEmpty)  ...contextTags!.asMap().entries.map(
//                             (e) => InputChip(
//                               label: Text(e.value),
//                               onPressed: () => showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   TextEditingController _controller =
//                                       TextEditingController();
//                                   setState(() {
//                                     _controller.text = e.value;
//                                   });
//                                   return AlertDialog(
//                                     title: Text("Edit"),
//                                     content: TextField(
//                                       decoration: const InputDecoration(
//                                           hintText: "context1, context2",
//                                           border: OutlineInputBorder()),
//                                       controller: _controller,
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               contextTags?.removeAt(e.key);
//                                               contextTags?.insertAll(
//                                                   e.key,
//                                                   _controller.text
//                                                       .trim()
//                                                       .split(" "));
//                                             });

//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text("Done"))
//                                     ],
//                                   );
//                                 },
//                               ),
//                               deleteIcon: Icon(
//                                 Icons.close,
//                                 size: 18,
//                               ),
//                               onDeleted: () {
//                                 setState(() {
//                                   contextTags?.removeAt(e.key);
//                                 });
//                               },
//                             ),
//                           ),
//                       ActionChip(
//                         label: const Icon(Icons.add, size: 18),
//                         onPressed: () => showDialog(
//                           context: context,
//                           builder: (context) {
//                             TextEditingController _controller =
//                                 TextEditingController();
//                             return AlertDialog(
//                               title: Text("Contexts"),
//                               content: TextField(
//                                 decoration: const InputDecoration(
//                                     hintText: "@project1 @project2 ...",
//                                     border: OutlineInputBorder()),
//                                 controller: _controller,
//                               ),
//                               actions: [
//                                 TextButton(
//                                     onPressed: () {
//                                       for (var element in _controller.text
//                                           .trim()
//                                           .split(" ")) {
//                                         if (element.startsWith("@")) {
//                                           setState(() {
//                                             contexts.add(element);
//                                           });
//                                         } else {
//                                           setState(() {
//                                             contexts.add("@$element");
//                                           });
//                                         }
//                                       }

//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Text("Done"))
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     "Tags",
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                   Wrap(
//                     crossAxisAlignment: WrapCrossAlignment.start,
//                     spacing: 8,
//                     runSpacing: 4,
//                     children: [
//                       ...tags.asMap().entries.map(
//                             (e) => InputChip(
//                               label: Text(e.value),
//                               onPressed: () => showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   TextEditingController _controller =
//                                       TextEditingController();
//                                   setState(() {
//                                     _controller.text = e.value;
//                                   });
//                                   return AlertDialog(
//                                     title: Text("Edit"),
//                                     content: TextField(
//                                       decoration: const InputDecoration(
//                                           hintText: "+tag1",
//                                           border: OutlineInputBorder()),
//                                       controller: _controller,
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               tags.removeAt(e.key);
//                                               tags.insertAll(
//                                                   e.key,
//                                                   _controller.text
//                                                       .trim()
//                                                       .split(" "));
//                                             });

//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text("Done"))
//                                     ],
//                                   );
//                                 },
//                               ),
//                               deleteIcon: Icon(
//                                 Icons.close,
//                                 size: 18,
//                               ),
//                               onDeleted: () {
//                                 setState(() {
//                                   tags.removeAt(e.key);
//                                 });
//                               },
//                             ),
//                           ),
//                       ActionChip(
//                         label: const Icon(Icons.add, size: 18),
//                         onPressed: () => showDialog(
//                           context: context,
//                           builder: (context) {
//                             TextEditingController _controller =
//                                 TextEditingController();
//                             return AlertDialog(
//                               title: Text("Tags"),
//                               content: TextField(
//                                 decoration: const InputDecoration(
//                                     hintText: "+tag1 +tag2 ...",
//                                     border: OutlineInputBorder()),
//                                 controller: _controller,
//                               ),
//                               actions: [
//                                 TextButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         tags.addAll(
//                                             _controller.text.trim().split(" "));
//                                       });

//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Text("Done"))
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     "Due",
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                   ActionChip(
//                     label: Text(due.split("due:").last),
//                     onPressed: () => showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1995),
//                       lastDate: DateTime.now().add(const Duration(days: 730)),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // "${completion ? "x " : "".trim()}${completion ? "$completionDate " : ""}${creationDate.trim()} ${_titleController.text.trim()} ${tags.isNotEmpty ? tags.join(" ").trim() : ""}${contexts.join(" ")} ${due.replaceFirst("due:", "").trim().isNotEmpty ? "due:${due.replaceFirst("due:", "").trim()}" : ""}";
//           var t = TaskText(
//               completion: completion,
//               priority: priority,
//               completionDate: completionDate,
//               creationDate: creationDate,
//               text: _titleController.text,
//               tags: tags,
//               contexts: contexts,
//               due: due);
//           //  print(saveTodo.trim());
//           print(t.lineContructor());
//           print(_titleController.text);
//           String saveTodo = t.lineContructor().trim();
//           ref.read(todoListProvider.notifier).state[widget.index] = saveTodo;
//           ref.read(todoContentProvider.notifier).state =
//               ref.watch(todoListProvider).join("\n");
//           File outputFile = File(ref.watch(filePathProvider));
//           await outputFile.writeAsString(ref.watch(todoContentProvider));
//           loadFile();
//           if (!mounted) return;
//           Navigator.of(context).pop();
//         },
//         child: const Icon(Icons.done),
//       ),
//     );
//   }
// }
