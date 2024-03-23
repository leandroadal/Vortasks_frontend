import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test_application/entities/tasks/task.dart';
import 'package:flutter_test_application/main.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.tasks, required this.addTask});

  final List<Task> tasks;
  final Function(Task) addTask;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  Color _backgroundColor = const Color(0xFF614eff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: const Text('Adicionar Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.9, // 90% da largura da tela
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AddTaskForm(
                tasks: widget.tasks,
                addTask: widget.addTask,
                backgroundColor: _backgroundColor,
                onBackgroundColorChanged: (color) {
                  setState(() {
                    _backgroundColor = color;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const List<Widget> repetition = <Widget>[
  Text('Diário'),
  Text('Semanal'),
  Text('Mensal')
];

const List<Widget> remember = <Widget>[
  Text('Não lembrar'),
  Text('10 min antes'),
  Text('1h antes'),
  Text('1d antes')
];

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({
    super.key,
    required this.tasks,
    required this.addTask,
    required this.backgroundColor,
    required this.onBackgroundColorChanged,
  });

  final List<Task> tasks;
  final Function(Task) addTask;
  final Color backgroundColor;
  final Function(Color) onBackgroundColorChanged;

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = Type.productivity.toString();
  bool _allDayEnabled = false;
  bool _startDateEnabled = false;
  String _reminderValue = "1"; // Valor inicial para o lembrete
  String _selectedReminder = "1"; // Inicialmente selecionado o lembrete diário
  bool _repetitionEnabled = false; // Repetição ativada/desativada
  bool _reminderEnabled = false; // Lembrete ativado/desativado
  final List<bool> _selectedRepetition = <bool>[true, false, false];

  DateTime _startDate = DateTime.now();
  DateTime _endDate =
      DateTime.now().add(const Duration(days: 7)); // Data de hoje + 7 dias

// Função para selecionar a data de início
  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(), // Data mínima é a data de hoje
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      if (picked.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('A data de início não pode ser anterior à data de hoje'),
          ),
        );
      } else if (picked.isAfter(_endDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'A data de início não pode ser posterior à data de término'),
          ),
        );
      } else {
        setState(() {
          _startDate = picked;
        });
      }
    }
  }

