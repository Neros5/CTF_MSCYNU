# 🧠 Solution du CTF

Bienvenue dans la solution complète du challenge CTF. Cette épreuve est divisée en deux parties principales, correspondant à deux flags à récupérer. Chaque étape est conçue pour tester vos connaissances en **Linux**, **recherche de fichiers**, **gestion des permissions** et **escalade contrôlée de privilèges**.

---

## 🏁 FLAG 1 — Recherche dans l'Arborescence

### 🎯 Objectif

Ce flag teste votre capacité à :
- Explorer une structure de dossiers complexe
- Utiliser des commandes de recherche efficaces (`grep`, `tree`)
- Observer les détails (majuscules, indices dans les fichiers)

---

### 🛠 Étapes à suivre

1. **Accéder au répertoire CTF**
   ```bash
   cd /home/ctf
   ```

2. **Lancer le script de construction** (si ce n'est pas déjà fait) :
   ```bash
   sudo ./construction.sh
   ```

3. **Observation de la structure créée**
   
   Deux dossiers apparaîtront :
   - `flag_1/`
   - `flag_2/`
   
   Dans ce challenge, seul le flag_1 est actif. Le README donne un indice : "vous devez chercher 'flag'".

4. **Explorer la structure**
   ```bash
   cd flag_1
   tree
   ```
   
   Vous verrez une arborescence profonde :
   - 10 dossiers principaux
   - Chacun contient 10 sous-dossiers
   - Chacun contient encore 10 sous-dossiers
   - Et dans chaque dossier final : un fichier .txt
   
   Cela fait 1000 fichiers au total !

5. **Lancer une recherche avec grep**
   
   ⚠️ **Le piège** : dans le message, on dit de chercher flag, mais le flag réel est écrit en majuscules : **FLAG**.
   
   Utilisez donc :
   ```bash
   grep -R "FLAG" .
   ```
   
   Cette commande va rechercher récursivement tous les fichiers contenant le mot FLAG.

6. **Résultat**
   
   Vous trouverez une ligne du type :
   ```
   ./dossier_5/dossier_8/dossier_2/abcd1234.txt:FLAG{Nadhir_}
   ```

### ✅ Conclusion

Bravo ! Vous venez de récupérer le premier flag.

---

## 🔐 FLAG 2 — Escalade de Privilèges Contrôlée

### 🎯 Objectif

Ce flag vise à tester votre compréhension de :
- L'isolation des utilisateurs
- Les permissions UNIX
- Le fonctionnement de sudo
- L'exécution de script avec privilèges restreints

### 📜 Situation

Dans le dossier `/home/ctf/flag_2`, vous trouverez :
- Un fichier `journal.txt` contenant l'indice suivant :
  ```
  "Bonjour, je suis Alice et j'ai volé le morceau de Flag que vous cherchez ! Je l'ai caché chez moi mais il n'y a que moi qui ai la clé pour rentrer là-bas."
  ```
- Un fichier `secret_flag.txt`, inaccessible à l'utilisateur joueur
- Un script : `run_as_alice.sh`

### 🧩 Résolution

1. **Lire le journal**
   ```bash
   cat /home/ctf/flag_2/journal.txt
   ```
   Ce fichier vous apprend que l'utilisateur alice détient le flag.

2. **Tenter de lire le flag**
   ```bash
   cat /home/ctf/flag_2/secret_flag.txt
   ```
   **Résultat :**
   ```
   cat: permission denied
   ```
   ➜ Seul alice a le droit de lire ce fichier (chmod 600, propriété alice:alice).

3. **Examiner le script d'accès**
   ```bash
   ls -l /home/ctf/flag_2/run_as_alice.sh
   cat /home/ctf/flag_2/run_as_alice.sh
   ```
   
   Ce script contient :
   ```bash
   #!/bin/bash
   su - alice
   ```
   
   Il permet de passer dans la session de l'utilisateur alice, mais est protégé (chmod 700).

4. **Utiliser sudo de manière restreinte**
   
   Le script a été autorisé dans `/etc/sudoers.d/` pour que joueur puisse l'exécuter et devenir Alice. 

   On peut s'en rendre compte via la commande bash : 

   ```bash
    sudo -l
   ```
   
   Lancez donc :
   ```bash
   sudo /home/ctf/flag_2/run_as_alice.sh
   ```
   
   ➜ Vous êtes maintenant dans la session d'Alice !

5. **Lire le flag**
   ```bash
   cat /home/ctf/flag_2/secret_flag.txt
   ```
   
   **Résultat :**
   ```
   FLAG{Soren}
   ```

### ✅ Conclusion

Vous avez accédé au second flag.
