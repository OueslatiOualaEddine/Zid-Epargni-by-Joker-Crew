# 💰 Zid - Épargne Intelligente pour Tao Wallet

[![Flutter Version](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.4+-blue.svg)](https://dart.dev)
[![Hackathon](https://img.shields.io/badge/Hackathon-Hacker%20l'épargne-orange.svg)](https://github.com/OueslatiOualaEddine/Zid-Epargni-by-Joker-Crew)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📖 Contexte & Hackathon

Ce projet a été développé dans le cadre du hackathon **"Hacker l'épargne"** , organisé par **Enda** (réseau de microfinance tunisien engagé pour l'inclusion financière).

### Le Défi relevé

| Élément | Description |
| :--- | :--- |
| **Défi choisi** | Défi n°1 : L'éducation financière via des moyens de paiement innovants |
| **Outil clé** | Wallet Tao & applications transactionnelles |
| **Objectif visé** | Adoption d'outils digitaux d'épargne par les étudiants et salariés |

### Notre réponse : Zid

**Zid** (زيد - "Ajoute" en arabe) est une solution d'épargne innovante intégrée à l'application **Tao Wallet** d'Enda. Elle aide les utilisateurs à adopter des habitudes d'épargne durables grâce à :
- Des objectifs personnalisables
- Trois modes d'épargne intelligents
- Des conseils propulsés par l'IA
- Un système de priorisation par glisser-déposer

---

## 👥 Équipe Joker Crew

Une équipe multidisciplinaire réunie pour transformer l'épargne en une expérience simple, ludique et efficace.

| Membre | Rôle | Contributions |
| :--- | :--- | :--- |
| **Skander Klaî** | Marketing & E-commerce | 🎨 Concept initial<br>🎤 Pitch devant le jury<br>🎬 Réalisation de la vidéo commerciale |
| **Maram Cherif** | Design UX/UI | 🎨 Concept initial<br>📊 Présentation visuelle<br>🖌️ Charte graphique & maquettes |
| **Med Bachir Chammem** | Software Developer | 💡 Concept initial<br>📱 Développement mobile Flutter |
| **Ouala Eddine Oueslati** | Software Developer (Lead) | 💡 Concept initial<br>📱 Développement mobile Flutter<br>🤖 Intégration IA & notifications |

---

## 🎬 Démonstrations Vidéo

| Vidéo Commerciale | Démo Application Mobile |
| :---: | :---: |
| <video src="https://github.com/OueslatiOualaEddine/Zid-Epargni-by-Joker-Crew/blob/main/demo/joker-crew-x-enda-taw.mp4" width="300" controls></video> | <video src="https://github.com/OueslatiOualaEddine/Zid-Epargni-by-Joker-Crew/blob/main/demo/zid-epargni-mobile-app-demo.mp4" width="300" controls></video> |
| *Présentation marketing du projet Zid* | *Parcours utilisateur complet dans l'application* |
| *Public cible, bénéfices et impact* | *De l'onboarding à la notification d'objectif atteint* |
| **Réalisée par : Skander Klaî** | **Réalisée par : Équipe Dev** |

> 💡 **Note** : Si les vidéos ne s'affichent pas directement, vous pouvez les télécharger depuis le dossier [`/demo`](demo/) du dépôt.

---

## ✨ Fonctionnalités Clés

### 🎯 Objectifs d'Épargne Prioritaires
- Créez des objectifs concrets (ex: "Voyage", "Nouveau PC") avec un montant cible et une date d'échéance.
- **Glissez-déposez** les objectifs pour définir leur priorité.
- **Répartition intelligente** : L'objectif le plus haut dans la liste reçoit la plus grosse part de votre épargne :
  - Position 1 (priorité max) : 50%
  - Position 2 : 30%
  - Position 3 : 15%
  - Positions 4+ : 5% (partagé)

### 💳 Trois Modes d'Épargne

| Mode | Description |
| :--- | :--- |
| **Manuel** | Définissez un budget et des limites par catégorie. Recevez des alertes IA quand votre budget restant est bas. |
| **Automatique (Arrondi)** | Chaque dépense est arrondie au TND supérieur. La différence est automatiquement épargnée jusqu'à atteindre votre objectif mensuel. Exemple : 12,250 TND → 0,750 TND épargnés. |
| **Défi Inversé** | Fixez un montant à épargner. Il est prélevé immédiatement dès que vous déclarez vos revenus (salaire ou argent de poche). Vous vivez avec ce qui reste. |

### 🤖 IA Bienveillante & Notifications

| Notification | Déclencheur |
| :--- | :--- |
| 🎉 **Objectif atteint** | `currentAmount >= targetAmount` |
| ⚠️ **Échéance proche** | J-7 ET `currentAmount < targetAmount` |
| 🔴 **Limite de dépenses** | Période personnalisable dépassée + recommandation IA |

### 📱 Gestion des Dépenses Simplifiée
- Les dépenses effectuées via **Tao sont automatiquement déduites** de votre suivi.
- Vous pouvez également **ajouter des dépenses en espèces manuellement** pour un suivi complet.
- Catégorisation des dépenses (Courses, Transport, Loisirs, etc.)
- Option de **scan de ticket** (OCR)

---

## 🚀 Technologies Utilisées

| Catégorie | Technologie |
| :--- | :--- |
| **Framework** | Flutter 3.22+ |
| **Langage** | Dart 3.4+ |
| **State Management** | Provider |
| **Stockage Local** | Hive + SharedPreferences |
| **Notifications** | flutter_local_notifications |
| **Drag & Drop** | reorderables |
| **Internationalisation** | intl |


---

## 🎨 Charte Graphique (Tao Enda)

| Élément | Code couleur |
| :--- | :--- |
| Fond principal | `#FFFFFF` (blanc) |
| Texte principal | `#1A1A1A` (noir) |
| Texte secondaire | `#757575` (gris) |
| **Primaire (boutons, icônes)** | **`#00A859` (vert Enda)** |
| Alerte | `#FF6B6B` (rouge doux) |
| Avertissement | `#FFB74D` (orange) |
| Bordures | radius 12px |


---

## 🙏 Remerciements

- **Enda** pour l'organisation du hackathon "Hacker l'épargne"
- **L'équipe Tao Wallet** pour la mise à disposition de l'API
- **Toute l'équipe Joker Crew** pour son énergie et sa créativité

---

## ⭐ Aidez-nous à grandir !

Si ce projet vous a plu, n'hésitez pas à :
- ⭐ Mettre une étoile sur GitHub
- 🍴 Forker le projet
- 📢 Le partager autour de vous

---

<div align="center">

**Zid** - *Glisse, épargne, réalise.*

Made with ❤️ by **Joker Crew** at *Hacker l'épargne* (Enda)

</div>