// Função para selecionar a data de término
  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate, // Data mínima é a data de início
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      if (picked.isBefore(_startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'A data de término não pode ser anterior à data de início',
            ),
          ),
        );
      } else {
        setState(() {
          _endDate = _allDayEnabled
              ? picked.add(Duration(hours: 23, minutes: 59, seconds: 59))
              : picked;
        });
      }
    }
  }

  void _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 23, minute: 59),
    );
    if (picked != null) {
      setState(() {
        _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day,
            picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField(
          value: _selectedType,
          onChanged: (newValue) {
            setState(() {
              _selectedType = newValue.toString();
              widget.onBackgroundColorChanged(
                _selectedType == Type.leisure.toString()
                    ? const Color(0xFF9735fe)
                    : const Color.fromARGB(
                        255, 70, 62, 177), // Color.fromARGB(255, 70, 62, 177)
              );
            });
          },
          items: Type.values.map((type) {
            return DropdownMenuItem(
              value: type.toString(),
              child: Text(type.name.toString()),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Tipo',
            border: const OutlineInputBorder(),
            fillColor: _selectedType == Type.leisure.toString()
                ? const Color(0xFF9735fe)
                : const Color(0xFF614eff),
            filled: true,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Nome',
            border: const OutlineInputBorder(),
            fillColor: _selectedType == Type.leisure.toString()
                ? const Color(0xFF9735fe)
                : const Color(0xFF614eff),
            filled: true,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Descrição',
            border: const OutlineInputBorder(),
            fillColor: _selectedType == Type.leisure.toString()
                ? const Color(0xFF9735fe)
                : const Color(0xFF614eff),
            filled: true,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                  color: _selectedType == Type.leisure.toString()
                      ? const Color(0xFF9735fe)
                      : const Color(0xFF614eff),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Dia inteiro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Tamanho similar aos outros campos
                      ),
                    ),
                    const SizedBox(width: 10),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: _allDayEnabled,
                        onChanged: (value) {
                          setState(() {
                            _allDayEnabled = value;
                            if (_allDayEnabled) {
                              _endDate = _endDate.add(const Duration(
                                  hours: 23, minutes: 59, seconds: 59));
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (!_allDayEnabled) const SizedBox(height: 10),
        if (!_allDayEnabled)
          const Text(
            'Hora do Término',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, // Tamanho similar aos outros campos
            ),
          ),
        if (!_allDayEnabled) const SizedBox(height: 10),
        if (!_allDayEnabled)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectEndTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white),
                      color: _selectedType == Type.leisure.toString()
                          ? const Color(0xFF9735fe)
                          : const Color(0xFF614eff),
                    ),
                    child: Text(
                      '${_endDate.hour}:${_endDate.minute}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Tamanho similar aos outros campos
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Data de Início:'),
            const SizedBox(width: 10),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                value: _startDateEnabled,
                onChanged: (value) {
                  setState(() {
                    _startDateEnabled = value;
                    if (!_startDateEnabled) {
                      _startDate = _endDate;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        if (_startDateEnabled) const SizedBox(width: 10),
        if (_startDateEnabled)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectStartDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white),
                      color: _selectedType == Type.leisure.toString()
                          ? const Color(0xFF9735fe)
                          : const Color(0xFF614eff),
                    ),
                    child: Text(
                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Tamanho similar aos outros campos
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        const Text('Data de Término:'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectEndDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white),
                    color: _selectedType == Type.leisure.toString()
                        ? const Color(0xFF9735fe)
                        : const Color(0xFF614eff),
                  ),
                  child: Text(
                    '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text('Repetição'),
            const SizedBox(
              width: 10,
            ),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                value: _repetitionEnabled,
                onChanged: (value) {
                  setState(() {
                    _repetitionEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
        if (_repetitionEnabled)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _selectedRepetition.length; i++) {
                      _selectedRepetition[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: const Color.fromARGB(255, 2, 0, 37),
                selectedColor: Colors.white,
                fillColor: _selectedType == Type.leisure.toString()
                    ? const Color.fromARGB(255, 156, 66, 252)
                    : const Color.fromARGB(255, 70, 56, 196),
                //color: Color.fromARGB(255, 255, 253, 253),

                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedRepetition,
                children: repetition,
              ),
            ],
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Lembrete'),
            const SizedBox(
              width: 10,
            ),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                value: _reminderEnabled,
                onChanged: (value) {
                  setState(() {
                    _reminderEnabled = value;
                  });
                },
              ),
            )
          ],
        ),
        if (_reminderEnabled)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedReminder = "1"; // Diário
                    _reminderValue = "1";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedReminder == "1"
                      ? const Color.fromARGB(255, 14, 2, 124)
                      : const Color.fromARGB(255, 70, 56, 196),
                ),
                child: const Text(
                  "Diário",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedReminder = "7"; // Semanal
                    _reminderValue = "7";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedReminder == "7"
                      ? const Color.fromARGB(255, 14, 2, 124)
                      : const Color.fromARGB(255, 70, 56, 196),
                ),
                child: const Text(
                  "Semanal",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedReminder = "30"; // Mensal
                    _reminderValue = "30";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedReminder == "30"
                      ? const Color.fromARGB(255, 14, 2, 124)
                      : const Color.fromARGB(255, 70, 56, 196),
                ),
                child: const Text(
                  "Mensal",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 70, 56, 196),
          ),
          onPressed: () {
            final String name = _nameController.text;
            final String description = _descriptionController.text;
            final Type type = Type.values
                .firstWhere((type) => type.toString() == _selectedType);

            final Task newTask = Task(
              id: generateUUID(),
              name: name,
              description: description,
              status: Status.inProgress,
              xp: 50,
              coins: 100,
              type: type,
              repetition: 1,
              reminder: _reminderValue,
              skillIncrease: 50,
              skillDecrease: 10,
              startDate: DateTime.now(),
              endDate: _endDate,
              theme: TaskTheme.creativity,
              difficulty: Difficulty.medium,
            );
            print(newTask.endDate);

            widget.addTask(newTask);
            // volta à página anterior
            Navigator.pop(context);
          },
          child: const Text(
            'Adicionar Tarefa',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
