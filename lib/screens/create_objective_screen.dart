import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../providers/objective_provider.dart';
import '../models/objective.dart';
import '../services/ai_recommendation_service.dart';
import '../widgets/notification_popup.dart';
import '../utils/constants.dart';
import '../widgets/notification_popup.dart';

class CreateObjectiveScreen extends StatefulWidget {
  const CreateObjectiveScreen({super.key});

  @override
  State<CreateObjectiveScreen> createState() => _CreateObjectiveScreenState();
}

class _CreateObjectiveScreenState extends State<CreateObjectiveScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  double _amount = 0.0;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  int _priority = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Nouvel Objectif", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryValue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Qu'est-ce qui te motive ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nom de l'objectif (ex: Nouveau PC)",
                  border: OutlineInputBorder(borderRadius: AppStyles.borderRadius),
                ),
                validator: (val) => val == null || val.isEmpty ? "Ce champ est requis" : null,
                onSaved: (val) => _title = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Montant cible (TND)",
                  border: OutlineInputBorder(borderRadius: AppStyles.borderRadius),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Requis";
                  if (double.tryParse(val) == null) return "Entrez un nombre valide";
                  return null;
                },
                onSaved: (val) => _amount = double.parse(val!),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Date d'échéance"),
                subtitle: Text(DateFormat('dd MMMM yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today, color: AppColors.primaryValue),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text("Priorité (Définit l'ordre dans le dashboard)", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
              const SizedBox(height: 8),
              Slider(
                value: _priority.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: AppColors.primaryValue,
                label: "$_priority%",
                onChanged: (val) => setState(() => _priority = val.toInt()),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveObjective,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryValue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
                ),
                child: const Text("Créer l'objectif", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveObjective() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final objective = Objective(
        id: Uuid().v4(),
        title: _title,
        targetAmount: _amount,
        targetDate: _selectedDate,
        priority: _priority,
      );

      context.read<ObjectiveProvider>().addObjective(objective);

      String aiAdvice = AiRecommendationService.getCreationAdvice(objective);
      
      NotificationPopup.show(
         context,
         "Objectif '${objective.title}' créé ! Glisse-le pour le prioriser.",
         aiAdvice
      );
      
      Navigator.pop(context);
    }
  }
}
