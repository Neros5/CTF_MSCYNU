# 📄 Documentation Technique — Script de Lancement CTF

## 🛠 Objectif

Ce script Bash permet de déployer un environnement CTF (Capture The Flag) sur une machine Linux. Il crée deux challenges (Flag 1 et Flag 2) et configure les utilisateurs, les permissions, ainsi que quelques indices pour orienter le joueur.

---

## ⚙️ Outils et Technologies Utilisés

- **Bash** : Langage de script utilisé pour automatiser l’installation et la configuration.
- **Utilitaires système** :
  - `useradd`, `groupadd` : Gestion des utilisateurs et groupes.
  - `chpasswd` : Définition du mot de passe utilisateur.
  - `chmod`, `chown` : Gestion des permissions.
  - `echo`, `mkdir`, `tr`, `urandom` : Commandes Unix pour la création de fichiers/dossiers, génération aléatoire, etc.
  - `/etc/sudoers.d/` : Ajout de règles `sudo` spécifiques pour l'utilisateur.

---

## 👥 Utilisateurs et Groupes

- **Groupe `ctfplayer`** : Groupe système créé pour le joueur.
- **Utilisateur `joueur`** :
  - Membre du groupe `ctfplayer`.
  - Mot de passe défini par défaut : `joueur`.
- **Utilisateur `alice`** :
  - Utilisé dans le challenge du Flag 2.
  - Détient un fichier protégé (`secret_flag.txt`) lisible uniquement par elle.

---

## 🧩 Flag 1 — Exploration de Dossiers

### Méthode de Création

- Création d’un répertoire `/home/ctf/flag_1`.
- Génération automatique d’une **arborescence de 3 niveaux**, chacun contenant 10 dossiers (1000 combinaisons possibles).
- Dans chaque dossier final, un fichier `.txt` avec du contenu.
- Un seul fichier parmi les 1000 contient le **vrai flag**, les autres sont des leurres.

### Contenu du Flag

```txt
FLAG{Nadhir_}
```

## 🔐 Flag 2 — Escalade de Privilèges et Sécurité des Fichiers

### 📁 Dossier de travail

- Dossier de destination : `/home/ctf/flag_2`
- Contenu :
  - `secret_flag.txt` : le flag caché
  - `journal.txt` : un indice narratif
  - `run_as_alice.sh` : script d’escalade contrôlée

---

### 🧠 Contexte du Challenge

Le joueur découvre un journal indiquant qu’un personnage fictif, **Alice**, détient un morceau de flag. Le joueur n’a pas accès direct à ses fichiers, mais peut trouver un moyen **légal et contrôlé** d’accéder à son environnement.

---

### 🧩 Méthode de Création

1. **Création de l'utilisateur `alice`** :
   - Compte utilisateur avec son propre home.
   - Fichier `secret_flag.txt` placé dans `/home/ctf/flag_2`, lisible uniquement par `alice`.

2. **Indice narratif (`journal.txt`)** :
   - Un message textuel orientant le joueur vers l’idée que le flag est détenu par Alice.

3. **Protection du Flag** :
   - Permissions : `chmod 600` pour que seul Alice puisse lire le fichier.
   - Propriété : `alice:alice`.

4. **Script `run_as_alice.sh`** :
   - Contient : `su - alice`
   - Propriété : `root:root`, exécutable uniquement par root.
   - Ce script est la **clé d’accès autorisée** au compte d’Alice.

5. **Accès via `sudo`** :
   - Ajout d’une règle spécifique dans `/etc/sudoers.d/ctf_clue` :
     ```bash
     joueur ALL=(ALL) NOPASSWD: /home/ctf/flag_2/run_as_alice.sh
     ```
   - Cela permet à `joueur` d’exécuter **uniquement ce script** sans mot de passe, et donc d’accéder à l’environnement d’Alice sans pouvoir abuser de `sudo`.

---

### 📄 Contenu du Flag

```txt
FLAG{Soren}

