# NutriTrack

MyFitnessPal est une application Flutter conçue pour aider les utilisateurs à gérer leur alimentation et leur santé de manière simple et efficace.

## 🔍 Aperçu de notre application

L'application MyFitnessPal permet aux utilisateurs de suivre leur consommation alimentaire, d'atteindre leurs objectifs de santé et de personnaliser leur expérience en fonction de leurs besoins nutritionnels.

## 📲 Applications similaires

Il existe de nombreuses applications de suivi de l'alimentation sur le marché, chacune offrant différentes fonctionnalités. Voici quelques exemples :

- **MyFitnessPal**
    - **Description** : MyFitnessPal est l'une des applications les plus populaires pour le suivi de l'alimentation et de l'activité physique. Elle dispose d'une immense base de données alimentaire (plus de 14 millions d'entrées).
    - **Fonctionnalités principales** :
        - Scanner de code-barres pour ajouter des aliments rapidement.
        - Suivi des calories, macronutriments et micronutriments.
        - Intégration avec des dispositifs tiers comme Fitbit et Garmin.
        - Communauté active pour partager des conseils et des expériences.
    - **Liens** :
        - iOS : [MyFitnessPal sur l'App Store](https://apps.apple.com/us/app/myfitnesspal/id568832228)
        - Android : [MyFitnessPal sur Google Play](https://play.google.com/store/apps/details?id=com.myfitnesspal.android)

- **Lose It!**
    - **Description** : Lose It! se concentre sur la perte de poids en proposant une interface simple et des outils ludiques.
    - **Fonctionnalités principales** :
        - Suivi des calories et objectifs quotidiens personnalisés.
        - Scanner de code-barres pour une entrée rapide des aliments.
        - Intégration avec des trackers tiers pour suivre les pas et les exercices.
        - Fonctionnalités sociales pour défier des amis et rester motivé.
    - **Liens** :
        - iOS : [Lose It! sur l'App Store](https://apps.apple.com/us/app/lose-it/id297368587)
        - Android : [Lose It! sur Google Play](https://play.google.com/store/apps/details?id=com.loseit)

- **Cronometer**
    - **Description** : Cronometer se spécialise dans l'analyse nutritionnelle avancée, adaptée aux régimes spécifiques ou besoins médicaux.
    - **Fonctionnalités principales** :
        - Suivi des calories, macronutriments et micronutriments détaillés (vitamines, minéraux).
        - Outils pour gérer des régimes spécifiques (végan, cétogène, diabétique, etc.).
        - Possibilité de collaborer avec un diététicien ou un entraîneur via des rapports partagés.
    - **Liens** :
        - iOS : [Cronometer sur l'App Store](https://apps.apple.com/us/app/cronometer/id1049223637)
        - Android : [Cronometer sur Google Play](https://play.google.com/store/apps/details?id=com.cronometer.android)

- **Yazio**
    - **Description** : Yazio se concentre sur la gestion de l’alimentation équilibrée et du jeûne intermittent, avec une interface utilisateur moderne.
    - **Fonctionnalités principales** :
        - Plans de repas personnalisés basés sur les objectifs de santé.
        - Gestion et rappels pour le jeûne intermittent.
        - Intégration avec Google Fit et Apple Health.
    - **Liens** :
        - iOS : [Yazio sur l'App Store](https://apps.apple.com/us/app/yazio/id946099227)
        - Android : [Yazio sur Google Play](https://play.google.com/store/apps/details?id=com.yazio.android)

## 🤔 MoodBoard

![MyfitnessPal](https://mir-s3-cdn-cf.behance.net/projects/404/436b24196708837.Y3JvcCw5ODM5LDc2OTYsODAzLDA.png)  
![MyfitnessPal](https://cdn.dribbble.com/userupload/2957372/file/original-f46379cab48c97180d43d0b8db289672.png?resize=400x0)

## 📍 Site Map

TODO

## 👀 Design de l'application

TODO

## ⚙️ Fonctionnalités de l'application

- **Ajout d'aliments** : Les utilisateurs peuvent ajouter des aliments manuellement, via un code-barres ou par reconnaissance d'image.
- **Recherche d'aliments** : Permet aux utilisateurs de rechercher des aliments en utilisant des mots-clés pour trouver des informations nutritionnelles.
- **Reconnaissance d'aliments par photo** : Prenez une photo d’un plat ou d’un ingrédient, et l’application identifiera automatiquement les éléments nutritionnels.
- **Statistiques nutritionnelles** : Affiche un résumé des calories, glucides, lipides et protéines consommés.
- **Sauvegarde des aliments** : Les utilisateurs peuvent sauvegarder leurs aliments favoris pour un accès rapide.
- **Interface utilisateur intuitive** : Conçue pour être facile à utiliser sur des écrans de différentes tailles.
- - **Recherche avancée d'aliments** :
    - Intégration d'une API pour afficher des informations nutritionnelles détaillées.
    - Résultats personnalisables en fonction de mots-clés saisis par l'utilisateur.
- **Détail des aliments** :
    - Page de détail présentant les informations sur un aliment spécifique.
    - Options de personnalisation de la quantité et de l'unité (g, kg, ml, L, etc.).
- **Ajout simplifié au profil utilisateur** :
    - Enregistrement des aliments directement dans Firebase pour un accès continu.
    - Calcul automatique des valeurs en fonction des unités et quantités.
- **Gestion des aliments liquides et solides** :
    - Les aliments sont automatiquement catégorisés pour simplifier les options d'unité.



## 📁 Les différents fichiers

Tous les fichiers se trouvent dans le dossier `lib`.

- **Pages** :
    - **Home** :
    - `activity_page.dart` : Page principale reprenant les activités de l'utilisateur. 
    - `dashboard_page.dart` : Page de tableau de bord de l'utilisateur, résumant les informations importantes.
    - `main_page.dart` : Page principale du profil de l'utilisateur.
        - **Profile** :
            - `activity_tracking_page.dart` : La page concernant les activités de l'utilisateur.
            - `nutrition_goal_page.dart` : Page ou l'utilisateur peut définir ses objectifs nutritionnels.
            - `personal_info_page.dart` : Page de profil de l'utilisateur.
        - **Logs** :
            - `home_page.dart` : Page d'accueil de l'application.
            - `login_page.dart` : Page de connexion de l'utilisateur.
            - `register_page.dart` : Page d'inscription pour les nouveaux utilisateurs.

- **Models** :
    - `add_food_page.dart` : Page permettant d'ajouter un nouvel aliment via des formulaires.
    - `food.dart` : Modèle de données pour les aliments, définissant les attributs nutritionnels.
    - `FoodDetailsPage.dart` : Page de détail pour un aliment spécifique, affichant des informations détaillées.
    - `FoodSearchPage.dart` : Page de recherche d'aliments, permettant aux utilisateurs d'effectuer des recherches d'aliments.

- **Routes** :
    - `app_routes.dart` : Contient les routes de navigation de l'application.

- **firebase_options.dart** : Configuration pour l'intégration de Firebase.
- **main.dart** : Point d'entrée de l'application Flutter.
- **TODO.txt** : Liste des tâches à accomplir et améliorations à apporter.

## ⏳ État d'avancement
- [ ] Voir dans la TODO page.

### Bugs à corriger
- [ ] N/A

### Améliorations
- [ ] Ajouter un système de notifications pour les utilisateurs concernant des objectifs de santé.
- [ ] Intégrer des fonctionnalités de suivi des exercices physiques.
- [ ] Ajouter la reconnaissance d’aliments par photo.
- [ ] Améliorer la page add_food_page.dart pour une meilleure expérience utilisateur.
- [ ] Intégrer des notifications push pour encourager les utilisateurs à rester actifs.

## 💻 Technologies utilisées

- Flutter
- Dart
- Firebase (Firestore et Auth)
- HTTP (pour les requêtes API)
- Machine Learning (pour la reconnaissance d’aliments par photo)
