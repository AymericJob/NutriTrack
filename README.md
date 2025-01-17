# NutriTrack

NutriTrack est une application Flutter conçue pour aider les utilisateurs à gérer leur alimentation et leur santé de manière simple et efficace.

## 🔍 Aperçu de notre application

NutriTrack permet aux utilisateurs de suivre leur consommation alimentaire, d'atteindre leurs objectifs de santé et de personnaliser leur expérience en fonction de leurs besoins nutritionnels. L'application propose des fonctionnalités avancées telles que la recherche d'aliments, l'ajout manuel d'aliments, la reconnaissance d'aliments par photo et des rapports détaillés sur les apports nutritionnels.

## 📲 Applications similaires

Voici quelques applications similaires dans le domaine du suivi alimentaire :

- **MyFitnessPal**
    - **Description** : MyFitnessPal est l'une des applications les plus populaires pour le suivi de l'alimentation et de l'activité physique. Elle dispose d'une immense base de données alimentaire.
    - **Fonctionnalités principales** :
        - Scanner de code-barres pour ajouter des aliments rapidement.
        - Suivi des calories, macronutriments et micronutriments.
        - Intégration avec des dispositifs tiers comme Fitbit et Garmin.
    - **Liens** :
        - iOS : [MyFitnessPal sur l'App Store](https://apps.apple.com/us/app/myfitnesspal/id568832228)
        - Android : [MyFitnessPal sur Google Play](https://play.google.com/store/apps/details?id=com.myfitnesspal.android)

- **Lose It!**
    - **Description** : Lose It! se concentre sur la perte de poids avec une interface simple et des outils ludiques.
    - **Fonctionnalités principales** :
        - Suivi des calories et objectifs quotidiens personnalisés.
        - Scanner de code-barres pour une entrée rapide des aliments.
    - **Liens** :
        - iOS : [Lose It! sur l'App Store](https://apps.apple.com/us/app/lose-it/id297368587)
        - Android : [Lose It! sur Google Play](https://play.google.com/store/apps/details?id=com.loseit)

- **Cronometer**
    - **Description** : Cronometer se spécialise dans l'analyse nutritionnelle avancée, adaptée aux régimes spécifiques ou besoins médicaux.
    - **Fonctionnalités principales** :
        - Suivi détaillé des calories, macronutriments et micronutriments (vitamines, minéraux).
        - Outils pour gérer des régimes spécifiques.
    - **Liens** :
        - iOS : [Cronometer sur l'App Store](https://apps.apple.com/us/app/cronometer/id1049223637)
        - Android : [Cronometer sur Google Play](https://play.google.com/store/apps/details?id=com.cronometer.android)

- **Yazio**
    - **Description** : Yazio aide à la gestion de l’alimentation équilibrée et du jeûne intermittent.
    - **Fonctionnalités principales** :
        - Plans de repas personnalisés basés sur les objectifs de santé.
        - Intégration avec Google Fit et Apple Health.
    - **Liens** :
        - iOS : [Yazio sur l'App Store](https://apps.apple.com/us/app/yazio/id946099227)
        - Android : [Yazio sur Google Play](https://play.google.com/store/apps/details?id=com.yazio.android)

## 🤔 MoodBoard

![NutriTrack](https://mir-s3-cdn-cf.behance.net/projects/404/436b24196708837.Y3JvcCw5ODM5LDc2OTYsODAzLDA.png)  
![NutriTrack](https://cdn.dribbble.com/userupload/2957372/file/original-f46379cab48c97180d43d0b8db289672.png?resize=400x0)  
![NutriTrack](https://images.everydayhealth.com/images/diet-nutrition/weight/lose-it-app-review-1440x810.jpg)  
![NutriTrack](https://cronometer.com/blog/wp-content/uploads/2024/08/870x580-Blog-Image-%E2%80%93-target-settings-1-scaled.jpg)  
![NutriTrack](https://images.yazio.com/frontend/app-lp/main/composition-ios-fr.png?w=400)

## 📍 Site Map

![Site_map drawio](https://github.com/user-attachments/assets/a1d399e9-20fb-4495-92cd-b3a6dd71d008)

## 👀 Design de l'application

TODO

## ⚙️ Fonctionnalités de l'application

- **Ajout d'aliments** : Les utilisateurs peuvent ajouter des aliments manuellement, via un code-barres ou par reconnaissance d'image.
- **Recherche d'aliments** : Permet aux utilisateurs de rechercher des aliments en utilisant des mots-clés pour trouver des informations nutritionnelles.
- **Statistiques nutritionnelles** : Affiche un résumé des calories, glucides, lipides et protéines consommés.
- **Sauvegarde des aliments** : Les utilisateurs peuvent sauvegarder leurs aliments favoris pour un accès rapide.
- **Interface utilisateur intuitive** : Conçue pour être facile à utiliser sur des écrans de différentes tailles.
- **Recherche avancée d'aliments** :
    - Intégration d'une API pour afficher des informations nutritionnelles détaillées.
    - Résultats personnalisables selon les mots-clés saisis par l'utilisateur.
- **Détail des aliments** :
    - Page de détail présentant les informations sur un aliment spécifique.
    - Options de personnalisation de la quantité et de l'unité.
- **Ajout simplifié au profil utilisateur** :
    - Enregistrement des aliments directement dans Firebase pour un accès continu.
    - Calcul automatique des valeurs en fonction des unités et quantités.
- **Multilinguisme** :
    - L'application prend en charge plusieurs langues, y compris l'anglais et le français, pour une expérience utilisateur personnalisée.

## 📁 Les différents fichiers

Tous les fichiers se trouvent dans le dossier `lib`.

- **Pages** :
    - **Home** :
        - `activity_page.dart` : Page principale reprenant les activités de l'utilisateur.
        - `dashboard_page.dart` : Page de tableau de bord de l'utilisateur, résumant les informations importantes.
        - `main_page.dart` : Page principale du profil de l'utilisateur.
    - **Profile** :
        - `activity_tracking_page.dart` : La page concernant les activités de l'utilisateur.
        - `nutrition_goal_page.dart` : Page où l'utilisateur peut définir ses objectifs nutritionnels.
        - `personal_info_page.dart` : Page de profil de l'utilisateur.
    - **Logs** :
        - `home_page.dart` : Page d'accueil de l'application.
        - `login_page.dart` : Page de connexion de l'utilisateur.
        - `register_page.dart` : Page d'inscription pour les nouveaux utilisateurs.

- **Models** :
    - `add_food_page.dart` : Page permettant d'ajouter un nouvel aliment via des formulaires.
    - `food.dart` : Modèle de données pour les aliments, définissant les attributs nutritionnels.
    - `FoodDetailsPage.dart` : Page de détail pour un aliment spécifique.
    - `FoodSearchPage.dart` : Page de recherche d'aliments.

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

## 💻 Technologies utilisées

- Flutter
- Dart
- Firebase (Firestore et Auth)
- HTTP (pour les requêtes API)
- Multilinguisme via la bibliothèque `intl` pour la gestion de plusieurs langues
