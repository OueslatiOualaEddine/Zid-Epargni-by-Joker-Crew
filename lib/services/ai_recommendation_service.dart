import '../models/objective.dart';
import '../models/savings_mode.dart';

class AiRecommendationService {
  static List<String> getRecommendations(double balance, double expensesThisMonth, List<Objective> objectives, SavingsMode mode) {
    List<String> recommendations = [];

    // Objective related
    var pending = objectives.where((o) => o.currentAmount < o.targetAmount).toList();
    if (pending.isNotEmpty) {
       pending.sort((a,b) => a.targetDate.compareTo(b.targetDate));
       var nearest = pending.first;
       var daysLeft = nearest.targetDate.difference(DateTime.now()).inDays;
       
       if (daysLeft <= 15 && daysLeft > 0) {
           if (mode != SavingsMode.automaticRoundup) {
              recommendations.add("Il te reste $daysLeft jours pour atteindre ton objectif '${nearest.title}'. Active l'arrondi renforcé !");
           } else {
              recommendations.add("Plus que $daysLeft jours pour '${nearest.title}'. Continue, tu y es presque !");
           }
       } else if (nearest.currentAmount / nearest.targetAmount >= 0.8) {
           recommendations.add("Ton objectif '${nearest.title}' est à ${(nearest.currentAmount/nearest.targetAmount*100).toInt()}% ! Continue comme ça !");
       } else {
           recommendations.add("Petit conseil : un petit dépôt manuel sur '${nearest.title}' te ferait beaucoup de bien !");
       }
    } else {
       recommendations.add("Tu as atteint tous tes objectifs ! C'est le moment d'en créer un nouveau.");
    }

    if (expensesThisMonth > balance * 0.5 && balance > 0) {
      recommendations.add("Attention, ton budget a dépassé la limite ce mois-ci par rapport à ton solde !");
    }

    return recommendations;
  }

  static String getCreationAdvice(Objective obj) {
    int monthsLeft = (obj.targetDate.difference(DateTime.now()).inDays / 30).ceil();
    if (monthsLeft <= 0) monthsLeft = 1;
    double monthlyNeeded = obj.targetAmount / monthsLeft;
    
    return "💡 Conseil IA : Pour atteindre ton objectif '${obj.title}' dans $monthsLeft mois, épargne ${monthlyNeeded.toStringAsFixed(0)} DT par mois. Active l'arrondi automatique !";
  }

  static String getBudgetLimitAdvice(String category, double limit) {
    if (category == "Courses") return "💡 Conseil IA : Planifie tes repas de la semaine et utilise une liste précise pour éviter les achats impulsifs et respecter ton budget de ${limit.toStringAsFixed(0)} TND.";
    if (category == "Transport") return "💡 Conseil IA : Envisage le covoiturage ou les transports en commun pour réduire cette dépense fixée à ${limit.toStringAsFixed(0)} TND au maximum.";
    if (category == "Loisirs") return "💡 Conseil IA : Attention ! Les loisirs ont avalé ton budget alloué ! Privilégie les activités gratuites, comme les balades, d'ici la fin du mois.";
    return "💡 Conseil IA : Tu as franchi ton plafond autorisé de ${limit.toStringAsFixed(0)} TND sur la catégorie $category. Essaie d'identifier les achats superflus !";
  }
}
